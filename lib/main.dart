import 'package:flutter/material.dart';
import 'package:ingresso_app_flutter/screens/shows_screen.dart';


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
      initialRoute: '/shows',
      routes: {
        '/shows': (context) => const ShowsScreen(),
      },
    );
  }
}
