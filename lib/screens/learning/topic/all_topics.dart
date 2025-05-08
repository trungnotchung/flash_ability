import 'package:flash_ability/services/learning/topic/all_topic.dart';
import 'package:flutter/material.dart';

class AllTopicsScreen extends StatelessWidget {
  const AllTopicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Topics',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.2),
              Colors.white,
            ],
          ),
        ),
        child: FutureBuilder<List<String>>(
          future: AllTopicsOperation.getAllTopics(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.red.shade700),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.category_outlined, size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      'No topics available yet.',
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            final topics = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildTopicCard(context, topics[index], index),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopicCard(BuildContext context, String topic, int index) {
    // Generate a list of colors to use for topic cards
    final List<Color> colors = [
      Colors.blue.shade700,
      Colors.green.shade700,
      Colors.orange.shade700,
      Colors.purple.shade700,
      Colors.teal.shade700,
    ];

    // Use the index to select a color, cycling through the list
    final color = colors[index % colors.length];

    // Generate an icon based on topic (you could expand this logic)
    IconData topicIcon = Icons.category;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/learning/topic', arguments: topic);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Icon(
                topicIcon,
                color: color,
                size: 24.0,
              ),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Text(
                topic,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 16.0,
            ),
          ],
        ),
      ),
    );
  }
}