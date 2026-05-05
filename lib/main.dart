import 'package:flutter/material.dart';
import 'package:ingresso_app_flutter/screen/tela_login.dart';
import 'package:intl/date_symbol_data_local.dart';

 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  runApp(const IngressosApp());
}
 
class IngressosApp extends StatelessWidget {
  const IngressosApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ingressos App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 1,
          backgroundColor: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6750A4),
          ).surface,
        ),
        cardTheme: const CardThemeData(elevation: 1),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: const TelaLogin(),
    );
  }
}
 