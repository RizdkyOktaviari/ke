import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/exercise_model.dart';
import 'auth_provider.dart';
import 'basic_provider.dart';
class ExerciseProvider extends BaseProvider {
  bool _isLoading = false;
  String? _error;
  List<ExerciseModel> _exercises = [];

  ExerciseProvider({
    required AuthProvider authProvider,
    required BuildContext context,
  }) : super(authProvider, context) {
    // Fetch exercises when provider is created without auth check
    fetchExercisesForRegister();
  }

  List<ExerciseModel> get exercises => _exercises;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchExercisesForRegister() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await http.get(
        Uri.parse('http://108.137.67.23/api/exercises'),
        headers: {
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}'); // Debug print
      print('Response body: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          _exercises = (data['data'] as List)
              .map((json) => ExerciseModel.fromJson(json))
              .toList();
          _error = null;
          print('Fetched ${_exercises.length} exercises'); // Debug print
        } else {
          _error = data['message'] ?? 'Failed to load exercises';
        }
      } else {
        _error = 'Failed to load exercises';
      }
    } catch (e) {
      print('Error fetching exercises: $e'); // Debug print
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // Fetch exercises for dropdown
  Future<void> fetchExercises() async {
    if (!authProvider.isAuthenticated) return;

    try {
      _isLoading = true;
      notifyListeners();

      final response = await http.get(
        Uri.parse('http://108.137.67.23/api/exercises'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authProvider.token}',
        },
      );

      print('Response status: ${response.statusCode}'); // Debug print
      print('Response body: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          _exercises = (data['data'] as List)
              .map((json) => ExerciseModel.fromJson(json))
              .toList();
          _error = null;
        } else {
          _error = data['message'] ?? 'Failed to load exercises';
        }
      } else {
        _error = 'Failed to load exercises';
      }
    } catch (e) {
      print('Error fetching exercises: $e'); // Debug print
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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
      if (!await handleApiResponse(response)) {
        return false;
      }

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

  @override
  void reset() {
    _exercises = [];
    setLoading(false);
    setError(null);
  }
}