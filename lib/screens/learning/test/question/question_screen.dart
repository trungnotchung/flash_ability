import 'package:flash_ability/screens/learning/test/question/matching.dart';
import 'package:flash_ability/screens/learning/test/question/video_answer.dart';
import 'package:flash_ability/screens/learning/test/question/video_answers.dart';
import 'package:flash_ability/mock_data/test/questions.dart';
import 'package:flutter/material.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  // List<Map<String, dynamic>> questions = [
  //   {
  //     "type": "video_answer",
  //     "videoUrl": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
  //     "answer": "father",
  //   },
  //   {
  //     "type": "video_answers",
  //     "videoUrl": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
  //     "answers": [
  //       "father",
  //       "mother",
  //       "brother",
  //     ],
  //     "correctAnswer": "father",
  //   }
  // ];

  // Get the question data from the mock data
  List<Map<String, dynamic>> questions = questionData;
  // Print the question data to the console

  int currentIndex = 0;

  void moveToPreviousQuestion() {
    setState(() {
      currentIndex = (currentIndex - 1 + questions.length) % questions.length;
    });
  }

  void moveToNextQuestion() {
    setState(() {
      currentIndex = (currentIndex + 1) % questions.length;
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
                moveToPreviousQuestion();
              },
            ),
          ),
          // Nội dung chính mở rộng ra hầu hết không gian
         Expanded(
            child: Builder(
              builder: (context) {
                final questionData = questions[currentIndex];
                final questionType = questionData['type'] as String;

                switch (questionType) {
                  case 'video_answer':
                    return VideoAnswer(
                      videoUrl: questionData['videoUrl'],
                      answer: questionData['answer'],
                    );
                  case 'video_answers':
                    return VideoAnswers(
                      videoUrl: questionData['videoUrl'],
                      answers: List<String>.from(questionData['answers']),
                      correctAnswer: questionData['correctAnswer'],
                    );
                  case 'matching':
                    return MatchingQuestionPage();
                  // case 'question_videos':
                  //   return QuestionVideos(
                  //     question: questionData['question'] ?? '',
                  //     videoUrls: List<String>.from(questionData['videoUrls'] ?? []),
                  //     correctIndex: questionData['correctIndex'] ?? 0,
                  //   );
                  default:
                    return Center(
                      child: Text('Unknown question type: $questionType'),
                    );
                }
              },
            ),
          ),
          // Nút phải
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.arrow_right, size: 32),
              onPressed: () {
                moveToNextQuestion();
              },
            ),
          ),
        ],
      ),
    );
  }


}