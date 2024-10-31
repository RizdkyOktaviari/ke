import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kesehatan_mobile/helpers/providers/reminder.dart';
import 'package:provider/provider.dart';
import 'package:kesehatan_mobile/pages/my_app.dart';
import 'package:kesehatan_mobile/helpers/providers/local_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'helpers/providers/auth_provider.dart';
import 'helpers/providers/blood_provider.dart';
import 'helpers/providers/exercise_provider.dart';
import 'helpers/providers/food_log_provider.dart';
import 'helpers/providers/knowledge_provider.dart';
import 'helpers/providers/medicine_provider.dart';
import 'helpers/providers/message_provider.dart';
import 'helpers/providers/note_provider.dart';
import 'helpers/providers/recap_provider.dart';
import 'helpers/providers/recipe_provider.dart';
import 'helpers/providers/reminder_provider.dart';
import 'helpers/providers/water_provider.dart';

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
    ChangeNotifierProxyProvider<AuthProvider, FoodLogProvider>(
      create: (context) => FoodLogProvider(
        authProvider: context.read<AuthProvider>(),
      ),
      update: (context, auth, previous) => previous!,
    ),
    ChangeNotifierProxyProvider<AuthProvider, RecapProvider>(
      create: (context) => RecapProvider(context.read<AuthProvider>()),
      update: (context, auth, previous) => RecapProvider(auth),
    ),
    ChangeNotifierProxyProvider<AuthProvider, MedicineProvider>(
      create: (ctx) => MedicineProvider(ctx.read<AuthProvider>()),
      update: (ctx, auth, previous) => MedicineProvider(auth),
    ),
    ChangeNotifierProvider(
      create: (contex) => alarmprovider(),
    ),
    ChangeNotifierProvider(create: (_) => ReminderProvider()),
    ChangeNotifierProvider(create: (_) => ExerciseProvider()),
    ChangeNotifierProvider(create: (_) => WaterProvider()),
    ChangeNotifierProvider(create: (_) => BloodPressureProvider()),
    ChangeNotifierProvider(create: (_) => NoteProvider()),
    ChangeNotifierProvider(create: (_) => KnowledgeProvider()),
  ], child: const MyApp()));
}
