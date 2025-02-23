import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jop_project/Controller/api_controller.dart';
import 'package:jop_project/Models/searcher_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchersProvider extends ChangeNotifier {
  final ApiController _apiController = ApiController();

  // setters
  List<SearchersModel> _searchers = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<SearchersModel> get searchers => _searchers;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getAllSearchers() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      // // محاولة جلب الدول من التخزين المحلي أولاً
      final prefs = await SharedPreferences.getInstance();

      // جلب البيانات من API
      final response = await _apiController.get<List<SearchersModel>>(
        endpoint: 'Searchers',
        fromJson: (json) => (json is List)
            ? json.map((item) => SearchersModel.fromJson(item)).toList()
            : json['items']
                .map((item) => SearchersModel.fromJson(item))
                .toList(),
      );
      if (response.isNotEmpty) {
        _searchers = response;
        // تخزين البيانات محلياً
        await prefs.setString('getAllSearchers',
            json.encode(_searchers.map((jop) => jop.toJson()).toList()));
      }
    } catch (e) {
      // محاولة جلب الدول من التخزين المحلي أولاً
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('getAllSearchers');

      if (cachedData != null) {
        final List<dynamic> decodedData = json.decode(cachedData);
        _searchers =
            decodedData.map((item) => SearchersModel.fromJson(item)).toList();
        notifyListeners();
      } else {
        log('خطأ في جلب المتقدمين: $e');
        _error = 'فشل في جلب قائمة المتقدمين';
        notifyListeners();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // دالة للبحث عن باحث باستخدام الاسم
  List<SearchersModel> searchSearchersByName(String query) {
    return _searchers
        .where((searcher) =>
            searcher.fullName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // دالة للحصول على باحث بواسطة المعرف
  SearchersModel? getSearcherById(int id) {
    try {
      return _searchers.firstWhere((searcher) => searcher.id == id);
    } catch (e) {
      return null;
    }
  }
}
