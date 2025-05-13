import 'package:flash_ability/screens/learning/learning.dart';
import 'package:flash_ability/screens/management/management.dart';
import 'package:flash_ability/services/learning/topic/topic.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomePage(),
    const LearningScreen(),
    const ManagementScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: 'Learning',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_center_outlined),
            activeIcon: Icon(Icons.business_center),
            label: 'Management',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show different add options based on the current tab
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.add_card),
                      title: const Text('Add New Vocabulary'),
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: Navigate to add vocabulary screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Add vocabulary feature coming soon!',
                            ),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.category),
                      title: const Text('Add New Topic'),
                      onTap: () {
                        Navigator.pop(context);
                        // Show dialog to enter new topic
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String newTopic = '';
                            return AlertDialog(
                              title: const Text('Add New Topic'),
                              content: TextField(
                                autofocus: true,
                                decoration: const InputDecoration(
                                  hintText: 'Enter topic name',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  newTopic = value;
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    if (newTopic.trim().isNotEmpty) {
                                      TopicOperation.addTopic(newTopic);

                                      // Close dialog and show confirmation
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Topic "$newTopic" has been added'),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: const Text('Add'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
