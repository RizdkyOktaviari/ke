import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/medicine_model.dart';
import 'auth_provider.dart';

class MedicineProvider with ChangeNotifier {
  final AuthProvider authProvider;
  List<Medicine> _medicines = [];
  bool _isLoading = false;
  String? _error;

  MedicineProvider(this.authProvider);

  List<Medicine> get medicines => _medicines;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchMedicines() async {
    if (!authProvider.isAuthenticated) {
      _error = 'Not authenticated';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('http://108.137.67.23/api/medicines'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authProvider.token}',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          final List<dynamic> medicineData = responseData['data'] as List<dynamic>;
          _medicines = medicineData.map((json) => Medicine.fromJson(json)).toList();
        } else {
          _error = responseData['message']?.toString() ?? 'Unknown error occurred';
        }
      } else if (response.statusCode == 401) {
        _error = 'Session expired. Please login again.';
        await authProvider.logout();
      } else {
        _error = 'Failed to fetch medicines: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
  }
}