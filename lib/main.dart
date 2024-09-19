import 'dart:io';

import 'package:dashboard/pages/login_screen.dart';
import 'package:dashboard/pages/splash_screen.dart';
import 'package:dashboard/utils/local_storage.service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//ssll handshake error
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyAvMXAIm1W0Cs2tA4amqr7YxfIZ--mKlCo",
    appId: "1:879096620814:web:0e1abe2734e5515becd95f",
    messagingSenderId: "879096620814",
    projectId: "dashboard-c4e81",
  ));
  await LocalStorageService.getPrefs();
  HttpOverrides.global = new MyHttpOverrides();
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData.light().copyWith(
      colorScheme: const ColorScheme.light(
        primary: Colors.blue,
        onPrimary: Colors.white,
        secondary: Colors.green,
        onSecondary: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black,
        error: Colors.red,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: Color(0xfff5f5f7),
      // Define custom colors for priority levels
      primaryColor: Colors.blue,
      extensions: [

      ],
    );

    final darkTheme = ThemeData.dark().copyWith(
      colorScheme: ColorScheme.dark(
        primary: Colors.blueGrey,
        onPrimary: Colors.white,
        secondary: Colors.teal,
        onSecondary: Colors.white,
        surface: Colors.grey[800]!,
        onSurface: Colors.white,
        error: Colors.red,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.black54,
      // Define custom colors for priority levels
      primaryColor: Colors.blueGrey,
      extensions: [

      ],
    );
    return MaterialApp(
        title: 'Dashboard',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return SplashScreen();
            }));
  }
}
