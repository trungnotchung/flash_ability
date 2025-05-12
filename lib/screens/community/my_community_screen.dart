import 'package:flash_ability/mock_data/community/community_page.dart';
import 'package:flash_ability/mock_data/profile/profile.dart';
import 'package:flash_ability/screens/community/comments_screen.dart';
import 'package:flash_ability/screens/community/group_detail_screen.dart';
import 'package:flash_ability/screens/community/new_post_screen.dart';
import 'package:flash_ability/utils/community_theme.dart';
import 'package:flutter/material.dart';

class MyCommunityScreen extends StatefulWidget {
  const MyCommunityScreen({super.key});

  @override
  State<MyCommunityScreen> createState() => _MyCommunityScreenState();
}

class _MyCommunityScreenState extends State<MyCommunityScreen> {
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
        'user': userProfile['name'] ?? 'Anonymous User', // Use actual user name
        'comment': comment,
        'timestamp': 'Just now',
      };

      // Add comment to the activity's commentsData
      if (recentActivities[activityIndex]['commentsData'] == null) {
        recentActivities[activityIndex]['commentsData'] = [];
      }
      (recentActivities[activityIndex]['commentsData'] as List).add(newComment);

      // Update comment count
      recentActivities[activityIndex]['comments'] =
          (recentActivities[activityIndex]['comments'] as int) + 1;

      // Clear the comment input
      commentControllers[activityIndex]?.clear();
    });
  }

  // Add function to handle like/unlike
  void _toggleLike(int activityIndex) {
    setState(() {
      final activity = recentActivities[activityIndex];
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
        title: const Text(
          'Community',
          style: TextStyle(
            color: CommunityTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: CommunityTheme.textPrimary),
            onPressed: () {
              // Implement search functionality
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
              const Text('Your community', style: CommunityTheme.headingStyle),
              const SizedBox(height: 16),
              SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      communityGroups.length + 1, // +1 for the add button
                  itemBuilder: (context, index) {
                    if (index == communityGroups.length) {
                      // Add new group button
                      return GestureDetector(
                        onTap: () {
                          // Implement add new group functionality
                        },
                        child: Container(
                          width: 90,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: CommunityTheme.primaryLight,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: CommunityTheme.primary.withOpacity(0.3),
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.add_circle_outline,
                              size: 30,
                              color: CommunityTheme.primary,
                            ),
                          ),
                        ),
                      );
                    }

                    // Community group item
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => GroupDetailScreen(
                                  groupName:
                                      communityGroups[index]['groupName'],
                                  recentActivities:
                                      recentActivities
                                          .where(
                                            (activity) =>
                                                activity['group'] ==
                                                communityGroups[index]['groupName'],
                                          )
                                          .toList(),
                                ),
                          ),
                        );
                      },
                      child: Container(
                        width: 90,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              CommunityTheme.primary.withOpacity(0.8),
                              CommunityTheme.primaryDark,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: CommunityTheme.primary.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white.withOpacity(0.9),
                              radius: 24,
                              child: Text(
                                communityGroups[index]['groupName'][0],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: CommunityTheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              communityGroups[index]['groupName'].split(' ')[0],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${communityGroups[index]['membersCount']} members',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              const Text('Recent activity', style: CommunityTheme.headingStyle),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentActivities.length,
                itemBuilder: (context, index) {
                  final activity = recentActivities[index];
                  final hasComments =
                      activity['commentsData'] != null &&
                      (activity['commentsData'] as List).isNotEmpty;
                  final isExpanded = expandedComments[index] ?? false;
                  final activityType = activity['activityType'] as String;
                  final tagColor =
                      CommunityTheme.tagColors[activityType] ??
                      CommunityTheme.primaryLight;
                  final tagTextColor =
                      CommunityTheme.tagTextColors[activityType] ??
                      CommunityTheme.primary;
                  final groupName = activity['group'] as String;

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
                                backgroundColor: CommunityTheme.primaryLight,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  borderRadius: BorderRadius.circular(12),
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

                        // Group indicator - NEW
                        GestureDetector(
                          onTap: () {
                            // Navigate to the group when tapped
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => GroupDetailScreen(
                                      groupName: groupName,
                                      recentActivities:
                                          recentActivities
                                              .where(
                                                (activity) =>
                                                    activity['group'] ==
                                                    groupName,
                                              )
                                              .toList(),
                                    ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              bottom: 12.0,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.group,
                                  size: 14,
                                  color: CommunityTheme.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Posted in ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: CommunityTheme.textSecondary,
                                  ),
                                ),
                                Text(
                                  groupName,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: CommunityTheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            activity['post'],
                            style: const TextStyle(fontSize: 16, height: 1.4),
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
                                      expandedComments[index] = !isExpanded;
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...(activity['commentsData'] as List).map((
                                  comment,
                                ) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12.0),
                                    padding: const EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
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
                                              CommunityTheme.primaryLight,
                                          radius: 14,
                                          child: Text(
                                            comment['user'][0],
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: CommunityTheme.primary,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    comment['user'],
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
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
                                              (context) => CommentsScreen(
                                                post: activity['post'],
                                                user: activity['user'],
                                                comments:
                                                    activity['commentsData'],
                                              ),
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: CommunityTheme.primary,
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(0, 36),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
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
                                    borderRadius: BorderRadius.circular(24),
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
                                                () => TextEditingController(),
                                              ),
                                          decoration: const InputDecoration(
                                            hintText: 'Write a comment...',
                                            hintStyle: TextStyle(
                                              fontSize: 13,
                                              color: CommunityTheme.textLight,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  vertical: 12,
                                                ),
                                          ),
                                          style: const TextStyle(fontSize: 13),
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
                                            _addComment(index, controller.text);
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewPostScreen()),
          );
        },
        backgroundColor: CommunityTheme.primary,
        elevation: 2,
        child: const Icon(Icons.add, size: 28),
      ),
    );
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
