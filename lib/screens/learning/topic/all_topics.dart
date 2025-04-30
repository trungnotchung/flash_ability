import 'package:flutter/material.dart';

class AllTopicsScreen extends StatelessWidget {
  const AllTopicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = ['Family', 'School', 'Animal', 'Sport', 'Physics', 'Career'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Topic'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: topics.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/learning/topic', arguments: topics[index]);
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      topics[index],
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}