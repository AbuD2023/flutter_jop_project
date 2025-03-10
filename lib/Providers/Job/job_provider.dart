import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jop_project/Controller/api_controller.dart';
import 'package:jop_project/Models/job_advertisement_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobsProvider with ChangeNotifier {
  final ApiController _apiController = ApiController();

  //setters
  List<JobAdvertisementModel> _jobs = [];
  List<JobAdvertisementModel> _jobsSearch = [];
  bool _isLoading = false;
  String? _error;
  TextEditingController _controller = TextEditingController();

  // Getters
  List<JobAdvertisementModel> get jobs => _jobs;
  List<JobAdvertisementModel> get jobsSearch => _jobsSearch;
  bool get isLoading => _isLoading;
  String? get error => _error;

  TextEditingController get controller => _controller;

  Future<void> getJobs() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // // محاولة جلب الدول من التخزين المحلي أولاً
      final prefs = await SharedPreferences.getInstance();

      // جلب البيانات من API
      final response = await _apiController.get<List<JobAdvertisementModel>>(
        endpoint: 'Job_advertisement',
        fromJson: (json) => (json is List)
            ? json.map((item) => JobAdvertisementModel.fromJson(item)).toList()
            : json['items']
                .map((item) => JobAdvertisementModel.fromJson(item))
                .toList(),
      );
      if (response.isNotEmpty) {
        _jobs = response;
        // تخزين البيانات محلياً
        await prefs.setString(
            'jobs', json.encode(_jobs.map((jop) => jop.toJson()).toList()));
      }
      // notifyListeners();
    } catch (e) {
      // محاولة جلب الدول من التخزين المحلي أولاً
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('jobs');

      if (cachedData != null) {
        final List<dynamic> decodedData = json.decode(cachedData);
        _jobs = decodedData
            .map((item) => JobAdvertisementModel.fromJson(item))
            .toList();
        notifyListeners();
      } else {
        log('خطأ في جلب الوظائف: $e');
        _error = 'فشل في جلب قائمة الوظائف';
        notifyListeners();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getJobsByCompanyId({required int companyId}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // محاولة جلب الدول من التخزين المحلي أولاً
      final prefs = await SharedPreferences.getInstance();

      // جلب البيانات من API
      final response = await _apiController.get<List<JobAdvertisementModel>>(
        endpoint: 'Job_advertisement',
        fromJson: (json) => (json is List)
            ? json
                .where((job) => job['companyId'] == companyId)
                .map((item) => JobAdvertisementModel.fromJson(item))
                .toList()
            : json['items']
                .where((job) => job['companyId'] == companyId)
                .map((item) => JobAdvertisementModel.fromJson(item))
                .toList(),
      );
      if (response.isNotEmpty) {
        _jobs = response;
        // تخزين البيانات محلياً
        await prefs.setString(
            'jobs_Company',
            json.encode(_jobs
                .where((job) => job.companyId == companyId)
                .map((jop) => jop.toJson())
                .toList()));
      }
      // notifyListeners();
    } catch (e) {
      // محاولة جلب الدول من التخزين المحلي أولاً
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('jobs_Company');

      if (cachedData != null) {
        log(cachedData, name: 'cachedData_jobs_Company');
        final List<dynamic> decodedData = json.decode(cachedData);
        _jobs = decodedData
            .where((job) => job['companyId'] == companyId)
            .map((item) => JobAdvertisementModel.fromJson(item))
            .toList();
        notifyListeners();
      } else {
        log('خطأ في جلب الوظائف: $e');
        _error = 'فشل في جلب قائمة الوظائف';
        notifyListeners();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addJobs(
      {required JobAdvertisementModel jobAdvertisementModel}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiController.post<JobAdvertisementModel>(
        endpoint: 'Job_advertisement',
        data: jobAdvertisementModel.toJson(),
        fromJson: JobAdvertisementModel.fromJson,
        headers: {
          // 'Authorization': 'Bearer $_token',
        },
      );
      if (response.companyId != null) {
        log(_jobs.length.toString(), name: '_jobs Befor add _job');
        log(response.descrip.toString(), name: 'response_add_job');
        _jobs.add(response);
        log(_jobs.length.toString(), name: '_jobs after add _job');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'jobs', json.encode(_jobs.map((jop) => jop.toJson()).toList()));
      } else {
        throw Exception('فشل إنشاء الوظيفة حاول مجدداً');
      }
    } catch (e) {
      log('خطأ في إضافة الوظيفة: $e');
      _error = 'فشل في إضافة الوظيفة';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateJobs(
      {required JobAdvertisementModel jobAdvertisementModel}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      final response = await _apiController.put<JobAdvertisementModel>(
        endpoint: 'Job_advertisement/${jobAdvertisementModel.id}',
        data: jobAdvertisementModel.toJson(),
        fromJson: JobAdvertisementModel.fromJson,
      );
      if (response.id != null) {
        final index =
            _jobs.indexWhere((job) => job.id == jobAdvertisementModel.id);
        if (index != -1) {
          _jobs[index] = response;

          // تحديث التخزين المحلي
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('cachedData_jobs_Company',
              json.encode(_jobs.map((country) => country.toJson()).toList()));
          // إضافة رسالة نجاح
          Get.snackbar(
            'نجاح',
            'تم تعديل الوظيفة بنجاح',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            icon: const Icon(Icons.check, color: Colors.white),
            duration: const Duration(seconds: 3),
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        throw Exception('فشل تعديل الوظيفة');
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
      log('خطأ في تعديل الوظيفة: $e');
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteJob({required int jobId}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // تسجيل عملية الحذف
      log('جاري حذف الوظيفة برقم: $jobId');

      await _apiController.delete(
        endpoint: 'Job_advertisement/$jobId',
      );

      // حذف الدولة من القائمة المحلية
      _jobs.removeWhere((job) => job.id == jobId);

      // تحديث التخزين المحلي
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jobs_Company',
          json.encode(_jobs.map((job) => job.toJson()).toList()));

      // إظهار رسالة نجاح
      Get.snackbar(
        'نجاح',
        'تم حذف الوظيفة بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      notifyListeners();
    } on DioException catch (e) {
      log('خطأ Dio في حذف الوظيفة: ${e.message}');
      if (e.response != null) {
        _error = 'فشل في حذف الوظيفة: ${e.response?.data}';
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
      log('خطأ في حذف الوظيفة: $e');
      _error = 'فشل في حذف الوظيفة';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search() {
    String query = _controller.text;
    _jobsSearch = _jobs
        .where(
            (job) => job.nameJob!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }
}
