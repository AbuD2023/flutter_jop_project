import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jop_project/Controller/api_controller.dart';
import 'package:jop_project/Models/skils_model.dart';

class SkillsProvider extends ChangeNotifier {
  final ApiController _apiController = ApiController();

  //setters
  List<SkilsModel> _skills = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<SkilsModel> get skills => _skills;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getSkills() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiController.get<List<SkilsModel>>(
        endpoint: 'Skils',
        fromJson: (json) => (json is List)
            ? json.map((item) => SkilsModel.fromJson(item)).toList()
            : json['items'].map((item) => SkilsModel.fromJson(item)).toList(),
        // headers: {'Authorization': 'Bearer ${token}'},
      );
      if (response.isNotEmpty) {
        _skills = response;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addSkill({required SkilsModel skilsModel}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiController.post<SkilsModel>(
        endpoint: 'Skils',
        data: skilsModel.toJson(),
        fromJson: SkilsModel.fromJson,
      );
      if (response.id != null) {
        log(_skills.length.toString(), name: '_skills Befor add _skills');
        log(response.name.toString(), name: 'response_add_skills');
        _skills.add(response);
        log(_skills.length.toString(), name: '_jobs after add _skills');
      } else {
        throw Exception('فشل إنشاء المهارة حاول مجدداً');
      }
    } catch (e) {
      log('خطأ في إضافة المهارة: $e');
      _error = 'فشل في إضافة المهارة';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
