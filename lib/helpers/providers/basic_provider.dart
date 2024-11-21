import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:kesehatan_mobile/helpers/providers/auth_provider.dart';

abstract class BaseProvider with ChangeNotifier {
  final AuthProvider authProvider;
  final BuildContext context;
  bool _isLoading = false;
  String? _error;

  BaseProvider(this.authProvider, this.context) {
    authProvider.addListener(_onAuthChanged);
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => authProvider.isAuthenticated;

  void _onAuthChanged() {
    if (!authProvider.isAuthenticated) {
      reset();
    }
  }

  @override
  void dispose() {
    authProvider.removeListener(_onAuthChanged);
    super.dispose();
  }

  Future<bool> handleApiResponse(http.Response response) async {
    if (response.statusCode == 401) {
      await authProvider.handleUnauthorized(context);
      return false;
    }
    return true;
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? value) {
    _error = value;
    notifyListeners();
  }

  // Abstract method that must be implemented by child classes
  void reset();
}