import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/register_model.dart';
import '../../response/user_response.dart';
import '../../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  String? _token;
  User? _user;
  bool _isLoading = false;
  String? _error;

  String? get token => _token;
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _token != null;


  Future<bool> login(String username, String password,
      [String? fcmToken]) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _authService.login(username, password, fcmToken);

      if (response.status && response.code == 200) {
        _token = response.meta.token;
        _user = response.data;

        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('user', userToJson(_user!));

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(RegisterData data) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await http.post(
        Uri.parse('http://108.137.67.23/api/register'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data.toJson()),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['status'] == true) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = responseData['message'] ?? 'Registrasi gagal';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  Future<void> logout() async {
    _token = null;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    final userJson = prefs.getString('user');
    if (userJson != null) {
      _user = userFromJson(userJson);
    }
    notifyListeners();
  }

  // Helper methods for user serialization
  String userToJson(User user) {
    return jsonEncode({
      'id': user.id,
      'name': user.name,
      'username': user.username,
      'date_of_birth': user.dateOfBirth,
      'education': user.education,
      'occupation': user.occupation,
      'duration_of_hypertension': user.durationOfHypertension,
      'phone_number': user.phoneNumber,
      'gender': user.gender,
      'note_hypertension': user.noteHypertension,
      'role': user.role,
      'created_at': user.createdAt,
      'updated_at': user.updatedAt,
      'fcm_token': user.fcmToken,
      'age': user.age,
    });
  }

  User userFromJson(String json) {
    final Map<String, dynamic> data = jsonDecode(json);
    return User.fromJson(data);
  }
}
