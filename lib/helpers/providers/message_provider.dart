import 'package:flutter/foundation.dart';
import '../../models/message.dart';
import '../../services/message_service.dart';

class MessageProvider with ChangeNotifier {
  final MessageService _messageService = MessageService();
  List<Message> _messages = [];
  bool _isLoading = false;
  String? _error;

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchMessages(String token) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _messageService.getMessages(token);
      if (response.status) {
        _messages = response.data;
      } else {
        _error = response.message;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String token, String content) async {
    try {
      await _messageService.sendMessage(token, content);
      await fetchMessages(token); // Refresh messages after sending
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}