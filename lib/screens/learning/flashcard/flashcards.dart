import 'package:flutter/material.dart';
import 'package:flash_ability/mock_data/flashcards.dart';

import 'flashcard.dart';

class FlashcardScreen extends StatefulWidget {
  List<String> words;
  int index;
  FlashcardScreen({super.key, required this.words, required this.index});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  // Flashcard data
  late List<Map<String, String>> flashcardData = [];

  @override
  void initState() {
    super.initState();

    for (var word in widget.words) {
      // Find the flashcard data for the selected word
      var flashcard = flashcards.firstWhere((flashcard) => flashcard['word'] == word, orElse: () => {});
      if (flashcard.isNotEmpty) {
        flashcardData.add(flashcard);
      }
    }

    // Set the current index to the selected word
    currentIndex = widget.index;
  }

  int currentIndex = 0;

  void moveToNextCard() {
    setState(() {
      currentIndex = (currentIndex + 1) % flashcardData.length;
    });
  }

  void moveToPreviousCard() {
    setState(() {
      currentIndex = (currentIndex - 1 + flashcardData.length) % flashcardData.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard'),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  moveToPreviousCard();
                },
                icon: const Icon(Icons.arrow_circle_left_outlined),
                iconSize: 28,
              ),
              Expanded(
                child: FlashCard(
                  data: flashcardData[currentIndex],
                ),
              ),
              IconButton(
                onPressed: () {
                  moveToNextCard();
                },
                icon: const Icon(Icons.arrow_circle_right_outlined),
                iconSize: 28,
              ),
            ],
          )
        ),
      ),
    );
  }
}