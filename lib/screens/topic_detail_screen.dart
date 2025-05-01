import 'package:flutter/material.dart';
import '../models/topic.dart';
import '../models/vocabulary.dart';
import '../widgets/vocabulary_card.dart';

class TopicDetailScreen extends StatelessWidget {
  final Topic topic;

  const TopicDetailScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    // Sample vocabulary items for this topic
    // In a real app, these would be fetched from a database or API
    final List<Vocabulary> topicVocabulary = [
      Vocabulary(
        id: '1',
        word: 'Dog',
        meaning: 'A domesticated carnivorous mammal',
        exampleSentence: 'The dog is playing outside.',
        imageUrl: 'assets/images/dog.png',
      ),
      Vocabulary(
        id: '4',
        word: 'Cat',
        meaning: 'A small domesticated carnivorous mammal',
        exampleSentence: 'The cat is sleeping on the sofa.',
        imageUrl: 'assets/images/cat.png',
      ),
      Vocabulary(
        id: '5',
        word: 'Bird',
        meaning: 'A warm-blooded egg-laying vertebrate animal',
        exampleSentence: 'The bird is singing in the tree.',
        imageUrl: 'assets/images/bird.png',
      ),
      Vocabulary(
        id: '6',
        word: 'Fish',
        meaning: 'A limbless cold-blooded vertebrate animal with gills',
        exampleSentence: 'The fish is swimming in the pond.',
        imageUrl: 'assets/images/fish.png',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(topic.name)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.asset(
                    topic.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 40,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        topic.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${topicVocabulary.length} vocabulary items',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Vocabulary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemCount: topicVocabulary.length,
                itemBuilder: (context, index) {
                  return VocabularyCard(vocabulary: topicVocabulary[index]);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add vocabulary to topic functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add vocabulary feature coming soon!'),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
