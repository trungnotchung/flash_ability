import 'package:flutter/material.dart';
import 'home_page.dart';

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
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
