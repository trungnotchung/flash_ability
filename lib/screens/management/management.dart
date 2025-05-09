import 'package:flash_ability/screens/management/flashcard/my_flashcard_screen.dart';
import 'package:flash_ability/screens/progress_screen.dart';
import 'package:flash_ability/screens/community/my_community_screen.dart';
import 'package:flutter/material.dart';

class ManagementScreen extends StatelessWidget {
  const ManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Management',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ManagementButton(
              title: 'My flashcard',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyFlashcardScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ManagementButton(
              title: 'My progress',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProgressScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ManagementButton(
              title: 'My community',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyCommunityScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ManagementButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ManagementButton({super.key, required this.title, required this.onTap});

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
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
