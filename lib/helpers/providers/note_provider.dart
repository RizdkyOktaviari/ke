import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/note_model.dart';
import 'auth_provider.dart';
import 'basic_provider.dart';

class NoteProvider extends BaseProvider {
  bool _isLoading = false;
  String? _error;

  NoteProvider({required AuthProvider authProvider,
    required BuildContext context,
  }) : super(authProvider, context);

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

  @override
  void reset() {
    setLoading(false);
    setError(null);
  }
}
