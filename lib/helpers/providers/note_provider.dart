import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/note_model.dart';

class NoteProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> addNote(String token, Note note) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://108.137.67.23/api/notes'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(note.toJson()),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _error = data['message'] ?? 'Failed to add note';
      _isLoading = false;
      notifyListeners();
      return false;

    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
