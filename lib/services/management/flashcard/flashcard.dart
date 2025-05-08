import 'package:flash_ability/mock_data/management/my_flashcard.dart';

class FlashcardOperation {
  FlashcardOperation._();

  static Future<List<String>> getFlashcardOfGroup(String groupName) async {
      // Simulate a network call
      await Future.delayed(const Duration(seconds: 1));

      // Return the flashcard words for the specified group
      final wordsString = flashcardGroups
          .firstWhere((group) => group['groupName'] == groupName)['words'];

      if (wordsString == null || wordsString.isEmpty) {
        return [];
      }

      return wordsString.split(',');
    }
}