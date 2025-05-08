import 'package:flash_ability/screens/learning/flashcard/flashcards.dart';
import 'package:flash_ability/screens/learning/learning.dart';
import 'package:flash_ability/screens/learning/test/question/question_screen.dart';
import 'package:flash_ability/screens/learning/test/testing.dart';
import 'package:flash_ability/screens/learning/topic/all_topics.dart';
import 'package:flash_ability/screens/learning/topic/topic.dart';
import 'package:flash_ability/screens/learning/vocab/vocab.dart';
import 'package:flash_ability/screens/main_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Language Learning App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/learning': (context) => const LearningScreen(),
        '/learning/all_topics': (context) => const AllTopicsScreen(),
        '/learning/topic': (context) => const TopicScreen(),
        '/learning/flashcard': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
          return FlashcardScreen(words: args['words'], index: args['index']);
        },
        '/learning/vocab': (context) => const VocabScreen(),
        '/learning/test': (context) => const TestingScreen(),
        '/learning/test/question': (context) => const QuestionScreen(),
      },
    );
  }
}