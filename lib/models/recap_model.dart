class RecapModel {
  final String date;
  final FoodLogs foodLogs;
  final String drinkLogs;
  final List<ExerciseLog> exerciseLogs;
  final List<BloodPressure> bloodPressure;
  final List<MedicineLog> medicineLogs;

  RecapModel({
    required this.date,
    required this.foodLogs,
    required this.drinkLogs,
    required this.exerciseLogs,
    required this.bloodPressure,
    required this.medicineLogs,
  });

  factory RecapModel.fromJson(String date, Map<String, dynamic> json) {
    return RecapModel(
      date: date,
      foodLogs: FoodLogs.fromJson(json['food_logs']),
      drinkLogs: json['drinklogs'],
      exerciseLogs: (json['exercise_logs'] as List)
          .map((e) => ExerciseLog.fromJson(e))
          .toList(),
      bloodPressure: (json['blood_pressure'] as List)
          .map((e) => BloodPressure.fromJson(e))
          .toList(),
      medicineLogs: (json['medicine_logs'] as List)
          .map((e) => MedicineLog.fromJson(e))
          .toList(),
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
  final String createdAt; // Ubah ke String

  BloodPressure({
    required this.systolic,
    required this.diastolic,
    required this.createdAt,
  });
  factory BloodPressure.fromJson(Map<String, dynamic> json) => BloodPressure(
    systolic: json['systolic'],
    diastolic: json['diastolic'],
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
      medicineName: json['medicine_name'],
      dosage: json['dosage'],
      summary: json['summary'],
      createdAt: json['created_at'],
    );
  }
}