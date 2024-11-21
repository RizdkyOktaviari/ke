//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class FCMService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   Future<void> initialize() async {
//     // 1. Request permission dengan popup dialog
//     await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//       announcement: false,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//     );
//
//     // 2. Setup notification channel untuk Android
//     await _flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(
//       const AndroidNotificationChannel(
//         'high_importance_channel',
//         'High Importance Notifications',
//         description: 'This channel is used for important notifications.',
//         importance: Importance.high,
//       ),
//     );
//
//     // 3. Initialize local notifications dengan callback handler
//     const AndroidInitializationSettings androidSettings =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//     const DarwinInitializationSettings iOSSettings = DarwinInitializationSettings(
//       requestSoundPermission: true,
//       requestBadgePermission: true,
//       requestAlertPermission: true,
//     );
//
//     const InitializationSettings initSettings = InitializationSettings(
//       android: androidSettings,
//       iOS: iOSSettings,
//     );
//
//     await _flutterLocalNotificationsPlugin.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         // Handle notification tap
//         print('Notification tapped: ${response.payload}');
//       },
//     );
//
//     // 4. Set foreground notification presentation options (iOS)
//     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     // 5. Listen to messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       _showNotification(message);
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('Notification opened app: ${message.data}');
//     });
//
//     // 6. Get initial message (if app was terminated)
//     RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
//     if (initialMessage != null) {
//       print('App opened from terminated state: ${initialMessage.data}');
//     }
//   }
//
//   Future<void> _showNotification(RemoteMessage message) async {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;
//
//     if (notification != null && android != null) {
//       await _flutterLocalNotificationsPlugin.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             'high_importance_channel',
//             'High Importance Notifications',
//             channelDescription: 'This channel is used for important notifications.',
//             importance: Importance.high,
//             priority: Priority.high,
//             icon: '@mipmap/ic_launcher',
//             playSound: true,
//             enableVibration: true,
//           ),
//           iOS: const DarwinNotificationDetails(
//             presentAlert: true,
//             presentBadge: true,
//             presentSound: true,
//           ),
//         ),
//         payload: message.data.toString(),
//       );
//     }
//   }
// }
//
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('Handling background message: ${message.messageId}');
// }

import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();
  static const String baseUrl = 'http://108.137.67.23/api';
  String? _authToken;

  // Add method to set auth token
  void setAuthToken(String token) {
    _authToken = token;
    // Re-update FCM token when auth token is set
    _firebaseMessaging.getToken().then((fcmToken) {
      if (fcmToken != null) {
        _updateFCMToken(fcmToken);
      }
    });
  }

  Future<void> initialize() async {
    var settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('User notification permission status: ${settings.authorizationStatus}');
    // Get FCM token
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      print('FCM Token Update: $token');
      await _updateFCMToken(token);
    }

    // Listen to token refresh
    _firebaseMessaging.onTokenRefresh.listen((String token) {
      print('FCM Token refreshed: $token');
      _updateFCMToken(token);
    });

    // Configure notification channel
    await _notifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
      const AndroidNotificationChannel(
        'schedule_channel',
        'Schedule Notifications',
        description: 'Channel for schedule notifications',
        importance: Importance.high,
        // sound: RawResourceAndroidNotificationSound('notification_sound'), // Custom sound jika diperlukan
      ),
    );

    // Initialize local notifications
    await _notifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationTap(response.payload);
      },
    );



    // Listen to messages when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('=== Received Foreground Message ===');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      print('Data: ${message.data}');
      _handleScheduleMessage(message);

      // Show notification if app is in foreground
      if (message.notification != null) {
        _notifications.show(
          DateTime.now().millisecond,
          message.notification!.title,
          message.notification!.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'schedule_channel',
              'Schedule Notifications',
              channelDescription: 'Channel for schedule notifications',
              importance: Importance.high,
              priority: Priority.high,
              icon: '@drawable/logo',
              // sound: RawResourceAndroidNotificationSound('notification_sound'),
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          payload: message.data.toString(),
        );
      }
    });

    // Listen to messages when app is in background/terminated
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle message tap when app was terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message.data.toString());
    });
  }
  Future<void> clearFCMToken() async {
    try {
      if (_authToken == null) return;

      print('Clearing FCM token');

      final response = await http.post(
        Uri.parse('$baseUrl/update-fcm-token'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
        body: jsonEncode({
          'fcm_token': '',
        }),
      );

      print('Clear FCM Response Status: ${response.statusCode}');
      print('Clear FCM Response Body: ${response.body}');

      _authToken = null;
    } catch (e) {
      print('Error clearing FCM token: $e');
    }
  }
  Future<void> _updateFCMToken(String token) async {
    if (_authToken == null) {
    print('Cannot update FCM token: No auth token available');
    return;
  }

    try {
      print('Updating FCM token: $token');

      final response = await http.post(
        Uri.parse('$baseUrl/update-fcm-token'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'fcm_token': token,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          print('FCM token updated successfully');
        } else {
          print('Failed to update FCM token: ${data['message']}');
        }
      } else {
        print('Failed to update FCM token: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating FCM token: $e');
    }
  }


  // Handle schedule message
  void _handleScheduleMessage(RemoteMessage message) {
    try {
      if (message.data.containsKey('schedule_type')) {
        // Tampilkan notifikasi sesuai tipe jadwal
        switch (message.data['schedule_type']) {
          case 'medicine':
            _showMedicineNotification(
              title: message.notification?.title ?? 'Pengingat Obat',
              body: message.notification?.body ?? 'Waktunya minum obat',
              data: message.data,
            );
            break;
          case 'exercise':
            _showExerciseNotification(
              title: message.notification?.title ?? 'Pengingat Olahraga',
              body: message.notification?.body ?? 'Waktunya berolahraga',
              data: message.data,
            );
            break;
          default:
            _showGeneralNotification(
              title: message.notification?.title ?? 'Pengingat',
              body: message.notification?.body ?? 'Ada jadwal untuk Anda',
              data: message.data,
            );
        }
        print('=== Handling Schedule Message ===');
        print('Message data: ${message.data}');
      }
    } catch (e) {
      print('Error handling schedule message: $e');
    }
  }

  // Show medicine notification
  Future<void> _showMedicineNotification({
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {
    await _notifications.show(
      DateTime.now().millisecond,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'schedule_channel',
          'Schedule Notifications',
          channelDescription: 'Channel for schedule notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          // sound: RawResourceAndroidNotificationSound('notification_sound'),
          styleInformation: BigTextStyleInformation(body),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: data.toString(),
    );
  }

  // Show exercise notification
  Future<void> _showExerciseNotification({
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {
    await _notifications.show(
      DateTime.now().millisecond,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'schedule_channel',
          'Schedule Notifications',
          channelDescription: 'Channel for schedule notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          styleInformation: BigTextStyleInformation(body),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: data.toString(),
    );
  }

  // Show general notification
  Future<void> _showGeneralNotification({
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {
    await _notifications.show(
      DateTime.now().millisecond,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'schedule_channel',
          'Schedule Notifications',
          channelDescription: 'Channel for schedule notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: data.toString(),
    );
  }

  void _handleNotificationTap(String? payload) {
    if (payload != null) {
      print('Notification tapped with payload: $payload');
    }
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.data.containsKey('schedule_type')) {
    final notificationService = NotificationService();
    await notificationService.initialize();
    notificationService._handleScheduleMessage(message);
  }
}