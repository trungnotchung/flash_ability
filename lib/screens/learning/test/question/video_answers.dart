import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class VideoAnswers extends StatefulWidget {
  final String videoUrl;
  final List<String> answers;
  final String correctAnswer;

  const VideoAnswers({
    super.key,
    this.videoUrl = '',
    this.answers = const [],
    this.correctAnswer = '', required Null Function(bool isCorrect) onAnswerSelected,
  });

  @override
  State<VideoAnswers> createState() => _VideoAnswersState();
}

class _VideoAnswersState extends State<VideoAnswers> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isLoading = true;
  bool _showControls = true;
  bool? _isAnswerCorrect;
  Timer? _hideTimer;
  int? _selectedAnswerIndex;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    setState(() {
      _isLoading = true;
    });

    // Ensure the URL uses HTTPS or handle both types
    String secureUrl = widget.videoUrl;
    if (secureUrl.startsWith('http:')) {
      secureUrl = secureUrl.replaceFirst('http:', 'https:');
    }

    _controller = VideoPlayerController.networkUrl(Uri.parse(secureUrl))
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
          _isLoading = false;
        });
      }).catchError((error) {
        debugPrint('Video initialization error: $error');
        setState(() {
          _isInitialized = false;
          _isLoading = false;
        });
      });
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showControls = false);
      }
    });
  }

  void _onTapVideo() {
    setState(() => _showControls = true);
    _startHideTimer();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
    _startHideTimer();
  }

  void _checkAnswer(String answer, int index) {
    setState(() {
      _selectedAnswerIndex = index;
      _isAnswerCorrect = answer.toLowerCase() == widget.correctAnswer.toLowerCase();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVideoSection(colorScheme),
          const SizedBox(height: 32),
          _buildAnswerSection(colorScheme),
        ],
      ),
    );
  }

  Widget _buildVideoSection(ColorScheme colorScheme) {
    if (_isLoading) {
      return Container(
        height: 220,
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              'Loading video...',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (!_isInitialized) {
      return Container(
        height: 220,
        decoration: BoxDecoration(
          color: colorScheme.errorContainer.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: colorScheme.error),
            const SizedBox(height: 12),
            Text(
              'Failed to load video',
              style: TextStyle(
                color: colorScheme.onErrorContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton.icon(
              onPressed: _initializeVideo,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: GestureDetector(
            onTap: _onTapVideo,
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(_controller),
                if (_showControls)
                  AnimatedOpacity(
                    opacity: _showControls ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.0),
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          size: 64,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        onPressed: _togglePlayPause,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerSection(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Choose the correct answer',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 24),
        ...widget.answers.asMap().entries.map((entry) {
          final int index = entry.key;
          final String answer = entry.value;
          final bool isSelected = _selectedAnswerIndex == index;

          // Determine colors based on selection and correctness
          Color borderColor = colorScheme.outline;
          Color backgroundColor = colorScheme.surface;

          if (isSelected) {
            if (_isAnswerCorrect != null) {
              borderColor = _isAnswerCorrect! ? colorScheme.primary : colorScheme.error;
              backgroundColor = _isAnswerCorrect!
                  ? colorScheme.primaryContainer.withOpacity(0.3)
                  : colorScheme.errorContainer.withOpacity(0.3);
            } else {
              borderColor = colorScheme.primary;
              backgroundColor = colorScheme.primaryContainer.withOpacity(0.1);
            }
          }

          return Padding(
            padding: EdgeInsets.only(bottom: index < widget.answers.length - 1 ? 16.0 : 0),
            child: InkWell(
              onTap: () => _checkAnswer(answer, index),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                  color: backgroundColor,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        answer,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (isSelected && _isAnswerCorrect != null)
                      Icon(
                        _isAnswerCorrect! ? Icons.check_circle : Icons.cancel,
                        color: _isAnswerCorrect! ? colorScheme.primary : colorScheme.error,
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),

        if (_isAnswerCorrect != null)
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: _isAnswerCorrect!
                    ? colorScheme.primaryContainer
                    : colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _isAnswerCorrect!
                    ? 'Correct! Well done!'
                    : 'Not quite right. Try again!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _isAnswerCorrect!
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onErrorContainer,
                ),
              ),
            ),
          ),
      ],
    );
  }
}