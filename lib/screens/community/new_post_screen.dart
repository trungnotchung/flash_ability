import 'package:flutter/material.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'New post',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        actions: [
          TextButton(
            onPressed:
                _postController.text.trim().isNotEmpty
                    ? () {
                      // Implement post submission
                      Navigator.pop(context);
                    }
                    : null,
            child: const Text(
              'Post',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.groupName != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Posting in ${widget.groupName}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            TextField(
              controller: _postController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Type here',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(16),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text(
                  'Tags:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          availableTags.map((tag) {
                            final isSelected = selectedTag == tag;
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
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? Colors.blue
                                          : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  tag,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildOptionRow('Attachment', Icons.attach_file, hasAttachment, () {
              setState(() {
                hasAttachment = !hasAttachment;
              });
            }),
            const Divider(),
            _buildOptionRow('Location', Icons.location_on, hasLocation, () {
              setState(() {
                hasLocation = !hasLocation;
              });
            }),
            const Divider(),
            _buildOptionRow('Emoji', Icons.emoji_emotions, hasEmoji, () {
              setState(() {
                hasEmoji = !hasEmoji;
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionRow(
    String title,
    IconData icon,
    bool isActive,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: isActive ? Colors.blue : Colors.grey, size: 20),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isActive ? Colors.blue : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            if (isActive) const Icon(Icons.check, color: Colors.blue, size: 20),
          ],
        ),
      ),
    );
  }
}
