import 'package:flash_ability/mock_data/management/my_flashcard.dart';
import 'package:flash_ability/mock_data/topics.dart';

import '../../../mock_data/flashcards.dart';

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

  static Future<Map<String, String>> getFlashcardData(String word) async {
    // Simulate a network call
    await Future.delayed(const Duration(seconds: 1));

    // Find the flashcard data for the specified word
    final flashcard = flashcards.firstWhere(
      (flashcard) => flashcard['word'] == word,
      orElse: () => {},
    );

    if (flashcard.isEmpty) {
      return {};
    }

    return {
      'word': flashcard['word'] ?? '',
      'video': flashcard['video'] ?? '',
      'image': flashcard['image'] ?? '',
      'braille': flashcard['braille'] ?? '',
      'description': flashcard['description'] ?? '',
    };
  }

  static Future<void> addFlashcard(String word, String video, String image, String braille, String description) async {
    // Simulate a network call
    await Future.delayed(const Duration(seconds: 1));

    // Add the new flashcard to the list
    flashcards.add({
      'word': word,
      'video': video,
      'image': image,
      'braille': braille,
      'description': description,
    });
  }

  static Future<void> addFlashcardToGroup(String groupName, Map<String, String> flashcard) async {
    // Simulate a network call
    await Future.delayed(const Duration(seconds: 1));

    // Add the flashcard to the specified group
    final group = flashcardGroups.firstWhere(
      (group) => group['groupName'] == groupName,
      orElse: () => {},
    );

    if (group.isNotEmpty) {
      final wordsString = group['words'] ?? '';
      final newWordsString = wordsString.isEmpty ? flashcard['word'] : '$wordsString,${flashcard['word']}';
      group['words'] = newWordsString!;
    }
  }

  static Future<void> editFlashcard(String word, Map<String, String> updatedData) async {
    // Simulate a network call
    await Future.delayed(const Duration(seconds: 1));

    // Find the flashcard and update its data
    final flashcardIndex = flashcards.indexWhere((flashcard) => flashcard['word'] == word);

    if (flashcardIndex != -1) {
      flashcards[flashcardIndex] = {
        ...flashcards[flashcardIndex],
        ...updatedData,
      };
    }
  }

  static Future<void> deleteFlashcard(String word) async {
    // Simulate a network call
    await Future.delayed(const Duration(seconds: 1));

    // Remove the flashcard from the list
    flashcards.removeWhere((flashcard) => flashcard['word'] == word);

    // Remove the flashcard from all groups
    for (var group in flashcardGroups) {
      final wordsString = group['words'] ?? '';
      final newWordsString = wordsString.split(',').where((w) => w != word).join(',');
      group['words'] = newWordsString;
    }

    // Remove the flashcard from the topics
    for (var topic in topicsWithVocab) {
      final flashcardList = topic['flashcards'] ?? [];
      flashcardList.removeWhere((w) => w == word);
      topic['flashcards'] = flashcardList;
    }
  }
}