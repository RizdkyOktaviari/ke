import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kesehatan_mobile/helpers/app_localizations.dart';
import 'package:kesehatan_mobile/helpers/providers/local_provider.dart';
import 'package:kesehatan_mobile/pages/auth/login.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        locale: context.watch<LocaleProvider>().locale,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          AppLocalizations.delegate, // Add your own localization delegate
        ],
        supportedLocales: const [
          Locale('id'), // Indonesian
          Locale('en'), // English
        ],
        home: LoginPage());
  }
}
