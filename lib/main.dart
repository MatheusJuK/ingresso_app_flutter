import 'package:flutter/material.dart';
import 'package:ingresso_app_flutter/screens/shows_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ingresso_app_flutter/core/api_client.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  final apiClient = await ApiClient.create();

  runApp(
    Provider<ApiClient>.value(value: apiClient, child: const MainApp()),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ingresso App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/shows',
      routes: {'/shows': (context) => const ShowsScreen()},
    );
  }
}
