// daily_summary_model.dart

import 'package:kesehatan_mobile/models/recap_model.dart';
import 'package:kesehatan_mobile/models/water_model.dart';

import 'note_model.dart';

class DailySummaryResponse {
  final bool status;
  final int code;
  final String message;
  final Map<String, DailySummary> data;

  DailySummaryResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory DailySummaryResponse.fromJson(Map<String, dynamic> json) {
    Map<String, DailySummary> summaryMap = {};
    (json['data'] as Map<String, dynamic>).forEach((key, value) {
      summaryMap[key] = DailySummary.fromJson(value);
    });

    return DailySummaryResponse(
      status: json['status'],
      code: json['code'],
      message: json['message'],
      data: summaryMap,
    );
  }
}

class DailySummary {
  final FoodLogs foodLogs;
  final DrinkLog drinkLogs;
  final List<ExerciseLog> exerciseLogs;
  final List<BloodPressure> bloodPressure;
  final List<MedicineLog> medicineLogs;
  final List<Note> noteLogs;

  DailySummary({
    required this.foodLogs,
    required this.drinkLogs,
    required this.exerciseLogs,
    required this.bloodPressure,
    required this.medicineLogs,
    this.noteLogs = const [],
  });

  factory DailySummary.fromJson(Map<String, dynamic> json) {
    return DailySummary(
      foodLogs: FoodLogs.fromJson(json['food_logs']),
      drinkLogs: json['drinklogs'],
      exerciseLogs: (json['exercise_logs'] as List)
          .map((x) => ExerciseLog.fromJson(x))
          .toList(),
      bloodPressure: (json['blood_pressure'] as List)
          .map((x) => BloodPressure.fromJson(x))
          .toList(),
      medicineLogs: (json['medicine_logs'] as List)
          .map((x) => MedicineLog.fromJson(x))
          .toList(),
      noteLogs: (json['note_logs'] as List?)
          ?.map((x) => Note.fromJson(Map<String, dynamic>.from(x)))
          .toList() ?? [],
    );
  }
}

class FoodLogs {
  final String totalCalories;
  final List<Food> foods;

  FoodLogs({
    required this.totalCalories,
    required this.foods,
  });

  factory FoodLogs.fromJson(Map<String, dynamic> json) {
    return FoodLogs(
      totalCalories: json['total_calories'],
      foods: (json['foods'] as List).map((x) => Food.fromJson(x)).toList(),
    );
  }
}

// Tambahkan kelas-kelas lainnya yang dibutuhkan