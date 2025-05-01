import 'package:flutter/material.dart';
import '../models/vocabulary.dart';

class VocabularyDetailScreen extends StatelessWidget {
  final Vocabulary vocabulary;

  const VocabularyDetailScreen({super.key, required this.vocabulary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(vocabulary.word)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                height: 200,
                child: Image.asset(
                  vocabulary.imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 80,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          vocabulary.word,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: const Icon(Icons.volume_up),
                          onPressed: () {
                            // TODO: Implement audio pronunciation
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Audio pronunciation coming soon!',
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Meaning:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      vocabulary.meaning,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Example:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      vocabulary.exampleSentence,
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement practice functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Practice feature coming soon!'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.school),
                  label: const Text('Practice'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement save functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Save feature coming soon!'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.bookmark),
                  label: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
