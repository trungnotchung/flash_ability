import 'package:flash_ability/screens/learning/flashcard/flashcard.dart';
import 'package:flash_ability/screens/learning/learning.dart';
import 'package:flash_ability/screens/learning/test/question/question_screen.dart';
import 'package:flash_ability/screens/learning/test/testing.dart';
import 'package:flash_ability/screens/learning/topic/all_topics.dart';
import 'package:flash_ability/screens/learning/topic/topic.dart';
import 'package:flash_ability/screens/learning/vocab/vocab.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Language Learning App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/learning',
      routes: {
        '/learning': (context) => const LearningScreen(),
        '/learning/all_topics': (context) => const AllTopicsScreen(),
        '/learning/topic': (context) => const TopicScreen(),
        '/learning/flashcard': (context) => const FlashcardScreen(),
        '/learning/vocab': (context) => const VocabScreen(),
        '/learning/test': (context) => const QuestionScreen() //const TestingScreen(),
      },
    );
  }
}