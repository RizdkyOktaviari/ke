import 'package:flutter/material.dart';
import 'package:kesehatan_mobile/constants/box.dart';
import 'package:kesehatan_mobile/constants/text_style.dart';
import 'package:kesehatan_mobile/helpers/app_localizations.dart';
import 'package:kesehatan_mobile/pages/home/home.dart' as home;
import 'register.dart';
import 'package:provider/provider.dart';
import 'package:kesehatan_mobile/helpers/providers/local_provider.dart';

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
                        TextField(
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.email,
                            labelStyle: TextStyle(color: Colors.blueAccent),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.password,
                            labelStyle: TextStyle(color: Colors.blueAccent),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            AppLocalizations.of(context)!.forgotPassword,
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                        SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const home.HomePage()),
                              );
                            },
                            child: Text(
                              AppLocalizations.of(context)!.login,
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
                        // change language button id|en, not pop up
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<LocaleProvider>()
                                    .setLocaleByCode('id');
                              },
                              child: Text('ID'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<LocaleProvider>()
                                    .setLocaleByCode('en');
                              },
                              child: Text('EN'),
                            ),
                          ],
                        ),
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
