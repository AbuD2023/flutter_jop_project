import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:jop_project/Controller/api_controller.dart';
import 'package:jop_project/Models/company_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompaniesProvider extends ChangeNotifier {
  final ApiController _apiController = ApiController();

  //setters
  List<CompanyModel> _companies = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<CompanyModel> get companies => _companies;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // دالة لجلب جميع الشركات
  Future<void> getAllCompanies() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // // محاولة جلب الدول من التخزين المحلي أولاً
      final prefs = await SharedPreferences.getInstance();

      // جلب البيانات من API
      final response = await _apiController.get<List<CompanyModel>>(
        endpoint: 'Companies',
        fromJson: (json) => (json is List)
            ? json.map((item) => CompanyModel.fromJson(item)).toList()
            : json['items'].map((item) => CompanyModel.fromJson(item)).toList(),
      );
      if (response.isNotEmpty) {
        _companies = response;
        // تخزين البيانات محلياً
        await prefs.setString('getAllCompanies',
            json.encode(_companies.map((jop) => jop.toJson()).toList()));
      }
    } catch (e) {
      // محاولة جلب الدول من التخزين المحلي أولاً
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('getAllCompanies');

      if (cachedData != null) {
        final List<dynamic> decodedData = json.decode(cachedData);
        _companies =
            decodedData.map((item) => CompanyModel.fromJson(item)).toList();
        notifyListeners();
      } else {
        log('خطأ في جلب الشركات: $e');
        _error = 'فشل في جلب قائمة الشركات';
        notifyListeners();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // دالة للبحث عن شركة باستخدام الاسم
  List<CompanyModel> searchCompaniesByName(String query) {
    return _companies
        .where((company) =>
            company.nameCompany!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // دالة للحصول على شركة بواسطة المعرف
  CompanyModel? getCompanyById(int id) {
    try {
      return _companies.firstWhere((company) => company.id == id);
    } catch (e) {
      return null;
    }
  }
}
