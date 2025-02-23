import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jop_project/Controller/api_controller.dart';
import 'package:jop_project/Models/orders_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderProvider extends ChangeNotifier {
  final ApiController _apiController = ApiController();

  //setters
  List<OrdersModel> _orders = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<OrdersModel> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getOrders() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // // محاولة جلب الدول من التخزين المحلي أولاً
      final prefs = await SharedPreferences.getInstance();

      // جلب البيانات من API
      final response = await _apiController.get<List<OrdersModel>>(
        endpoint: 'Orders',
        fromJson: (json) => (json is List)
            ? json.map((item) => OrdersModel.fromJson(item)).toList()
            : json['items'].map((item) => OrdersModel.fromJson(item)).toList(),
      );
      if (response.isNotEmpty) {
        _orders = response;
        // تخزين البيانات محلياً
        await prefs.setString('Orders',
            json.encode(_orders.map((order) => order.toJson()).toList()));
      }
      // notifyListeners();
    } catch (e) {
      // محاولة جلب الدول من التخزين المحلي أولاً
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('Orders');

      if (cachedData != null) {
        final List<dynamic> decodedData = json.decode(cachedData);
        _orders =
            decodedData.map((item) => OrdersModel.fromJson(item)).toList();
        notifyListeners();
      } else {
        log('خطأ في جلب الطلب: $e');
        _error = 'فشل في جلب قائمة الطلب';
        notifyListeners();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addOrders({required OrdersModel ordersModel}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiController.post<OrdersModel>(
        endpoint: 'Orders',
        data: ordersModel.toJson(),
        fromJson: OrdersModel.fromJson,
        headers: {
          // 'Authorization': 'Bearer $_token',
        },
      );
      if (response.jobAdvertisementId != null) {
        log(_orders.length.toString(), name: '_orders Befor add _orders');
        log(response.presentData.toString(), name: 'response_add_orders');
        _orders.add(response);
        log(_orders.length.toString(), name: '_orders after add _orders');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('Orders',
            json.encode(_orders.map((order) => order.toJson()).toList()));
      } else {
        throw Exception('فشل إنشاء الطلب حاول مجدداً');
      }
    } catch (e) {
      log('خطأ في إضافة الطلب: $e');
      _error = 'فشل في إضافة الطلب';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateOrders({required OrdersModel ordersModel}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      final response = await _apiController.put<OrdersModel>(
        endpoint: 'Orders/${ordersModel.id}',
        data: ordersModel.toJson(),
        fromJson: OrdersModel.fromJson,
      );
      if (response.id != null) {
        final index = _orders.indexWhere((job) => job.id == ordersModel.id);
        if (index != -1) {
          _orders[index] = response;

          // تحديث التخزين المحلي
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('Orders',
              json.encode(_orders.map((country) => country.toJson()).toList()));
          // إضافة رسالة نجاح
          // Get.snackbar(
          //   'نجاح',
          //   'تم تعديل الطلب بنجاح',
          //   backgroundColor: Colors.green,
          //   colorText: Colors.white,
          //   icon: const Icon(Icons.check, color: Colors.white),
          //   duration: const Duration(seconds: 3),
          //   snackPosition: SnackPosition.BOTTOM,
          // );
        }
      } else {
        throw Exception('فشل تعديل الطلب');
      }
    } on DioException catch (e) {
      log('خطأ Dio في تحديث الطلب: ${e.message}');
      if (e.response != null) {
        _error = 'فشل في تحديث الطلب: ${e.response?.data}';
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
      log('خطأ في تعديل الطلب: $e');
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteOrder({required int orderId}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // تسجيل عملية الحذف
      log('جاري حذف الطلب برقم: $orderId');

      await _apiController.delete(
        endpoint: 'Orders/$orderId',
      );

      // حذف الدولة من القائمة المحلية
      _orders.removeWhere((job) => job.id == orderId);

      // تحديث التخزين المحلي
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('Orders',
          json.encode(_orders.map((order) => order.toJson()).toList()));

      // إظهار رسالة نجاح
      Get.snackbar(
        'نجاح',
        'تم حذف الطلب بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      notifyListeners();
    } on DioException catch (e) {
      log('خطأ Dio في حذف الوظيفة: ${e.message}');
      if (e.response != null) {
        _error = 'فشل في حذف الطلب: ${e.response?.data}';
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
      log('خطأ في حذف الطلب: $e');
      _error = 'فشل في حذف الطلب';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Future<void> getOrdersByCompanyId({required int companyId}) async {
  //   try {
  //     _isLoading = true;
  //     _error = null;
  //     notifyListeners();
  //     // محاولة جلب الدول من التخزين المحلي أولاً
  //     final prefs = await SharedPreferences.getInstance();
  //     // جلب البيانات من API
  //     final response = await _apiController.get<List<OrdersModel>>(
  //       endpoint: 'Job_advertisement',
  //       fromJson: (json) => (json is List)
  //           ? json
  //               .where((job) => job['companyId'] == companyId)
  //               .map((item) => OrdersModel.fromJson(item))
  //               .toList()
  //           : json['items']
  //               .where((job) => job['companyId'] == companyId)
  //               .map((item) => OrdersModel.fromJson(item))
  //               .toList(),
  //     );
  //     if (response.isNotEmpty) {
  //       _jobs = response;
  //       // تخزين البيانات محلياً
  //       await prefs.setString(
  //           'jobs_Company',
  //           json.encode(_jobs
  //               .where((job) => job.companyId == companyId)
  //               .map((jop) => jop.toJson())
  //               .toList()));
  //     }
  //     // notifyListeners();
  //   } catch (e) {
  //     // محاولة جلب الدول من التخزين المحلي أولاً
  //     final prefs = await SharedPreferences.getInstance();
  //     final cachedData = prefs.getString('jobs_Company');
  //     if (cachedData != null) {
  //       log(cachedData, name: 'cachedData_jobs_Company');
  //       final List<dynamic> decodedData = json.decode(cachedData);
  //       _jobs = decodedData
  //           .where((job) => job['companyId'] == companyId)
  //           .map((item) => OrdersModel.fromJson(item))
  //           .toList();
  //       notifyListeners();
  //     } else {
  //       log('خطأ في جلب الوظائف: $e');
  //       _error = 'فشل في جلب قائمة الوظائف';
  //       notifyListeners();
  //     }
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }
}
