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
    this.correctAnswer = '',
  });

  @override
  State<VideoAnswers> createState() => _VideoAnswersState();
}


// ...

class _VideoAnswersState extends State<VideoAnswers> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _showControls = true;
  bool? _isAnswerCorrect;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    // Ensure the URL uses HTTPS or handle both types
    String secureUrl = widget.videoUrl;
    if (secureUrl.startsWith('http:')) {
      secureUrl = secureUrl.replaceFirst('http:', 'https:');
    }

    _controller = VideoPlayerController.networkUrl(Uri.parse(secureUrl))
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
      }).catchError((error) {
        print('Video initialization error: $error');
        setState(() {
          _isInitialized = false;
        });
      });
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _showControls = false;
      });
    });
  }

  void _onTapVideo() {
    setState(() {
      _showControls = true;
    });
    _startHideTimer();
  }

  @override
  void dispose() {
    _controller.dispose();
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _isInitialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: GestureDetector(
              onTap: _onTapVideo,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  VideoPlayer(_controller),
                  if (_showControls)
                    IconButton(
                      icon: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 40,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                          } else {
                            _controller.play();
                          }
                        });
                        _startHideTimer(); // reset timer khi nhấn nút
                      },
                    ),
                ],
              ),
            ),
          )
              : Container(
            height: 200,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          ),
          const SizedBox(height: 40),
          Center(
            child: const Text(
              'Answer',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 40),
          Container(
            // decoration: BoxDecoration(
            //   border: Border.all(color: Colors.black, width: 1),
            //   borderRadius: BorderRadius.circular(12),
            // ),

            child: Column(
              children: widget.answers.asMap().entries.map((entry) {
                final int index = entry.key;
                final String answer = entry.value;

                return Padding(
                  padding: EdgeInsets.only(bottom: index < widget.answers.length - 1 ? 30.0 : 0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isAnswerCorrect = answer == 'father'; // Example condition
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      alignment: Alignment.centerLeft,
                      child: Center(
                        child: Text(
                          answer,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

          ),

          const SizedBox(height: 30), // 👈 Feedback spacing
          if (_isAnswerCorrect != null)
            Center(
              child: Text(
                _isAnswerCorrect! ? 'Correct Answer!' : 'Incorrect Answer!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _isAnswerCorrect! ? Colors.green : Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
