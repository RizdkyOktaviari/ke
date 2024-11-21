class Exercise {
  final int mExerciseId;
  final String description;
  final int duration;
  final int calories;
  final int distance;

  Exercise({
    required this.mExerciseId,
    required this.description,
    required this.duration,
    required this.calories,
    required this.distance,
  });

  Map<String, dynamic> toJson() => {
    'm_exercise_id': mExerciseId,
    'description': description,
    'duration': duration,
    'calories': calories,
    'distance': distance,
  };
}

class ExerciseType {
  final int id;
  final String name;
  final String description;

  ExerciseType({
    required this.id,
    required this.name,
    required this.description,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ExerciseType &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}


class ExerciseModel {
final int id;
final String exerciseName;
final String description;
final String createdAt;
final String updatedAt;

ExerciseModel({
  required this.id,
  required this.exerciseName,
  required this.description,
  required this.createdAt,
  required this.updatedAt,
});

factory ExerciseModel.fromJson(Map<String, dynamic> json) {
return ExerciseModel(
id: json['id'],
exerciseName: json['exercise_name'],
description: json['description'],
createdAt: json['created_at'],
updatedAt: json['updated_at'],
);
}
}