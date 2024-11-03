import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  bool _isInitialized = false;

  String? get token => _token;
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _token != null;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Tambahkan initialize method
  Future<void> initialize() async {
    if (_isInitialized) return;

    await checkAuthStatus();
    _isInitialized = true;
  }

  Future<String?> getFCMToken() async {
    try {
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      return await _firebaseMessaging.getToken();
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  Future<bool> login(String username, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      String? fcmToken = await getFCMToken();
      print('FCM Token: $fcmToken');

      final response = await _authService.login(username, password, fcmToken);

      if (response.status && response.code == 200) {
        _token = response.meta.token;
        _user = response.data;

        // Save auth data
        await _saveAuthData(_token!, _user!, fcmToken);
        print('Login success - Auth Token: $_token');

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

  // Method baru untuk menyimpan data auth
  Future<void> _saveAuthData(String token, User user, String? fcmToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('user', userToJson(user));
    if (fcmToken != null) {
      await prefs.setString('fcm_token', fcmToken);
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
    await prefs.remove('fcm_token');
    notifyListeners();
  }

  Future<bool> checkAuthStatus() async {
    print('Checking auth status...');
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    final userJson = prefs.getString('user');

    if (userJson != null) {
      try {
        _user = userFromJson(userJson);
        print('Auth restored - User: ${_user?.username}');
        notifyListeners();
        return true;
      } catch (e) {
        print('Error restoring auth: $e');
        await logout();
        return false;
      }
    }
    return false;
  }

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