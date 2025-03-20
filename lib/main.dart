import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hiiveuser/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'assistants/address_changer.dart';
import 'assistants/cartitem_counter.dart';
import 'assistants/total_amount.dart';
import 'global/global.dart';
import 'splash/splash_screen.dart';
import 'services/notification_service.dart';

void initializeNotifications() async {
  await FlutterLocalNotificationsPlugin().initialize(
    InitializationSettings(
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  sharedPreferences = await SharedPreferences.getInstance();
  initializeNotifications(); // Add this line
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => CartItemCounter()),
        ChangeNotifierProvider(create: (c) => TotalAmount()),
        ChangeNotifierProvider(create: (c) => AddressChanger()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Seller App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MySplashScreen(),
        builder: (context, child) {
          // Add error boundary for the entire app
          ErrorWidget.builder = (FlutterErrorDetails details) {
            bool isInDebugMode = false;
            assert(() {
              isInDebugMode = true;
              return true;
            }());

            return Material(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isInDebugMode
                          ? 'An error occurred: ${details.exception}'
                          : 'An error occurred. Please try again later.',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          };

          // Add null check for child widget
          if (child == null) {
            return const SizedBox.shrink();
          }

          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.0),
            ),
            child: child,
          );
        },
      ),
    );
  }
}
