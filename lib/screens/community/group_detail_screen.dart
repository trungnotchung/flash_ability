import 'package:flash_ability/mock_data/profile/profile.dart';
import 'package:flash_ability/screens/community/comments_screen.dart';
import 'package:flash_ability/screens/community/new_post_screen.dart';
import 'package:flash_ability/utils/community_theme.dart';
import 'package:flutter/material.dart';

class GroupDetailScreen extends StatefulWidget {
  final String groupName;
  final List<Map<String, dynamic>> recentActivities;

  const GroupDetailScreen({
    super.key,
    required this.groupName,
    required this.recentActivities,
  });

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  // Track which posts have expanded comments
  Map<int, bool> expandedComments = {};
  // Add TextEditingController for comment input
  final Map<int, TextEditingController> commentControllers = {};
  // Track which posts are liked
  Set<int> likedPosts = {};

  @override
  void dispose() {
    // Dispose all comment controllers
    for (var controller in commentControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // Add function to handle new comments
  void _addComment(int activityIndex, String comment) {
    if (comment.trim().isEmpty) return;

    setState(() {
      // Create new comment data with actual user name
      final newComment = {
        'user': userProfile['name'] ?? 'Anonymous User',
        'comment': comment,
        'timestamp': 'Just now',
      };

      // Add comment to the activity's commentsData
      if (widget.recentActivities[activityIndex]['commentsData'] == null) {
        widget.recentActivities[activityIndex]['commentsData'] = [];
      }
      (widget.recentActivities[activityIndex]['commentsData'] as List).add(
        newComment,
      );

      // Update comment count
      widget.recentActivities[activityIndex]['comments'] =
          (widget.recentActivities[activityIndex]['comments'] as int) + 1;

      // Clear the comment input
      commentControllers[activityIndex]?.clear();
    });
  }

  // Add function to handle like/unlike
  void _toggleLike(int activityIndex) {
    setState(() {
      final activity = widget.recentActivities[activityIndex];
      if (likedPosts.contains(activityIndex)) {
        // Unlike
        likedPosts.remove(activityIndex);
        activity['likes'] = (activity['likes'] as int) - 1;
      } else {
        // Like
        likedPosts.add(activityIndex);
        activity['likes'] = (activity['likes'] as int) + 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommunityTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: CommunityTheme.textPrimary),
        title: Text(
          widget.groupName,
          style: const TextStyle(
            color: CommunityTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group header with stats
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: CommunityTheme.primaryLight,
                    radius: 36,
                    child: Text(
                      widget.groupName[0],
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: CommunityTheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.groupName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.recentActivities.length} posts · ${_getMembersCount()} members',
                    style: const TextStyle(
                      color: CommunityTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  NewPostScreen(groupName: widget.groupName),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create Post'),
                    style: CommunityTheme.primaryButtonStyle,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Recent activity section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recent activity',
                    style: CommunityTheme.headingStyle,
                  ),
                  const SizedBox(height: 16),
                  widget.recentActivities.isEmpty
                      ? Center(
                        child: Container(
                          padding: const EdgeInsets.all(32.0),
                          margin: const EdgeInsets.only(top: 32),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: CommunityTheme.border),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.forum_outlined,
                                size: 48,
                                color: CommunityTheme.textLight,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No posts in this group yet',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: CommunityTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Be the first to start a conversation!',
                                style: TextStyle(
                                  color: CommunityTheme.textLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.recentActivities.length,
                        itemBuilder: (context, index) {
                          final activity = widget.recentActivities[index];
                          final hasComments =
                              activity['commentsData'] != null &&
                              (activity['commentsData'] as List).isNotEmpty;
                          final isExpanded = expandedComments[index] ?? false;
                          final activityType =
                              activity['activityType'] as String;
                          final tagColor =
                              CommunityTheme.tagColors[activityType] ??
                              CommunityTheme.primaryLight;
                          final tagTextColor =
                              CommunityTheme.tagTextColors[activityType] ??
                              CommunityTheme.primary;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: CommunityTheme.cardDecoration,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            CommunityTheme.primaryLight,
                                        radius: 18,
                                        child: Text(
                                          activity['user'][0],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: CommunityTheme.primary,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            activity['user'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            activity['activityTime'],
                                            style: const TextStyle(
                                              color: CommunityTheme.textLight,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: tagColor,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          activityType,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: tagTextColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Text(
                                    activity['post'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: CommunityTheme.divider,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      _buildInteractionButton(
                                        icon:
                                            likedPosts.contains(index)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                        label: '${activity['likes']}',
                                        onTap: () => _toggleLike(index),
                                        color:
                                            likedPosts.contains(index)
                                                ? Colors.red
                                                : CommunityTheme.textSecondary,
                                      ),
                                      const SizedBox(width: 24),
                                      _buildInteractionButton(
                                        icon: Icons.chat_bubble_outline,
                                        label: '${activity['comments']}',
                                        onTap: () {
                                          if (hasComments) {
                                            // Toggle comments visibility
                                            setState(() {
                                              expandedComments[index] =
                                                  !isExpanded;
                                            });
                                          }
                                        },
                                      ),
                                      const SizedBox(width: 24),
                                      _buildInteractionButton(
                                        icon: Icons.share_outlined,
                                        label: 'Share',
                                        onTap: () {
                                          // Implement share functionality
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                // Only display comments section if expanded
                                if (hasComments && isExpanded)
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: CommunityTheme.background,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(16),
                                        bottomRight: Radius.circular(16),
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ...(activity['commentsData'] as List).map((
                                          comment,
                                        ) {
                                          return Container(
                                            margin: const EdgeInsets.only(
                                              bottom: 12.0,
                                            ),
                                            padding: const EdgeInsets.all(12.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: CommunityTheme.border,
                                              ),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor:
                                                      CommunityTheme
                                                          .primaryLight,
                                                  radius: 14,
                                                  child: Text(
                                                    comment['user'][0],
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          CommunityTheme
                                                              .primary,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            comment['user'],
                                                            style:
                                                                const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 13,
                                                                ),
                                                          ),
                                                          const SizedBox(
                                                            width: 6,
                                                          ),
                                                          Text(
                                                            comment['timestamp'],
                                                            style: const TextStyle(
                                                              fontSize: 11,
                                                              color:
                                                                  CommunityTheme
                                                                      .textLight,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        comment['comment'],
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),

                                        // View all comments in dedicated screen
                                        if (activity['comments'] > 3)
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (
                                                        context,
                                                      ) => CommentsScreen(
                                                        post: activity['post'],
                                                        user: activity['user'],
                                                        comments:
                                                            activity['commentsData'],
                                                      ),
                                                ),
                                              );
                                            },
                                            style: TextButton.styleFrom(
                                              foregroundColor:
                                                  CommunityTheme.primary,
                                              padding: EdgeInsets.zero,
                                              minimumSize: const Size(0, 36),
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                            ),
                                            child: Text(
                                              'View all ${activity['comments']} comments',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),

                                        // Add comment input field
                                        Container(
                                          margin: const EdgeInsets.only(top: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              24,
                                            ),
                                            border: Border.all(
                                              color: CommunityTheme.border,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              const SizedBox(width: 12),
                                              const CircleAvatar(
                                                backgroundColor:
                                                    CommunityTheme.primaryLight,
                                                radius: 14,
                                                child: Icon(
                                                  Icons.person,
                                                  size: 16,
                                                  color: CommunityTheme.primary,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: TextField(
                                                  controller: commentControllers
                                                      .putIfAbsent(
                                                        index,
                                                        () =>
                                                            TextEditingController(),
                                                      ),
                                                  decoration:
                                                      const InputDecoration(
                                                        hintText:
                                                            'Write a comment...',
                                                        hintStyle: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              CommunityTheme
                                                                  .textLight,
                                                        ),
                                                        border:
                                                            InputBorder.none,
                                                        contentPadding:
                                                            EdgeInsets.symmetric(
                                                              vertical: 12,
                                                            ),
                                                      ),
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.send_rounded,
                                                  size: 20,
                                                  color: CommunityTheme.primary,
                                                ),
                                                onPressed: () {
                                                  final controller =
                                                      commentControllers[index];
                                                  if (controller != null) {
                                                    _addComment(
                                                      index,
                                                      controller.text,
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewPostScreen(groupName: widget.groupName),
            ),
          );
        },
        backgroundColor: CommunityTheme.primary,
        elevation: 2,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  int _getMembersCount() {
    // Find the group in the communityGroups list
    for (var group in [
      {'groupName': 'Flashcard Enthusiasts', 'membersCount': 120},
      {'groupName': 'Language Learners', 'membersCount': 250},
      {'groupName': 'Study Buddies', 'membersCount': 80},
    ]) {
      if (group['groupName'] == widget.groupName) {
        return group['membersCount'] as int;
      }
    }
    return 0;
  }

  Widget _buildInteractionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color ?? CommunityTheme.textSecondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: color ?? CommunityTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
