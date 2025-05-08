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
}