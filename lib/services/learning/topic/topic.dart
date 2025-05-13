import '../../../mock_data/topics.dart';

class TopicOperation {
  TopicOperation._();

  static List<String> getTopicVocab(String topic) {
    // Simulate a network call to fetch vocab for a specific topic
    // await Future.delayed(const Duration(seconds: 1));

    // Extracting vocab from the mock data
    List<String> vocab = [];
    for (var item in topicsWithVocab) {
      if (item['topic'] == topic) {
        for (var word in item['vocab']) {
          vocab.add(word['word']);
        }
      }
    }

    return vocab;
  }

  static Future<void> addFlashcardToTopic(String topic, Map<String, String> flashcard) async {
    // Simulate a network call
    await Future.delayed(const Duration(seconds: 1));

    // Add the flashcard to the specified topic
    final topicData = topicsWithVocab.firstWhere(
      (item) => item['topic'] == topic,
      orElse: () => {},
    );

    if (topicData.isNotEmpty) {
      final vocabList = topicData['vocab'] ?? [];
      vocabList.add(flashcard);
      topicData['vocab'] = vocabList;
    }
  }

  static Future<void> addTopic(String topic) async {
    // Simulate a network call
    await Future.delayed(const Duration(seconds: 1));

    // Add the topic to the list
    topicsWithVocab.add({
      'topic': topic,
      'vocab': [],
    });
  }
}