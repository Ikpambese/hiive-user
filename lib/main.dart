import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hiiveuser/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'assistants/address_changer.dart';
import 'assistants/cartitem_counter.dart';
import 'assistants/total_amount.dart';
import 'global/global.dart';
import 'splash/splash_screen.dart';

import 'providers/theme_provider.dart';

void initializeNotifications() async {
  await FlutterLocalNotificationsPlugin().initialize(
    const InitializationSettings(
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
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  sharedPreferences = await SharedPreferences.getInstance();
  initializeNotifications();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (c) => CartItemCounter()),
        ChangeNotifierProvider(create: (c) => TotalAmount()),
        ChangeNotifierProvider(create: (c) => AddressChanger()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Hiive',
          theme: themeProvider.themeData,
          home: const MySplashScreen(),
          builder: (context, child) {
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
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.error,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isInDebugMode
                            ? 'An error occurred: ${details.exception}'
                            : 'An error occurred. Please try again later.',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            };

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
        );
      },
    );
  }
}
