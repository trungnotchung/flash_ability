import 'package:flutter/material.dart';

class MultipleChoiceQuestion extends StatefulWidget {
  final String question;
  final List<String> choices;
  final String correctAnswer;
  final Function(bool isCorrect) onAnswerSelected;

  const MultipleChoiceQuestion({
    super.key,
    required this.question,
    required this.choices,
    required this.correctAnswer,
    required this.onAnswerSelected,
  });

  @override
  State<MultipleChoiceQuestion> createState() => _MultipleChoiceQuestionState();
}

class _MultipleChoiceQuestionState extends State<MultipleChoiceQuestion> {
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
          ...widget.choices.map((choice) => _buildChoiceItem(choice)),
          const Spacer(),
          if (selectedAnswer != null) _buildFeedback(),
        ],
      ),
    );
  }

  Widget _buildChoiceItem(String choice) {
    bool isSelected = choice == selectedAnswer;
    bool showResult = isCorrect != null;
    bool isCorrectChoice = choice == widget.correctAnswer;

    Color? backgroundColor;
    if (showResult && isSelected) {
      backgroundColor = isCorrectChoice ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2);
    } else if (showResult && isCorrectChoice) {
      backgroundColor = Colors.green.withOpacity(0.2);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isCorrect != null ? null : () => _selectAnswer(choice),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor ?? Theme.of(context).colorScheme.surface,
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    choice,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                if (showResult && isCorrectChoice)
                  const Icon(Icons.check_circle, color: Colors.green)
                else if (showResult && isSelected && !isCorrectChoice)
                  const Icon(Icons.cancel, color: Colors.red),
              ],
            ),
          ),
        ),
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