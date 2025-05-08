import 'package:flash_ability/screens/management/flashcard/my_flashcard_of_group_screen.dart';
import 'package:flash_ability/services/management/flashcard/group.dart';
import 'package:flutter/material.dart';

class MyFlashcardScreen extends StatelessWidget {
  const MyFlashcardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'My Flashcard',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<List<String>>(
          future: GroupOperation.getGroups(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No flashcard groups found'));
            } else {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                separatorBuilder: (context, index) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final group = snapshot.data![index];
                  return FlashcardGroupButton(
                    groupName: group,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyFlashcardOfGroupScreen(
                            groupName: group,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.grey,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class FlashcardGroupButton extends StatelessWidget {
  final String groupName;
  final VoidCallback onTap;

  const FlashcardGroupButton({
    super.key,
    required this.groupName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            groupName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}