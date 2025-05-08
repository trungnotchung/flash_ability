class GroupOperation {
  GroupOperation._();

  static Future<List<String>> getGroups() async {
    // Simulate a network call or database query
    await Future.delayed(const Duration(seconds: 1));
    return [
      'Group 1',
      'Group 2',
      'Group 3',
    ];
  }
}