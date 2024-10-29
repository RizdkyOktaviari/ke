import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kesehatan_mobile/helpers/providers/reminder.dart';
import 'package:provider/provider.dart';
import 'package:kesehatan_mobile/pages/my_app.dart';
import 'package:kesehatan_mobile/helpers/providers/local_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'helpers/providers/auth_provider.dart';
import 'helpers/providers/message_provider.dart';
import 'helpers/providers/recipe_provider.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .requestNotificationsPermission();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => LocaleProvider()),
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => MessageProvider()),
    ChangeNotifierProvider(create: (_) => RecipeProvider()),
    ChangeNotifierProvider(
      create: (contex) => alarmprovider(),
    ),
  ], child: const MyApp()));
}
