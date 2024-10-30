import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/food_intake.dart';

class FoodService {
  Future<List<FoodIntake>> fetchFoodIntakes() async {
    final response = await http.get(Uri.parse('http://108.137.67.23/api/food-intake'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<FoodIntake> foodIntakes = [];
      for (var item in jsonData['data']) {
        foodIntakes.add(FoodIntake.fromJson(item));
      }
      return foodIntakes;
    } else {
      throw Exception('Failed to load food intakes');
    }
  }
}