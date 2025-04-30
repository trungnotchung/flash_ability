import 'package:flash_ability/screens/learning/test/question/video_answer.dart';
import 'package:flutter/material.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int currentIndex = 0;

  void moveToNextQuestion() {
    setState(() {
      currentIndex = (currentIndex + 1) % 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Row(
        children: [
          // Nút trái
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_left, size: 32),
              onPressed: () {
                // TODO: Xử lý khi nhấn nút trái
              },
            ),
          ),
          // Nội dung chính mở rộng ra hầu hết không gian
          Expanded(
            child: VideoAnswer(
              videoUrl: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
              answer: "Đây là câu trả lời cho câu hỏi của bạn.",
            )
          ),
          // Nút phải
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.arrow_right, size: 32),
              onPressed: () {
                // TODO: Xử lý khi nhấn nút phải
              },
            ),
          ),
        ],
      ),
    );
  }


}