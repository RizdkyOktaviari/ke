class User {
  final int id;
  final String name;
  final String username;
  final String dateOfBirth;
  final String education;
  final String occupation;
  final int durationOfHypertension;
  final String phoneNumber;
  final String gender;
  final String? noteHypertension;
  final String role;
  final String createdAt; // Pastikan ada atribut ini
  final String updatedAt;
  final String fcmToken;
  final String age;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.dateOfBirth,
    required this.education,
    required this.occupation,
    required this.durationOfHypertension,
    required this.phoneNumber,
    required this.gender,
    this.noteHypertension,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.fcmToken,
    required this.age,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      dateOfBirth: json['date_of_birth'],
      education: json['education'],
      occupation: json['occupation'],
      durationOfHypertension: json['duration_of_hypertension'],
      phoneNumber: json['phone_number'],
      gender: json['gender'],
      noteHypertension: json['note_hypertension'],
      role: json['role'],
      createdAt: json['created_at'], // Pastikan ini diambil dari JSON
      updatedAt: json['updated_at'],
      fcmToken: json['fcm_token'],
      age: json['age'],
    );
  }
}