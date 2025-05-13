import '../../../mock_data/management/my_flashcard.dart';

class GroupOperation {
  GroupOperation._();

  static Future<List<String>> getGroups() async {
    // Simulate a network call or database query
    await Future.delayed(const Duration(seconds: 1));
    return flashcardGroups.map((group) => group['groupName']!).toList();
  }

  static Future<void> addGroup(String groupName) async {
    // Simulate a network call
    await Future.delayed(const Duration(seconds: 1));
    // Add the new group to the list
    flashcardGroups.add({
      'groupName': groupName,
      'numberOfCards': '0',
      'words': '',
    });
  }
}