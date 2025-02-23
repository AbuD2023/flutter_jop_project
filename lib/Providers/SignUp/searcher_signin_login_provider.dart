import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jop_project/Controller/api_controller.dart';
import 'package:jop_project/Controller/image_uplode_controller.dart';
import 'package:jop_project/Models/login_response_model.dart';
import 'package:jop_project/Models/searcher_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearcherSigninLoginProvider extends ChangeNotifier {
  final ApiController _apiController = ApiController();
  final ImageUploadController _imageUploadController = ImageUploadController();
  SearchersModel? _currentSearcher;
  bool _isLoading = false;
  String? _error;
  String? _token;

  // Getters
  SearchersModel? get currentSearcher => _currentSearcher;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get token => _token;

  // تهيئة البيانات عند بدء التطبيق
  Future<void> initializeApp() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userType = prefs.getString('userType');
      final userId = prefs.getInt('userId');

      if (token != null && userType == "Searchers" && userId != null) {
        // محاولة جلب الدول من التخزين المحلي أولاً
        final prefs = await SharedPreferences.getInstance();
        final cachedData = prefs.getString('Searchers');

        if (cachedData != null) {
          final dynamic decodedData = json.decode(cachedData);
          _currentSearcher = SearchersModel.fromJson(decodedData);

          notifyListeners();
        }
        // جلب بيانات الشركة
        final searcherData = await _apiController.get<SearchersModel>(
          endpoint: 'Searchers/$userId',
          fromJson: (json) =>
              SearchersModel.fromJson(json as Map<String, dynamic>),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );
        _currentSearcher = searcherData;
        _token = token;

        if (searcherData.id != null) {
          _currentSearcher = searcherData;
          // تخزين البيانات محلياً
          await prefs.setString('Searchers', json.encode(_currentSearcher));
        }
        notifyListeners();
      }
    } catch (e) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userType = prefs.getString('userType');
      final userId = prefs.getInt('userId');

      if (token != null && userType == "Searchers" && userId != null) {
        final prefs = await SharedPreferences.getInstance();
        final cachedData = prefs.getString('Searchers');

        if (cachedData != null) {
          final dynamic decodedData = json.decode(cachedData);
          _currentSearcher = SearchersModel.fromJson(decodedData);
          _token = token;
          notifyListeners();
        } else {
          log('خطأ في تهيئة التطبيق: $e');
          _error = e.toString();
          notifyListeners();
          await logout(); // تسجيل الخروج في حالة حدوث خطأ
        }
      } else {
        log('خطأ في تهيئة التطبيق: $e');
        _error = e.toString();
        notifyListeners();
        await logout(); // تسجيل الخروج في حالة حدوث خطأ
      }
    }
  }

  // تسجيل شركة جديدة
  Future<void> registerSearcher({
    required SearchersModel searchersModel,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // إذا كان هناك صورة، قم برفعها أولاً
      if (searchersModel.img != null && searchersModel.img!.isNotEmpty) {
        log(searchersModel.img.toString());
        final imageFile = File(searchersModel.img!);
        final imageUrl = await _imageUploadController.uploadImage(imageFile);
        if (imageUrl != null) {
          searchersModel.img = imageUrl;
        } else {
          throw Exception('فشل في رفع الصورة');
        }
      }

      final response = await _apiController.post<SearchersModel>(
        endpoint: 'Searchers',
        data: searchersModel.toJson(),
        fromJson: SearchersModel.fromJson,
        headers: {
          // 'Authorization': 'Bearer $_token',
        },
      );

      // ignore: unnecessary_null_comparison
      if (response != null) {
        _currentSearcher = response;
      } else {
        throw Exception('فشل إنشاء الحساب حاول مجدداً');
      }
    } catch (e) {
      _error = 'فشل إنشاء الحساب: ${e.toString()}';

      throw Exception('فشل إنشاء الحساب حاول مجدداً');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // تسجيل الدخول
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiController.post<LoginResponseModel>(
        endpoint: 'Users/Userlogin',
        data: {
          'email': email,
          'password': password,
        },
        fromJson: LoginResponseModel.fromJson,
      );

      // حفظ بيانات الجلسة
      if (response.token.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.token);
        await prefs.setString('userType', response.userType);
        await prefs.setInt('userId', response.id);
        _token = response.token;
      }

      // جلب بيانات الشركة إذا كان المستخدم شركة
      if (response.userType == "Searchers") {
        try {
          final searcherData = await _apiController.get<SearchersModel>(
            endpoint: 'Searchers/${response.id}',
            fromJson: (json) =>
                SearchersModel.fromJson(json as Map<String, dynamic>),
            headers: {
              'Authorization': 'Bearer ${response.token}',
            },
          );
          _currentSearcher = searcherData;

          // حفظ بيانات الشركة
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('Searchers', jsonEncode(searcherData.toJson()));
        } catch (e) {
          log('خطأ في جلب بيانات الشركة: $e');
        }
      }

      return response;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // تسجيل الخروج
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // حذف جميع البيانات المحفوظة
      _currentSearcher = null;
      _token = null;
      notifyListeners();
    } catch (e) {
      log('خطأ في تسجيل الخروج: $e');
      rethrow;
    }
  }

  Future<void> updateSearchers({required SearchersModel searchersModel}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // إذا كان هناك صورة، قم برفعها أولاً
      if ((searchersModel.img != null && searchersModel.img!.isNotEmpty) &&
          (searchersModel.img != _currentSearcher!.img)) {
        log(searchersModel.img.toString(), name: 'Image');
        final imageFile = File(searchersModel.img!);
        final imageUrl = await _imageUploadController.uploadImage(imageFile);
        if (imageUrl != null) {
          searchersModel.img = imageUrl;
        } else {
          // throw Exception('فشل في رفع الصورة');
        }
      }
      // إذا كان هناك ملف بي دي اف قم برفعها أولاً
      if ((searchersModel.cv != null && searchersModel.cv!.isNotEmpty) &&
          (searchersModel.cv != _currentSearcher!.cv)) {
        log(searchersModel.cv.toString(), name: 'CV');
        final pdfFile = File(searchersModel.cv!);
        final pdfUrl = await _imageUploadController.uploadPDF(pdfFile);
        if (pdfUrl != null) {
          searchersModel.cv = pdfUrl;
        } else {
          // throw Exception('فشل في رفع ملف البي دي اف');
        }
      }

      final response = await _apiController.put<SearchersModel>(
        endpoint: 'Searchers/${searchersModel.id}',
        data: searchersModel.toJson(),
        fromJson: SearchersModel.fromJson,
      );
      if (response.id != null) {
        _currentSearcher = response;

        // تحديث التخزين المحلي
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'Searchers', json.encode(_currentSearcher!.toJson()));
        // إضافة رسالة نجاح
        Get.snackbar(
          'نجاح',
          'تم تعديل البيانات بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(Icons.check, color: Colors.white),
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        throw Exception('فشل تعديل البيانات');
      }
    } on DioException catch (e) {
      log('خطأ Dio في تحديث الدولة: ${e.message}');
      if (e.response != null) {
        _error = 'فشل في تحديث البيانات: ${e.response?.data}';
      } else {
        _error = 'فشل في الاتصال بالخادم';
      }
      Get.snackbar(
        'خطأ',
        _error ?? 'حدث خطأ غير متوقع',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      notifyListeners();
      rethrow;
    } catch (e) {
      log('خطأ في تعديل البيانات: $e');
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // إعادة تعيين كلمة المرور
  // Future<void> resetPassword({required String email}) async {
  //   try {
  //     _isLoading = true;
  //     _error = null;
  //     notifyListeners();

  //     await _apiController.post<void>(
  //       endpoint: 'companies/reset-password',
  //       data: {'email': email},
  //       fromJson: (_) => null,
  //     );
  //   } catch (e) {
  //     _error = e.toString();
  //     notifyListeners();
  //     rethrow;
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }
}
