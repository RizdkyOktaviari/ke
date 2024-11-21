// providers/food_log_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kesehatan_mobile/helpers/providers/basic_provider.dart';
import 'dart:convert';
import '../../models/recap_model.dart';
import 'auth_provider.dart';

class FoodLogProvider extends BaseProvider {
  static const String baseUrl = 'http://108.137.67.23/api';

  RecapModel? _currentRecap;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  String? _error;

  FoodLogProvider({
    required AuthProvider authProvider,
    required BuildContext context,
  }) : super(authProvider, context);


  @override
  void dispose() {
    authProvider.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    if (authProvider.isAuthenticated) {
      fetchDailySummary();
    } else {
      reset();
    }
  }

  // Getters
  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;
  String? get error => _error;
  RecapModel? get currentRecap => _currentRecap;

  Future<void> fetchDailySummary() async {
    if (!authProvider.isAuthenticated) return;

    try {
      _isLoading = true;
      notifyListeners();

      final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
      final response = await http.get(
        Uri.parse('$baseUrl/daily-summary?date=$formattedDate'),
        headers: {
          'Authorization': 'Bearer ${authProvider.token}',
          'Accept': 'application/json',
        },
      );

      if (!await handleApiResponse(response)) {
        return;
      }


      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          _currentRecap = RecapModel.fromJson(
            formattedDate,
            data['data'],
          );
          print('Parsed notes count: ${_currentRecap?.noteLogs.length}');
          _currentRecap?.noteLogs.forEach((note) {
            print('Parsed note - Title: ${note.title}, Content: ${note.content}');
          });

          _error = null;
        } else {
          _error = data['message'] ?? 'Failed to fetch data';
        }
      } else {
        _error = 'Failed to fetch data';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // Set tanggal yang dipilih dan ambil data
  Future<void> setSelectedDate(DateTime date) async {
    _selectedDate = date;
    await fetchDailySummary();
  }

  // Get foods by meal type
  List<Food> getFoodsByType(String mealType) {
    if (_currentRecap == null) return [];

    return _currentRecap!.foodLogs.foods.where((food) {
      final foodNameLower = food.foodName.toLowerCase();
      final mealTypeLower = mealType.toLowerCase();
      return foodNameLower.startsWith('$mealTypeLower:') ||
          foodNameLower.startsWith(mealTypeLower);
    }).toList();
  }

  // Get total calories for meal type
  int getTotalCaloriesForType(String mealType) {
    final foods = getFoodsByType(mealType);
    return foods.fold(0, (sum, food) => sum + food.calories);
  }

  // Get total calories
  String getTotalCalories() {
    return _currentRecap?.foodLogs.totalCalories ?? '0 kcal';
  }

  // Add food entry
  Future<void> addFoodEntry(String mealType, String foodName, int calories) async {
    if (!authProvider.isAuthenticated) return;

    try {
      _isLoading = true;
      notifyListeners();

      final response = await http.post(
        Uri.parse('$baseUrl/food-logs'),
        headers: {
          'Authorization': 'Bearer ${authProvider.token}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
          'meal_type': mealType.toLowerCase(),
          'food_name': foodName,
          'calories': calories,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchDailySummary();
      } else {
        _error = 'Failed to add food entry';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add exercise log
  Future<void> addExerciseLog(ExerciseLog exerciseLog) async {
    if (!authProvider.isAuthenticated) return;

    try {
      _isLoading = true;
      notifyListeners();

      final response = await http.post(
        Uri.parse('$baseUrl/exercise-logs'),
        headers: {
          'Authorization': 'Bearer ${authProvider.token}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
          'exercise_name': exerciseLog.exerciseName,
          'duration': exerciseLog.duration,
          'calories_burned': exerciseLog.caloriesBurned,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchDailySummary();
      } else {
        _error = 'Failed to add exercise log';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add water log
  Future<void> addWaterLog(int amount) async {
    if (!authProvider.isAuthenticated) return;

    try {
      _isLoading = true;
      notifyListeners();

      final response = await http.post(
        Uri.parse('$baseUrl/drink-logs'),
        headers: {
          'Authorization': 'Bearer ${authProvider.token}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
          'amount': amount,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchDailySummary();
      } else {
        _error = 'Failed to add water log';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reset all data
  void reset() {
    _currentRecap = null;
    _selectedDate = DateTime.now();
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}