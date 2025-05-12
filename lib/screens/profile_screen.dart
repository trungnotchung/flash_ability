import 'package:flutter/material.dart';

import '../services/user_service.dart';
import 'placeholder_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Default values for settings
  String _selectedLanguage = 'English';
  String _selectedFont = 'Hand-draw';
  double _fontSize = 14;
  String _username = 'User'; // Store current username

  // List of available languages
  final List<String> _languages = ['English', 'Vietnamese', 'Lao'];

  // List of available fonts
  final List<String> _fonts = ['Hand-draw', 'Sans-serif', 'Braille-compatible'];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load user data
  Future<void> _loadUserData() async {
    try {
      final username = await UserService.getUsername();
      if (mounted) {
        setState(() {
          _username = username;
        });
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  // Save username
  Future<void> _saveUsername(String username) async {
    try {
      final success = await UserService.setUsername(username);
      if (success && mounted) {
        setState(() {
          _username = username;
        });
      }
    } catch (e) {
      debugPrint('Error saving username: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Show extended settings panel
              _showExtendedSettingsPanel();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Info Section
              _buildUserInfoSection(),

              const SizedBox(height: 24),

              // Settings Panel
              _buildSettingsPanel(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Center(
      child: Column(
        children: [
          // Avatar with edit option
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                child: const Icon(Icons.person, size: 60, color: Colors.grey),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // Show options to upload photo or choose avatar
                      _showAvatarOptions();
                    },
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Username with edit option
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _username,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () {
                  // Show dialog to edit username
                  _showEditUsernameDialog();
                },
              ),
            ],
          ),

          // User email or additional info
          Text(
            UserService.getCurrentUser()['email'] ?? 'No email',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),

          // Add a new section to show learning progress
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                Text(
                  'Learning Level: ${UserService.getCurrentUser()['learningLevel']}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  'Progress: ${UserService.getCurrentUser()['learningProgress']}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Settings Header
        const Text(
          'Settings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 16),

        // Settings List
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Language Setting
              _buildSettingItem(
                icon: Icons.language,
                title: 'Language',
                value: _selectedLanguage,
                onTap: () {
                  _showLanguageOptions();
                },
              ),

              const Divider(height: 1),

              // Font Setting
              _buildSettingItem(
                icon: Icons.font_download,
                title: 'Font',
                value: _selectedFont,
                onTap: () {
                  _showFontOptions();
                },
              ),

              const Divider(height: 1),

              // Size Setting
              _buildSettingItem(
                icon: Icons.format_size,
                title: 'Size',
                value: _fontSize.toInt().toString(),
                onTap: () {
                  _showSizeOptions();
                },
              ),

              const Divider(height: 1),

              // Security Setting
              _buildSettingItem(
                icon: Icons.security,
                title: 'Security',
                value: '',
                onTap: () {
                  // Navigate to Security Settings screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              const PlaceholderScreen(title: 'Security'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Additional options
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Help & Support
              _buildSettingItem(
                icon: Icons.help_outline,
                title: 'Help & Support',
                value: '',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              const PlaceholderScreen(title: 'Help & Support'),
                    ),
                  );
                },
              ),

              const Divider(height: 1),

              // About
              _buildSettingItem(
                icon: Icons.info_outline,
                title: 'About',
                value: '',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const PlaceholderScreen(title: 'About'),
                    ),
                  );
                },
              ),

              const Divider(height: 1),

              // Logout
              _buildSettingItem(
                icon: Icons.logout,
                title: 'Logout',
                value: '',
                textColor: Colors.red,
                onTap: () {
                  _showLogoutConfirmation();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String value,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Theme.of(context).primaryColor),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w500, color: textColor),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value.isNotEmpty)
            Text(value, style: TextStyle(color: Colors.grey[600])),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
      onTap: onTap,
    );
  }

  void _showAvatarOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Change Profile Picture',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement camera functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Camera functionality coming soon!'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement gallery functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Gallery functionality coming soon!'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.face),
                title: const Text('Choose an Avatar'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement avatar selection
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Avatar selection coming soon!'),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditUsernameDialog() {
    final TextEditingController controller = TextEditingController(
      text: _username,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Username'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _saveUsername(controller.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Username updated to: ${controller.text}'),
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showLanguageOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _languages.length,
              itemBuilder: (context, index) {
                final language = _languages[index];
                return RadioListTile<String>(
                  title: Text(language),
                  value: language,
                  groupValue: _selectedLanguage,
                  onChanged: (value) {
                    Navigator.pop(context);
                    setState(() {
                      _selectedLanguage = value!;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Language changed to: $value')),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showFontOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Font'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _fonts.length,
              itemBuilder: (context, index) {
                final font = _fonts[index];
                return RadioListTile<String>(
                  title: Text(font),
                  value: font,
                  groupValue: _selectedFont,
                  onChanged: (value) {
                    Navigator.pop(context);
                    setState(() {
                      _selectedFont = value!;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Font changed to: $value')),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showSizeOptions() {
    double tempFontSize = _fontSize;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Adjust Font Size'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Sample Text', style: TextStyle(fontSize: tempFontSize)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('10'),
                      Expanded(
                        child: Slider(
                          value: tempFontSize,
                          min: 10,
                          max: 24,
                          divisions: 14,
                          label: tempFontSize.toInt().toString(),
                          onChanged: (value) {
                            setState(() {
                              tempFontSize = value;
                            });
                          },
                        ),
                      ),
                      const Text('24'),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    this.setState(() {
                      _fontSize = tempFontSize;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Font size changed to: ${_fontSize.toInt()}',
                        ),
                      ),
                    );
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showExtendedSettingsPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Advanced Settings',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Accessibility Settings
                    const Text(
                      'Accessibility',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      title: const Text('High Contrast Mode'),
                      subtitle: const Text(
                        'Increase contrast for better visibility',
                      ),
                      value: false,
                      onChanged: (value) {
                        // TODO: Implement high contrast mode
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('High contrast mode coming soon!'),
                          ),
                        );
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Screen Reader Support'),
                      subtitle: const Text('Optimize for screen readers'),
                      value: false,
                      onChanged: (value) {
                        // TODO: Implement screen reader support
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Screen reader support coming soon!'),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // Notification Settings
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      title: const Text('Learning Reminders'),
                      subtitle: const Text(
                        'Receive daily reminders to practice',
                      ),
                      value: true,
                      onChanged: (value) {
                        // TODO: Implement learning reminders
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Learning reminders setting updated!',
                            ),
                          ),
                        );
                      },
                    ),
                    SwitchListTile(
                      title: const Text('New Content Alerts'),
                      subtitle: const Text(
                        'Get notified when new content is available',
                      ),
                      value: true,
                      onChanged: (value) {
                        // TODO: Implement new content alerts
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'New content alerts setting updated!',
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // App Info
                    const Text(
                      'App Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const ListTile(
                      title: Text('Version'),
                      trailing: Text('1.0.0'),
                    ),
                    ListTile(
                      title: const Text('Terms of Service'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // TODO: Navigate to Terms of Service
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Terms of Service coming soon!'),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: const Text('Privacy Policy'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // TODO: Navigate to Privacy Policy
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Privacy Policy coming soon!'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                // TODO: Implement logout functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logout functionality coming soon!'),
                  ),
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
