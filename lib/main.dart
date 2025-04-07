import 'package:do_chat/pages/login/login_page.dart';
import 'package:do_chat/pages/splash_screen.dart';
import 'package:do_chat/services/navigation_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    SplashScreen(
      key: UniqueKey(),
      onInitalizationComplete: () {
        runApp(MainApp());
      },
    ),
  );
}

class MainApp extends StatelessWidget {
  // const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Do Chat',
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color.fromRGBO(30, 29, 37, 1.0),
        ),
      ),
      navigatorKey: NavigationService.navigatorKey,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        // Add other routes here
      },
    );
  }
}
