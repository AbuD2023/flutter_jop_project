import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jop_project/Controller/api_controller.dart';
import 'package:jop_project/Models/experience_model.dart';

class ExperienceProvider extends ChangeNotifier {
  final ApiController _apiController = ApiController();

  // Setters
  List<ExperienceModel> _experiences = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<ExperienceModel> get experiences => _experiences;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getExperiences() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiController.get<List<ExperienceModel>>(
        endpoint: 'Experiences',
        fromJson: (json) => (json is List)
            ? json.map((item) => ExperienceModel.fromJson(item)).toList()
            : json['items']
                .map((item) => ExperienceModel.fromJson(item))
                .toList(),
        // headers: {'Authorization': 'Bearer ${token}'},
      );
      if (response.isNotEmpty) {
        _experiences = response;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addExperiences(
      {required ExperienceModel experiencesModel}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      experiencesModel.id = 0;
      final response = await _apiController.post<ExperienceModel>(
        endpoint: 'Experiences',
        data: experiencesModel.toJson(),
        fromJson: ExperienceModel.fromJson,
      );
      if (response.id != null) {
        log(_experiences.length.toString(),
            name: '_experiences Befor add _experiences');
        log(response.nameExper.toString(), name: 'response_add_experiences');
        _experiences.add(response);
        log(_experiences.length.toString(),
            name: '_experiences after add _experiences');
        getExperiences();
      } else {
        throw Exception('فشل إنشاء الخبرة حاول مجدداً');
      }
    } catch (e) {
      log('خطأ في إضافة الخبرة: $e');
      _error = 'فشل في إضافة الخبرة';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
