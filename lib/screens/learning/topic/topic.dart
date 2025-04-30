import 'package:flutter/material.dart';

class TopicScreen extends StatelessWidget {
  const TopicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String topic = ModalRoute.of(context)?.settings.arguments as String;

    // List of family members
    final List<Map<String, String>> familyMembers = [
      {'name': 'grandmother', 'route': '/learning/flashcard'},
      {'name': 'grandfather', 'route': '/learning/flashcard'},
      {'name': 'mother', 'route': '/learning/flashcard'},
      {'name': 'father', 'route': '/learning/flashcard'},
      {'name': 'sister', 'route': '/learning/flashcard'},
      {'name': 'brother', 'route': '/learning/flashcard'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(topic),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: familyMembers.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                      context,
                      familyMembers[index]['route']!,
                      arguments: familyMembers[index]['name']
                  );
                },
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          familyMembers[index]['name']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Icon(Icons.arrow_forward, size: 18),
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