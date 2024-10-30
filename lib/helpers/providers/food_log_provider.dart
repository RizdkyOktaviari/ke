// providers/food_log_provider.dart
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/recap_model.dart';
import 'auth_provider.dart';

class FoodLogProvider with ChangeNotifier {
  static const String baseUrl = 'http://108.137.67.23/api';
  final AuthProvider authProvider;

  Map<String, RecapModel> _dailyRecaps = {};
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  String? _error;

  FoodLogProvider({required this.authProvider}) {
    // Listen to auth changes
    authProvider.addListener(_onAuthChanged);
  }

  @override
  void dispose() {
    authProvider.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    if (authProvider.isAuthenticated) {
      fetchDailySummary(_selectedDate);
    } else {
      reset();
    }
  }

  // Getters
  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;
  String? get error => _error;
  RecapModel? get currentRecap => _dailyRecaps[_formatDate(_selectedDate)];

  // Mengambil data dari API
  Future<void> fetchDailySummary(DateTime date) async {
    if (!authProvider.isAuthenticated) return;

    try {
      _isLoading = true;
      notifyListeners();

      final formattedDate = _formatDate(date);
      final response = await http.get(
        Uri.parse('$baseUrl/daily-summary?date=$formattedDate'),
        headers: {
          'Authorization': 'Bearer ${authProvider.token}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          _dailyRecaps[formattedDate] = RecapModel.fromJson(
            formattedDate,
            data['data'],
          );
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
    await fetchDailySummary(date);
    notifyListeners();
  }

  // Format tanggal untuk API
  String _formatDate(DateTime date) {
    return '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
  }

  // Existing methods remain the same
  List<Food> getFoodsByType(String mealType) {
    if (currentRecap == null) return [];

    return currentRecap!.foodLogs.foods.where((food) {
      return food.foodName.toLowerCase().startsWith(mealType.toLowerCase());
    }).toList();
  }

  int getTotalCaloriesForType(String mealType) {
    final foods = getFoodsByType(mealType);
    return foods.fold(0, (sum, food) => sum + food.calories);
  }

  String getTotalCalories() {
    return currentRecap?.foodLogs.totalCalories ?? '0 kcal';
  }

  // Add food entry dengan token dari auth
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
          'date': _formatDate(_selectedDate),
          'meal_type': mealType.toLowerCase(),
          'food_name': foodName,
          'calories': calories,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchDailySummary(_selectedDate);
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

  // Similar updates for other methods
  Future<void> addExerciseLog(ExerciseLog exerciseLog) async {
    if (!authProvider.isAuthenticated) return;
    // Implementation with auth token
  }

  Future<void> addWaterLog(int amount) async {
    if (!authProvider.isAuthenticated) return;
    // Implementation with auth token
  }

  void reset() {
    _dailyRecaps.clear();
    _selectedDate = DateTime.now();
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}