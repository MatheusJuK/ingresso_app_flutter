import 'package:flutter/material.dart';
import 'screens/loading.dart';
import 'screens/login.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ingresso App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoadingPage(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
