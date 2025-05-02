import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const FlashAbilityApp());
}

class FlashAbilityApp extends StatelessWidget {
  const FlashAbilityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flash Ability',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: const MainScreen(), // This ensures MainScreen is the entry point
      debugShowCheckedModeBanner: false,
    );
  }
}
