import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kesehatan_mobile/constants/box.dart';
import 'package:kesehatan_mobile/constants/text_style.dart';
import 'package:kesehatan_mobile/helpers/app_localizations.dart';
import 'package:kesehatan_mobile/pages/home/home.dart' as home;
import 'package:provider/provider.dart';
import 'package:kesehatan_mobile/helpers/providers/auth_provider.dart';
import 'package:kesehatan_mobile/helpers/providers/local_provider.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double screenWidth = MediaQuery.of(context).size.width;

            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: screenWidth > 600 ? 400 : screenWidth * 0.9,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSizeBox.height20,
                          AppSizeBox.height40,
                          Text(
                            AppLocalizations.of(context)!.welcomeBack,
                            style: AppTextStyles.headline4,
                          ),
                          AppSizeBox.height10,
                          Text(
                            AppLocalizations.of(context)!.loginToYourAccount,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          AppSizeBox.height40,

                          // Username Field
                          TextFormField(
                            controller: _usernameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.email;
                              }
                              if (value.length > 255) {
                                return AppLocalizations.of(context)!.email;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.email,
                              labelStyle: TextStyle(color: Colors.blueAccent),
                              prefixIcon:
                                  Icon(Icons.person, color: Colors.blueAccent),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blueAccent),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.password;
                              }
                              if (value.length < 6) {
                                return AppLocalizations.of(context)!.password;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.password,
                              labelStyle: TextStyle(color: Colors.blueAccent),
                              prefixIcon:
                                  Icon(Icons.lock, color: Colors.blueAccent),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.blueAccent,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blueAccent),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Navigate to forgot password page
                              },
                              child: Text(
                                AppLocalizations.of(context)!.forgotPassword,
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                            ),
                          ),

                          // Error Message
                          Consumer<AuthProvider>(
                            builder: (context, auth, child) {
                              if (auth.error != null) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.red[50],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.error_outline,
                                            color: Colors.red),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            auth.error!,
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return SizedBox.shrink();
                            },
                          ),

                          SizedBox(height: 40),

                          // Login Button
                          Consumer<AuthProvider>(
                            builder: (context, auth, child) {
                              return SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 2,
                                  ),
                                  onPressed: auth.isLoading
                                      ? null
                                      : () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            final success = await auth.login(
                                              _usernameController.text,
                                              _passwordController.text,
                                            );

                                            if (success) {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const home.HomePage(),
                                                ),
                                              );
                                              final fcmToken = await FirebaseMessaging.instance.getToken();
                                              print('FCM Token: $fcmToken');
                                            }
                                          }
                                        },
                                  child: auth.isLoading
                                      ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          AppLocalizations.of(context)!.login,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: 20),

                          // Register Link
                          Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterPage(),
                                  ),
                                );
                              },
                              child: Text(
                                AppLocalizations.of(context)!
                                    .dontHaveAnAccountSignUp,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          // Language Selector
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildLanguageButton(
                                'ID',
                                () => context
                                    .read<LocaleProvider>()
                                    .setLocaleByCode('id'),
                                context
                                        .watch<LocaleProvider>()
                                        .locale
                                        .languageCode ==
                                    'id',
                              ),
                              SizedBox(width: 8),
                              _buildLanguageButton(
                                'EN',
                                () => context
                                    .read<LocaleProvider>()
                                    .setLocaleByCode('en'),
                                context
                                        .watch<LocaleProvider>()
                                        .locale
                                        .languageCode ==
                                    'en',
                              ),
                            ],
                          ),
                        ],
                      ),
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

  Widget _buildLanguageButton(
      String label, VoidCallback onPressed, bool isSelected) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blueAccent : Colors.grey[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
