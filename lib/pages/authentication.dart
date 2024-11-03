import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/providers/auth_provider.dart';
import 'auth/login.dart';
import 'home/home.dart';

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (authProvider.isAuthenticated) {
          return const HomePage();
        }

        return LoginPage();
      },
    );
  }
}