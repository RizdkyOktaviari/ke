import 'package:flutter/material.dart';
import 'package:kesehatan_mobile/pages/main.dart';
import 'register.dart';
import '../main.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Dapatkan ukuran layar saat ini
            final double screenWidth = MediaQuery.of(context).size.width;

            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      // Lebar maksimum pada layar besar (tablet atau desktop)
                      maxWidth: screenWidth > 600 ? 400 : screenWidth * 0.9,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        SizedBox(height: 40),
                        Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Login to your account',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 40),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.redAccent),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.redAccent),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                        SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                                Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                              );
                            },
                            child: Text(
                              'Login',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              // Navigasi ke RegisterPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage()),
                              );
                            },
                            child: Text(
                              'Don’t have an account? Sign Up',
                              style: TextStyle(
                                color: Colors.grey[600],
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
