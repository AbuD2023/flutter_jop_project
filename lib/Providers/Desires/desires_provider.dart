import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jop_project/Controller/api_controller.dart';
import 'package:jop_project/Models/skils_model.dart';

class DesiresProvider extends ChangeNotifier {
  final ApiController _apiController = ApiController();

  //setters
  List<SkilsModel> _desires = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<SkilsModel> get desires => _desires;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getDesires() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiController.get<List<SkilsModel>>(
        endpoint: 'interests',
        fromJson: (json) => (json is List)
            ? json.map((item) => SkilsModel.fromJson(item)).toList()
            : json['items'].map((item) => SkilsModel.fromJson(item)).toList(),
        // headers: {'Authorization': 'Bearer ${token}'},
      );
      if (response.isNotEmpty) {
        _desires = response;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addDesires({required SkilsModel desiresModel}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiController.post<SkilsModel>(
        endpoint: 'interests',
        data: desiresModel.toJson(),
        fromJson: SkilsModel.fromJson,
      );
      if (response.id != null) {
        log(_desires.length.toString(), name: '_desires Befor add _desires');
        log(response.name.toString(), name: 'response_add_desires');
        _desires.add(response);
        log(_desires.length.toString(), name: '_desires after add _desires');
        getDesires();
      } else {
        throw Exception('فشل إنشاء الرغبة حاول مجدداً');
      }
    } catch (e) {
      log('خطأ في إضافة الرغبة: $e');
      _error = 'فشل في إضافة الرغبة';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
