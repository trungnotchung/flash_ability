import 'dart:io';

import 'package:flash_ability/services/user_service.dart';
import 'package:flash_ability/utils/community_theme.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

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
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  String? _locationAddress;
  Position? _currentPosition;

  final List<String> availableTags = [
    'Q&A',
    'Tips',
    'Discussion',
    'New Flashcard',
    'Help',
  ];

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          hasAttachment = true;
        });
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to pick image'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Location permission denied'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission permanently denied'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get address from coordinates
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _currentPosition = position;
          _locationAddress =
              '${place.street}, ${place.locality}, ${place.country}';
          hasLocation = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to get location'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

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
                  _postController.text.trim().isNotEmpty ||
                          _selectedImage != null
                      ? () {
                        // Create new post data
                        final newPost = {
                          'user':
                              UserService.getCurrentUser()['name'] ??
                              'Anonymous User',
                          'activityTime': 'Just now',
                          'activityType': selectedTag ?? 'Discussion',
                          'post': _postController.text.trim(),
                          'likes': 0,
                          'comments': 0,
                          'group': widget.groupName ?? 'General',
                          'commentsData': [],
                          'attachment': _selectedImage?.path,
                          'location': _locationAddress,
                        };

                        // Return the new post to the previous screen
                        Navigator.pop(context, newPost);
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
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
                            if (_selectedImage != null)
                              Container(
                                margin: const EdgeInsets.only(top: 12),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        _selectedImage!,
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedImage = null;
                                            hasAttachment = false;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.5,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (_locationAddress != null)
                              Container(
                                margin: const EdgeInsets.only(top: 12),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: CommunityTheme.primaryLight,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: CommunityTheme.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        _locationAddress!,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: CommunityTheme.primary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _locationAddress = null;
                                          _currentPosition = null;
                                          hasLocation = false;
                                        });
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: CommunityTheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
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
                    onTap: _pickImage,
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
                    onTap: _getCurrentLocation,
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
