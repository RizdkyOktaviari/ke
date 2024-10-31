import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/exercise_model.dart';
class ExerciseProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> addExerciseLog(String token, Exercise exercise) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://108.137.67.23/api/exercise-log'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(exercise.toJson()),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _error = data['message'] ?? 'Failed to add exercise';
      _isLoading = false;
      notifyListeners();
      return false;

    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}