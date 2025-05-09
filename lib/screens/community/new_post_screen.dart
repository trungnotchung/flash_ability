import 'package:flutter/material.dart';
import 'package:flash_ability/utils/community_theme.dart';

class NewPostScreen extends StatefulWidget {
  final String? groupName;

  const NewPostScreen({super.key, this.groupName});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final TextEditingController _postController = TextEditingController();
  String? selectedTag;
  bool hasAttachment = false;
  bool hasLocation = false;
  bool hasEmoji = false;

  final List<String> availableTags = [
    'Q&A',
    'Tips',
    'Discussion',
    'New Flashcard',
    'Help',
  ];

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommunityTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: CommunityTheme.textPrimary),
        title: const Text(
          'New post',
          style: TextStyle(
            color: CommunityTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: ElevatedButton(
              onPressed:
                  _postController.text.trim().isNotEmpty
                      ? () {
                        // Implement post submission
                        Navigator.pop(context);
                      }
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: CommunityTheme.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: CommunityTheme.primary.withOpacity(
                  0.5,
                ),
                disabledForegroundColor: Colors.white.withOpacity(0.8),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
              ),
              child: const Text(
                'Post',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.groupName != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: CommunityTheme.primaryLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.group,
                            size: 16,
                            color: CommunityTheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Posting in ${widget.groupName}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: CommunityTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        backgroundColor: CommunityTheme.primaryLight,
                        radius: 20,
                        child: Icon(
                          Icons.person,
                          size: 20,
                          color: CommunityTheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _postController,
                          maxLines: 8,
                          minLines: 5,
                          decoration: const InputDecoration(
                            hintText: 'What\'s on your mind?',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: const TextStyle(fontSize: 16, height: 1.4),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add to your post',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 16),

                  // Tags section
                  const Text(
                    'Tags',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: CommunityTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          availableTags.map((tag) {
                            final isSelected = selectedTag == tag;
                            final tagColor =
                                CommunityTheme.tagColors[tag] ??
                                CommunityTheme.primaryLight;
                            final tagTextColor =
                                CommunityTheme.tagTextColors[tag] ??
                                CommunityTheme.primary;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedTag = isSelected ? null : tag;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? tagColor
                                          : Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? Colors.transparent
                                            : CommunityTheme.border,
                                  ),
                                ),
                                child: Text(
                                  tag,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? tagTextColor
                                            : CommunityTheme.textSecondary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Options
                  _buildOptionRow(
                    title: 'Attachment',
                    icon: Icons.attach_file,
                    isActive: hasAttachment,
                    onTap: () {
                      setState(() {
                        hasAttachment = !hasAttachment;
                      });
                    },
                  ),
                  const Divider(
                    height: 24,
                    thickness: 1,
                    color: CommunityTheme.divider,
                  ),
                  _buildOptionRow(
                    title: 'Location',
                    icon: Icons.location_on,
                    isActive: hasLocation,
                    onTap: () {
                      setState(() {
                        hasLocation = !hasLocation;
                      });
                    },
                  ),
                  const Divider(
                    height: 24,
                    thickness: 1,
                    color: CommunityTheme.divider,
                  ),
                  _buildOptionRow(
                    title: 'Emoji',
                    icon: Icons.emoji_emotions,
                    isActive: hasEmoji,
                    onTap: () {
                      setState(() {
                        hasEmoji = !hasEmoji;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionRow({
    required String title,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  isActive
                      ? CommunityTheme.primary
                      : CommunityTheme.textSecondary,
              size: 22,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color:
                    isActive
                        ? CommunityTheme.primary
                        : CommunityTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            if (isActive)
              const Icon(
                Icons.check_circle,
                color: CommunityTheme.primary,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
