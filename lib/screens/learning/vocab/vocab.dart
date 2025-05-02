import 'package:flutter/material.dart';
import 'package:flash_ability/mock_data/flashcards.dart';

class VocabScreen extends StatelessWidget {
  const VocabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> vocabulary = [];
    for (var flashcard in flashcards) {
      vocabulary.add(flashcard['word']!);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('New vocab'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: vocabulary.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/learning/flashcard',
                        arguments: {
                          'words': vocabulary,
                          'index': index,
                        }
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          vocabulary[index],
                          style: const TextStyle(fontSize: 18),
                        ),
                        const Icon(Icons.arrow_forward),
                      ],
                    ),
                    ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}