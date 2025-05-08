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

class _QuestionScreenState extends State<QuestionScreen> with SingleTickerProviderStateMixin {
  // Get the question data from the mock data
  final List<Map<String, dynamic>> questions = questionData;
  int currentIndex = 0;
  late final AnimationController _pageTransitionController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _pageTransitionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pageTransitionController,
      curve: Curves.easeInOut,
    ));

    _pageTransitionController.forward();
  }

  @override
  void dispose() {
    _pageTransitionController.dispose();
    super.dispose();
  }

  void moveToPreviousQuestion() {
    _pageTransitionController.reverse().then((_) {
      setState(() {
        currentIndex = (currentIndex - 1 + questions.length) % questions.length;
      });
      _pageTransitionController.forward();
    });
  }

  void moveToNextQuestion() {
    _pageTransitionController.reverse().then((_) {
      setState(() {
        currentIndex = (currentIndex + 1) % questions.length;
      });
      _pageTransitionController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Question',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
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
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface.withOpacity(0.9),
            ],
          ),
        ),
        child: Row(
          children: [
            // Left navigation button
            NavigationButton(
              icon: Icons.chevron_left,
              onPressed: moveToPreviousQuestion,
            ),
            // Main content expanded to take most of the space
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 16.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Builder(
                      builder: (context) {
                        final questionData = questions[currentIndex];
                        final questionType = questionData['type'] as String;

                        // Progress indicator at the top
                        return Column(
                          children: [
                            LinearProgressIndicator(
                              value: (currentIndex + 1) / questions.length,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            Expanded(
                              child: _buildQuestionContent(questionType, questionData),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            // Right navigation button
            NavigationButton(
              icon: Icons.chevron_right,
              onPressed: moveToNextQuestion,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionContent(String questionType, Map<String, dynamic> questionData) {
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Unknown question type: $questionType',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
        );
    }
  }
}

class NavigationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const NavigationButton({
    required this.icon,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: 32,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        onPressed: onPressed,
        padding: const EdgeInsets.all(12),
        splashRadius: 28,
      ),
    );
  }
}