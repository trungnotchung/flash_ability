import 'package:flash_ability/screens/management/flashcard/my_flashcard_of_group_screen.dart';
import 'package:flash_ability/services/management/flashcard/group.dart';
import 'package:flutter/material.dart';

class MyFlashcardScreen extends StatefulWidget {
  const MyFlashcardScreen({super.key});

  @override
  State<MyFlashcardScreen> createState() => _MyFlashcardScreenState();
}

class _MyFlashcardScreenState extends State<MyFlashcardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: BackButton(color: Theme.of(context).colorScheme.onSurface),
        title: Text(
          'My Flashcards',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Flashcard Groups",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Select a group to view its flashcards",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: FutureBuilder<List<String>>(
                    future: GroupOperation.getGroups(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Theme.of(context).colorScheme.error,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Could not load flashcard groups',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.style_outlined,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.5),
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No flashcard groups yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap the + button to create your first group',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return ListView.separated(
                          itemCount: snapshot.data!.length,
                          separatorBuilder:
                              (context, index) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final group = snapshot.data![index];
                            return FlashcardGroupButton(
                              groupName: group,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => MyFlashcardOfGroupScreen(
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
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final TextEditingController controller = TextEditingController();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Create New Group'),
              content: TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Enter group name',
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  border: OutlineInputBorder(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    final value = controller.text.trim();
                    if (value.isNotEmpty) {
                      await GroupOperation.addGroup(value);

                      print("Groups: ${await GroupOperation.getGroups()}");

                      if (mounted) {
                        Navigator.of(context).pop();
                        setState(() {}); // Refresh the list
                      }
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            ),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.style_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                groupName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
