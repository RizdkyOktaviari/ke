import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/blood_model.dart';
import 'auth_provider.dart';
import 'basic_provider.dart';

class BloodPressureProvider extends BaseProvider {
  bool _isLoading = false;
  String? _error;

  BloodPressureProvider({
    required AuthProvider authProvider,
    required BuildContext context,
  }) : super(authProvider, context);


  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> addBloodPressure(String token, BloodPressure bloodPressure) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://108.137.67.23/api/health-control-note'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(bloodPressure.toJson()),
      );

      final data = json.decode(response.body);
      if (!await handleApiResponse(response)) {
        return false;
      }

      if (response.statusCode == 200 && data['status'] == true) {
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _error = data['message'] ?? 'Failed to add blood pressure data';
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