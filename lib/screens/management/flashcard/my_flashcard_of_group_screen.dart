import 'package:flash_ability/screens/management/flashcard/edit_flashcard_of_group.dart';
import 'package:flash_ability/services/management/flashcard/flashcard.dart';
import 'package:flutter/material.dart';

import 'add_flashcard_to_group.dart';

class MyFlashcardOfGroupScreen extends StatefulWidget {
  final String groupName;

  const MyFlashcardOfGroupScreen({
    super.key,
    required this.groupName,
  });

  @override
  State<MyFlashcardOfGroupScreen> createState() => _MyFlashcardOfGroupScreenState();
}

class _MyFlashcardOfGroupScreenState extends State<MyFlashcardOfGroupScreen> {
  late Future<List<String>> _flashcardsFuture;

  @override
  void initState() {
    super.initState();
    _refreshFlashcards();
  }

  void _refreshFlashcards() {
    setState(() {
      _flashcardsFuture = FlashcardOperation.getFlashcardOfGroup(widget.groupName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: const BackButton(color: Colors.black),
        title: Text(
          widget.groupName,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<List<String>>(
          future: _flashcardsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No flashcards found in this group'));
            } else {
              return ListView.separated(
                itemCount: snapshot.data!.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final word = snapshot.data![index];
                  return FlashcardWordCard(
                    groupName: widget.groupName,
                    word: word,
                    onDelete: _refreshFlashcards,
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddFlashcardScreen(groupName: widget.groupName),
            ),
          );

          if (result == true) {
            // Refresh the flashcards list when a new one is added
            _refreshFlashcards();
          }
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class FlashcardWordCard extends StatelessWidget {
  final String groupName;
  final String word;
  final VoidCallback onDelete;

  const FlashcardWordCard({
    super.key,
    required this.groupName,
    required this.word,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        title: Text(
          word.trim(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditFlashcardScreen(
                      groupName: groupName,
                      word: word
                    )
                  ),
                );

                if (result == true) {
                  onDelete(); // Refresh the list after editing
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Delete Flashcard'),
                      content: const Text('Are you sure you want to delete this flashcard?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            FlashcardOperation.deleteFlashcard(word);
                            Navigator.of(context).pop();
                            onDelete(); // Refresh the list after deletion
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}