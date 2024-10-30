
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/resep_model.dart';

class RecipeProvider with ChangeNotifier {
  List<Recipe> _recipes = [];
  bool _isLoading = false;
  bool _isSubmitting = false;
  String _error = '';
  bool get isSubmitting => _isSubmitting;

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchRecipes() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('http://108.137.67.23/api/recipes'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer YOUR_TOKEN_HERE', // Replace with actual token
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == true) {
          _recipes = (data['data'] as List)
              .map((item) => Recipe.fromJson(item))
              .toList();
        } else {
          _error = data['message'] ?? 'Unknown error occurred';
        }
      } else {
        _error = 'Failed to fetch recipes';
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addFoodIntake(String token, int recipeId) async {
    _isSubmitting = true;
    _error = '';
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://108.137.67.23/api/food-intake'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'recipe_id': recipeId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          _isSubmitting = false;
          notifyListeners();
          return true;
        } else {
          _error = data['message'] ?? 'Failed to add food intake';
        }
      } else {
        _error = 'Failed to add food intake';
      }
    } catch (e) {
      _error = e.toString();
    }

    _isSubmitting = false;
    notifyListeners();
    return false;
  }
}