// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notifications =
//       FlutterLocalNotificationsPlugin();

//   static Future<void> initialize() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//     );

//     await _notifications.initialize(initializationSettings);
//   }

//   static Future<void> showNotification({
//     required String title,
//     required String body,
//   }) async {
//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//       'delivery_updates',
//       'Delivery Updates',
//       'Notifications for delivery status updates',
//       importance: Importance.high,
//       priority: Priority.high,
//     );

//     const NotificationDetails platformDetails = NotificationDetails(
//       android: androidDetails,
//     );

//     await _notifications.show(
//       DateTime.now().millisecond,
//       title,
//       body,
//       platformDetails,
//     );
//   }
// }
