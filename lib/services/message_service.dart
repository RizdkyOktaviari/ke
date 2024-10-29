import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/message.dart';

class MessageService {
  static const String baseUrl = 'http://108.137.67.23/api';

  Future<MessageResponse> getMessages(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/message'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = json.decode(response.body);
      return MessageResponse.fromJson(responseData);
    } catch (e) {
      throw Exception('Failed to load messages: $e');
    }
  }

  Future<bool> sendMessage(String token, String content) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/message'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'content': content,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }
}