import 'package:flutter/material.dart';
import 'package:flash_ability/utils/community_theme.dart';

class CommentsScreen extends StatefulWidget {
  final String post;
  final String user;
  final List<dynamic> comments;

  const CommentsScreen({
    super.key,
    required this.post,
    required this.user,
    required this.comments,
  });

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Track liked comments
  Set<int> likedComments = {};

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
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
          'Comments',
          style: TextStyle(
            color: CommunityTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Original post
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: CommunityTheme.primaryLight,
                      radius: 18,
                      child: Text(
                        widget.user[0],
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
                          widget.user,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.post,
                  style: const TextStyle(fontSize: 16, height: 1.4),
                ),
              ],
            ),
          ),

          // Comments count
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: CommunityTheme.background,
            child: Text(
              '${widget.comments.length} comments',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: CommunityTheme.textSecondary,
              ),
            ),
          ),

          // Comments list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: widget.comments.length,
              itemBuilder: (context, index) {
                final comment = widget.comments[index];
                final isLiked = likedComments.contains(index);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: CommunityTheme.primaryLight,
                            radius: 18,
                            child: Text(
                              comment['user'][0],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: CommunityTheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      comment['user'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      comment['timestamp'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: CommunityTheme.textLight,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  comment['comment'],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isLiked) {
                                  likedComments.remove(index);
                                } else {
                                  likedComments.add(index);
                                }
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 18,
                                  color:
                                      isLiked
                                          ? CommunityTheme.primary
                                          : CommunityTheme.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Like',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        isLiked
                                            ? CommunityTheme.primary
                                            : CommunityTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () {
                              // Focus the comment input and mention the user
                              _commentController.text = '@${comment['user']} ';
                              _commentController
                                  .selection = TextSelection.fromPosition(
                                TextPosition(
                                  offset: _commentController.text.length,
                                ),
                              );
                              FocusScope.of(context).requestFocus(FocusNode());
                              Future.delayed(
                                const Duration(milliseconds: 100),
                                () {
                                  FocusScope.of(context).requestFocus();
                                },
                              );
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.reply,
                                  size: 18,
                                  color: CommunityTheme.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Reply',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: CommunityTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Comment input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: CommunityTheme.primaryLight,
                  radius: 18,
                  child: Icon(
                    Icons.person,
                    size: 18,
                    color: CommunityTheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: CommunityTheme.inputBackground,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Write a comment...',
                        hintStyle: const TextStyle(
                          color: CommunityTheme.textLight,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.send_rounded,
                            color: CommunityTheme.primary,
                          ),
                          onPressed: () {
                            // Implement add comment functionality
                            if (_commentController.text.trim().isNotEmpty) {
                              // In a real app, you would add the comment to the database
                              // For now, we'll just clear the input
                              _commentController.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Comment added'),
                                  duration: Duration(seconds: 1),
                                  backgroundColor: CommunityTheme.primary,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
