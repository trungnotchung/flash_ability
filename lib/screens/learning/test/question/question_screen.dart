import 'package:flash_ability/screens/learning/test/question/matching.dart';
import 'package:flash_ability/screens/learning/test/question/multiple_choice.dart';
import 'package:flash_ability/screens/learning/test/question/true_false.dart';
import 'package:flash_ability/screens/learning/test/question/video_answer.dart';
import 'package:flash_ability/screens/learning/test/question/video_answers.dart';
import 'package:flash_ability/mock_data/test/questions.dart';
import 'package:flutter/material.dart';
// import 'dart:math' as math;

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> with SingleTickerProviderStateMixin {
  // Get the question data from the mock data
  final List<Map<String, dynamic>> questions = questionData;
  int currentIndex = 0;
  int score = 0;
  Map<int, bool> questionAnswers = {}; // Track correct/incorrect answers
  bool get isLastQuestion => currentIndex == questions.length - 1;
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

  void submitTest() {
    // Calculate final score based on tracked answers
    int answeredCorrectly = questionAnswers.values.where((correct) => correct).length;
    final finalScore = (answeredCorrectly / questions.length * 100).round();

    // Show a confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Submit Test'),
          content: const Text('Are you sure you want to submit this test?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showResultScreen(finalScore);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _showResultScreen(int finalScore) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TestResultScreen(
          score: finalScore,
          totalQuestions: questions.length,
          correctAnswers: questionAnswers.values.where((v) => v).length,
          onRetake: () {
            Navigator.of(context).pop();
            _resetTest();
          },
          onExit: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  void _resetTest() {
    setState(() {
      currentIndex = 0;
      score = 0;
      questionAnswers.clear();
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
        child: Column(
          children: [
            // Main content expanded to take most of the space
            Expanded(
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
            // Submit button at the bottom
            if (isLastQuestion)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: SubmitButton(onSubmit: submitTest),
                ),
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
          onAnswerSubmitted: (bool isCorrect) {
            setState(() {
              questionAnswers[currentIndex] = isCorrect;
            });
          },
        );
      case 'video_answers':
        return VideoAnswers(
          videoUrl: questionData['videoUrl'],
          answers: List<String>.from(questionData['answers']),
          correctAnswer: questionData['correctAnswer'],
          onAnswerSelected: (bool isCorrect) {
            setState(() {
              questionAnswers[currentIndex] = isCorrect;
            });
          },
        );
      case 'matching':
        return MatchingQuestionPage(
          onMatchComplete: (bool isCorrect) {
            setState(() {
              questionAnswers[currentIndex] = isCorrect;
            });
          },
        );
      case 'multiple_choice':
        return MultipleChoiceQuestion(
          question: questionData['question'],
          choices: List<String>.from(questionData['choices']),
          correctAnswer: questionData['correctAnswer'],
          onAnswerSelected: (bool isCorrect) {
            setState(() {
              questionAnswers[currentIndex] = isCorrect;
            });
          },
        );
      case 'true_false':
        return TrueFalseQuestion(
          question: questionData['question'],
          correctAnswer: questionData['correctAnswer'],
          onAnswerSelected: (bool isCorrect) {
            setState(() {
              questionAnswers[currentIndex] = isCorrect;
            });
          },
        );
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

class SubmitButton extends StatelessWidget {
  final VoidCallback onSubmit;

  const SubmitButton({
    required this.onSubmit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onSubmit,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Submit Test',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(width: 12),
          Icon(
            Icons.check_circle,
            size: 24,
          ),
        ],
      ),
    );
  }
}

class NavigationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const NavigationButton({
    required this.icon,
    required this.onPressed,
    super.key,
  });

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

class TestResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final VoidCallback onRetake;
  final VoidCallback onExit;

  const TestResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.onRetake,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.tertiary,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              margin: const EdgeInsets.all(24),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Test Results',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildScoreCircle(context),
                    const SizedBox(height: 24),
                    Text(
                      '$correctAnswers out of $totalQuestions correct',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _getFeedbackMessage(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: onExit,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            side: BorderSide(color: Theme.of(context).colorScheme.primary),
                          ),
                          child: const Text('Exit'),
                        ),
                        ElevatedButton(
                          onPressed: onRetake,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          ),
                          child: const Text('Retake Test'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCircle(BuildContext context) {
    Color scoreColor;
    if (score >= 80) {
      scoreColor = Colors.green;
    } else if (score >= 60) {
      scoreColor = Colors.orange;
    } else {
      scoreColor = Colors.red;
    }

    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: scoreColor.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$score%',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: scoreColor,
              ),
            ),
            Text(
              'Score',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFeedbackMessage() {
    if (score >= 80) {
      return 'Excellent! You have a great understanding of the material.';
    } else if (score >= 60) {
      return 'Good job! You\'re doing well, but there\'s room for improvement.';
    } else {
      return 'Keep practicing! You\'ll get better with more study.';
    }
  }
}