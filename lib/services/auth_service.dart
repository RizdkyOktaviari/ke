import 'package:http/http.dart' as http;
import 'dart:convert';

import '../response/auth_response.dart';

class AuthService {
  static const String baseUrl = 'http://108.137.67.23/api';

  Future<LoginResponse> login(
      String username, String password, String? fcmToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': username,
          'password': password,
          'fcm_token': fcmToken,
        }),
      );

      final Map<String, dynamic> responseData = json.decode(response.body);
      return LoginResponse.fromJson(responseData);
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }
}
