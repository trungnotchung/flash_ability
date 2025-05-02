import 'package:flash_ability/mock_data/topics.dart';

class AllTopicsOperation {
  AllTopicsOperation._();

  static Future<List<String>> getAllTopics() async {
      // Simulate a network call to fetch all topics
      await Future.delayed(const Duration(seconds: 1));

      // Extracting topics from the mock data
      List<String> topics = [];
      for (var topic in topicsWithVocab) {
        topics.add(topic['topic']);
      }

      return topics;
    }
}