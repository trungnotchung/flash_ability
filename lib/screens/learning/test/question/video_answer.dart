import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class VideoAnswer extends StatefulWidget {
  final String videoUrl;
  final String answer;

  const VideoAnswer({super.key, this.videoUrl = '', this.answer = ''});

  @override
  State<VideoAnswer> createState() => _VideoAnswerState();
}

class _VideoAnswerState extends State<VideoAnswer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _showControls = true;
  bool? _isAnswerCorrect;
  Timer? _hideTimer;
  final TextEditingController _answerController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    setState(() => _isLoading = true);

    // Ensure the URL uses HTTPS
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

  void _checkAnswer() {
    final userAnswer = _answerController.text.trim();
    final correctAnswer = widget.answer.trim();

    setState(() {
      _isAnswerCorrect = userAnswer.toLowerCase() == correctAnswer.toLowerCase();
    });

    // Hide keyboard
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _hideTimer?.cancel();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVideoSection(colorScheme),
          const SizedBox(height: 24),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Answer',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isAnswerCorrect == null
                  ? colorScheme.outline
                  : _isAnswerCorrect!
                      ? colorScheme.primary
                      : colorScheme.error,
              width: 1.5,
            ),
            color: (_isAnswerCorrect == null)
                ? colorScheme.surface
                : _isAnswerCorrect!
                    ? colorScheme.primaryContainer.withOpacity(0.3)
                    : colorScheme.errorContainer.withOpacity(0.3),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _answerController,
                    onSubmitted: (_) => _checkAnswer(),
                    decoration: InputDecoration(
                      hintText: 'Type your answer here',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _checkAnswer,
                  icon: Icon(
                    Icons.send_rounded,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isAnswerCorrect != null)
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: [
                Icon(
                  _isAnswerCorrect! ? Icons.check_circle : Icons.cancel,
                  color: _isAnswerCorrect! ? Colors.green : Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _isAnswerCorrect! ? 'Correct answer!' : 'Try again!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _isAnswerCorrect! ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        if (_isAnswerCorrect == false)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Hint: It has ${widget.answer.length} characters',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }
}