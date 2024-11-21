import 'note_model.dart';

class RecapModel {
  final String date;
  final FoodLogs foodLogs;
  final DrinkLogs drinkLogs;  // Ubah ke DrinkLogs class
  final List<ExerciseLog> exerciseLogs;
  final List<BloodPressure> bloodPressure;
  final List<MedicineLog> medicineLogs;
  final List<Note> noteLogs;

  RecapModel({
    required this.date,
    required this.foodLogs,
    required this.drinkLogs,
    required this.exerciseLogs,
    required this.bloodPressure,
    required this.medicineLogs,
    required this.noteLogs,
  });

  factory RecapModel.fromJson(String date, Map<String, dynamic> json) {
    print('Parsing RecapModel - Food Logs: ${json['food_logs']}');
    return RecapModel(
      date: date,
      foodLogs: FoodLogs.fromJson(json['food_logs']),
      drinkLogs: DrinkLogs.fromJson(json['drinklogs']),  // Parse ke DrinkLogs
      exerciseLogs: (json['exercise_logs'] as List)
          .map((e) => ExerciseLog.fromJson(e))
          .toList(),
      bloodPressure: (json['blood_pressure'] as List)
          .map((e) => BloodPressure.fromJson(e))
          .toList(),
      medicineLogs: (json['medicine_logs'] as List)
          .map((e) => MedicineLog.fromJson(e))
          .toList(),
      noteLogs: (json['notes'] as List?)
          ?.map((e) => Note.fromJson(Map<String, dynamic>.from(e)))
          .toList() ?? [],
    );
  }
}

class DrinkLogs {
  final String totalAmount;
  final List<Drink> drinks;

  DrinkLogs({
    required this.totalAmount,
    required this.drinks,
  });

  factory DrinkLogs.fromJson(Map<String, dynamic> json) {
    return DrinkLogs(
      totalAmount: json['total_amount'],
      drinks: (json['drinks'] as List)
          .map((e) => Drink.fromJson(e))
          .toList(),
    );
  }
}
class Drink {
  final String drinkName;
  final int amounts;

  Drink({
    required this.drinkName,
    required this.amounts,
  });

  factory Drink.fromJson(Map<String, dynamic> json) {
    return Drink(
      drinkName: json['drink_name'],
      amounts: json['amounts'],
    );
  }
}

class FoodLogs {
  final String totalCalories;
  final List<Food> foods;

  FoodLogs({required this.totalCalories, required this.foods});

  factory FoodLogs.fromJson(Map<String, dynamic> json) {
    return FoodLogs(
      totalCalories: json['total_calories'],
      foods: (json['foods'] as List).map((e) => Food.fromJson(e)).toList(),
    );
  }
}

class Food {
  final String foodName;
  final int calories;

  Food({required this.foodName, required this.calories});

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      foodName: json['food_name'],
      calories: json['calories'],
    );
  }
}


class ExerciseLog {
  final String exerciseName;
  final String duration;
  final String caloriesBurned;

  ExerciseLog({
    required this.exerciseName,
    required this.duration,
    required this.caloriesBurned,
  });

  factory ExerciseLog.fromJson(Map<String, dynamic> json) {
    return ExerciseLog(
      exerciseName: json['exercise_name'],
      duration: json['duration'],
      caloriesBurned: json['calories_burned'],
    );
  }
}


class BloodPressure {
  final int systolic;
  final int diastolic;
  final String summary;    // Tambahkan field summary
  final String createdAt;

  BloodPressure({
    required this.systolic,
    required this.diastolic,
    required this.summary,
    required this.createdAt,
  });

  factory BloodPressure.fromJson(Map<String, dynamic> json) => BloodPressure(
    systolic: json['systolic'],
    diastolic: json['diastolic'],
    summary: json['summary'],    // Parse summary
    createdAt: json['created_at'],
  );
}

class MedicineLog {
  final String medicineName;
  final String dosage;
  final String summary;
  final String createdAt;

  MedicineLog({
    required this.medicineName,
    required this.dosage,
    required this.summary,
    required this.createdAt,
  });

  factory MedicineLog.fromJson(Map<String, dynamic> json) {
    return MedicineLog(
      medicineName: _parseString(json['medicine_name']),
      dosage: _parseString(json['dosage']),
      summary: _parseString(json['summary']),
      createdAt: _parseString(json['created_at']),
    );
  }
  static String _parseString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }
}