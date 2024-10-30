class RegisterData {
  final String name;
  final String username;
  final String password;
  final String passwordConfirmation;
  final String dateOfBirth;
  final String education;
  final String occupation;
  final int durationOfHypertension;
  final String phoneNumber;
  final String gender;
  final String noteHypertension;
  final int exerciseId;
  final String exerciseTimeSchedule;
  final String medicineName;
  final int medicineCount;
  final String? fcmToken;

  RegisterData({
    required this.name,
    required this.username,
    required this.password,
    required this.passwordConfirmation,
    required this.dateOfBirth,
    required this.education,
    required this.occupation,
    required this.durationOfHypertension,
    required this.phoneNumber,
    required this.gender,
    required this.noteHypertension,
    required this.exerciseId,
    required this.exerciseTimeSchedule,
    required this.medicineName,
    required this.medicineCount,
    this.fcmToken,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'username': username,
    'password': password,
    'password_confirmation': passwordConfirmation,
    'date_of_birth': dateOfBirth,
    'education': education,
    'occupation': occupation,
    'duration_of_hypertension': durationOfHypertension,
    'phone_number': phoneNumber,
    'gender': gender,
    'note_hypertension': noteHypertension,
    'exercise_id': exerciseId,
    'exercise_time_schedule': exerciseTimeSchedule,
    'medicine_name': medicineName,
    'medicine_count': medicineCount,
    if(fcmToken != null) 'fcm_token': fcmToken,
  };
}