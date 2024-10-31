import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/knowledge_model.dart';

class KnowledgeProvider with ChangeNotifier {
  List<Knowledge> _knowledgeList = [];
  bool _isLoading = false;
  String? _error;

  List<Knowledge> get knowledgeList => _knowledgeList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchKnowledge(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('http://108.137.67.23/api/knowledge'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          _knowledgeList = (data['data'] as List)
              .map((item) => Knowledge.fromJson(item))
              .toList();
        } else {
          _error = data['message'] ?? 'Failed to fetch knowledge';
        }
      } else {
        _error = 'Failed to fetch knowledge';
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}