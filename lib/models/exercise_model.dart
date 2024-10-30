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
