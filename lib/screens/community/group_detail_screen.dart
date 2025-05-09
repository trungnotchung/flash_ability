import 'package:flutter/material.dart';
import 'package:flash_ability/screens/community/new_post_screen.dart';
import 'package:flash_ability/screens/community/comments_screen.dart';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewPostScreen(groupName: widget.groupName),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'New post',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Recent activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              widget.recentActivities.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text(
                          'No recent activity in this group',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.recentActivities.length,
                      itemBuilder: (context, index) {
                        final activity = widget.recentActivities[index];
                        final hasComments = activity['commentsData'] != null && 
                                           (activity['commentsData'] as List).isNotEmpty;
                        final isExpanded = expandedComments[index] ?? false;
                        
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.person, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  activity['user'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  activity['activityTime'],
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    activity['activityType'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                activity['post'],
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.favorite_border, 
                                      size: 18, 
                                      color: Colors.grey.shade600
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${activity['likes']}',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                GestureDetector(
                                  onTap: () {
                                    if (hasComments) {
                                      // Toggle comments visibility
                                      setState(() {
                                        expandedComments[index] = !isExpanded;
                                      });
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.comment_outlined, 
                                        size: 18, 
                                        color: Colors.grey.shade600
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${activity['comments']} comments',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            
                            // Only display comments section if expanded
                            if (hasComments && isExpanded)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...(activity['commentsData'] as List).map((comment) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.person_outline, size: 14),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        comment['user'],
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        comment['timestamp'],
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.grey.shade600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    comment['comment'],
                                                    style: const TextStyle(fontSize: 13),
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
                                              builder: (context) => CommentsScreen(
                                                post: activity['post'],
                                                user: activity['user'],
                                                comments: activity['commentsData'],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'View all ${activity['comments']} comments',
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    
                                    // Add comment input field
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            decoration: const InputDecoration(
                                              hintText: 'Add a comment...',
                                              hintStyle: TextStyle(fontSize: 12),
                                              isDense: true,
                                              contentPadding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 8,
                                              ),
                                            ),
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.send, size: 16),
                                          onPressed: () {
                                            // Implement add comment functionality
                                          },
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            
                            const SizedBox(height: 24),
                          ],
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}