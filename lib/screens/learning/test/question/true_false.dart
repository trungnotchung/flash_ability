import 'package:flutter/material.dart';

class TrueFalseQuestion extends StatefulWidget {
  final String question;
  final String correctAnswer;
  final Function(bool isCorrect) onAnswerSelected;

  const TrueFalseQuestion({
    super.key,
    required this.question,
    required this.correctAnswer,
    required this.onAnswerSelected,
  });

  @override
  State<TrueFalseQuestion> createState() => _TrueFalseQuestionState();
}

class _TrueFalseQuestionState extends State<TrueFalseQuestion> {
  String? selectedAnswer;
  bool? isCorrect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.question,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildAnswerButton('True')),
              const SizedBox(width: 16),
              Expanded(child: _buildAnswerButton('False')),
            ],
          ),
          const Spacer(),
          if (selectedAnswer != null) _buildFeedback(),
        ],
      ),
    );
  }

  Widget _buildAnswerButton(String answer) {
    bool isSelected = answer == selectedAnswer;
    bool showResult = isCorrect != null;
    bool isCorrectChoice = answer == widget.correctAnswer;

    Color buttonColor;
    if (showResult && isSelected) {
      buttonColor = isCorrectChoice ? Colors.green : Colors.red;
    } else if (showResult && isCorrectChoice) {
      buttonColor = Colors.green.withOpacity(0.6);
    } else {
      buttonColor = isSelected
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.surface;
    }

    return ElevatedButton(
      onPressed: isCorrect != null ? null : () => _selectAnswer(answer),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: isSelected || showResult
            ? Colors.white
            : Theme.of(context).colorScheme.onSurface,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected
                ? Colors.transparent
                : Theme.of(context).colorScheme.outline,
          ),
        ),
      ),
      child: Text(
        answer,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _selectAnswer(String choice) {
    setState(() {
      selectedAnswer = choice;
      isCorrect = choice == widget.correctAnswer;
    });
    widget.onAnswerSelected(isCorrect!);
  }

  Widget _buildFeedback() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect!
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isCorrect! ? Icons.check_circle : Icons.cancel,
            color: isCorrect! ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isCorrect!
                  ? 'Correct! Great job!'
                  : 'Incorrect. The correct answer is "${widget.correctAnswer}".',
              style: TextStyle(
                color: isCorrect! ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}