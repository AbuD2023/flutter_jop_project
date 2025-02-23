import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jop_project/Controller/api_controller.dart';
import 'package:jop_project/Models/country_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class CountryProvider extends ChangeNotifier {
  final ApiController _apiController = ApiController();

  //setters
  List<CountryModel> _countries = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<CountryModel> get countries => _countries;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // جلب قائمة الدول
  Future<void> fetchCountries() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // محاولة جلب الدول من التخزين المحلي أولاً
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('countries');

      if (cachedData != null) {
        final List<dynamic> decodedData = json.decode(cachedData);
        _countries =
            decodedData.map((item) => CountryModel.fromJson(item)).toList();
        notifyListeners();
      }

      // جلب البيانات من API
      final response = await _apiController.get<List<CountryModel>>(
        endpoint: 'Countries',
        fromJson: (json) {
          log(json.toString());
          if (json is List) {
            return json.map((item) => CountryModel.fromJson(item)).toList();
          } else if (json is Map<String, dynamic>) {
            // إذا كانت البيانات في مصفوفة داخل الاستجابة
            if (json.containsKey('data') && json['data'] is List) {
              return (json['data'] as List)
                  .map((item) => CountryModel.fromJson(item))
                  .toList();
            }
            // إذا كانت البيانات مباشرة في الاستجابة
            else if (json.containsKey('items') && json['items'] is List) {
              return (json['items'] as List)
                  .map((item) => CountryModel.fromJson(item))
                  .toList();
            }
            // إذا كانت البيانات في المستوى الأعلى
            else {
              return [CountryModel.fromJson(json)];
            }
          }
          return [];
        },
      );

      if (response.isNotEmpty) {
        _countries = response;
        // تخزين البيانات محلياً
        await prefs.setString(
            'countries',
            json.encode(
                _countries.map((country) => country.toJson()).toList()));
      }

      notifyListeners();
    } catch (e) {
      log('خطأ في جلب الدول: $e');
      _error = 'فشل في جلب قائمة الدول';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // البحث عن دولة بالاسم
  List<CountryModel> searchCountries(String query) {
    if (query.isEmpty) return _countries;
    return _countries
        .where((country) =>
            country.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // الحصول على دولة بواسطة المعرف
  CountryModel? getCountryById(int id) {
    try {
      return _countries.firstWhere((country) => country.id == id);
    } catch (e) {
      return null;
    }
  }

  // تحديث قائمة الدول
  Future<void> refreshCountries() async {
    try {
      final response = await _apiController.get<List<dynamic>>(
        endpoint: 'Countries',
        fromJson: (json) => (json['data'] as List)
            .map((item) => CountryModel.fromJson(item))
            .toList(),
      );

      _countries = response
          .map((item) => CountryModel.fromJson(item as Map<String, dynamic>))
          .toList();

      // تحديث التخزين المحلي
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('countries',
          json.encode(_countries.map((country) => country.toJson()).toList()));

      notifyListeners();
    } catch (e) {
      log('خطأ في تحديث الدول: $e');
      _error = 'فشل في تحديث قائمة الدول';
      notifyListeners();
    }
  }

  // تحديث بيانات دولة
  Future<void> updateCountry(CountryModel updatedCountry) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // تسجيل البيانات قبل الإرسال
      log('تحديث الدولة: ${updatedCountry.toJson()}');

      final response = await _apiController.put<CountryModel>(
        endpoint: 'Countries/${updatedCountry.id}',
        data: updatedCountry.toJson(),
        fromJson: (json) {
          log('استجابة تحديث الدولة: $json');
          return CountryModel.fromJson(json);
        },
      );

      // تحديث الدولة في القائمة المحلية
      final index =
          _countries.indexWhere((country) => country.id == updatedCountry.id);
      if (index != -1) {
        _countries[index] = response;

        // تحديث التخزين المحلي
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'countries',
            json.encode(
                _countries.map((country) => country.toJson()).toList()));

        // إضافة رسالة نجاح
        Get.snackbar(
          'نجاح',
          'تم تحديث بيانات الدولة بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }

      notifyListeners();
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
      log('خطأ في تحديث الدولة: $e');
      _error = 'حدث خطأ غير متوقع';
      Get.snackbar(
        'خطأ',
        _error!,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // حذف دولة
  Future<void> deleteCountry(int countryId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // تسجيل عملية الحذف
      log('جاري حذف الدولة برقم: $countryId');

      await _apiController.delete(
        endpoint: 'Countries/$countryId',
      );

      // حذف الدولة من القائمة المحلية
      _countries.removeWhere((country) => country.id == countryId);

      // تحديث التخزين المحلي
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('countries',
          json.encode(_countries.map((country) => country.toJson()).toList()));

      // إظهار رسالة نجاح
      Get.snackbar(
        'نجاح',
        'تم حذف الدولة بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      notifyListeners();
    } on DioException catch (e) {
      log('خطأ Dio في حذف الدولة: ${e.message}');
      if (e.response != null) {
        _error = 'فشل في حذف الدولة: ${e.response?.data}';
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
      log('خطأ في حذف الدولة: $e');
      _error = 'حدث خطأ غير متوقع';
      Get.snackbar(
        'خطأ',
        _error!,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
