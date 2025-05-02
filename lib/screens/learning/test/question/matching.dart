import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MatchingQuestion {
  final String question;
  final List<String> videoUrls;
  final List<String> words;
  final List<String> correctMatches;

  const MatchingQuestion({
    required this.question,
    required this.videoUrls,
    required this.words,
    required this.correctMatches,
  });
}

class MatchingQuestionPage extends StatefulWidget {
  const MatchingQuestionPage({super.key});

  @override
  State<MatchingQuestionPage> createState() => _MatchingQuestionPageState();
}

class _MatchingQuestionPageState extends State<MatchingQuestionPage> {
  final MatchingQuestion _question = const MatchingQuestion(
    question: 'Match the video with the correct word.',
    videoUrls: [
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    ],
    words: ['Lion', 'Elephant', 'Leopard'],
    correctMatches: ['Lion', 'Elephant', 'Leopard'],
  );

  // Maps to store the current matches
  Map<int, int?> leftToRightConnections = {};
  Map<int, int?> rightToLeftConnections = {};

  // Store the video controllers
  late List<VideoPlayerController> _videoControllers;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoControllers();
  }

  void _initializeVideoControllers() async {
    _videoControllers = _question.videoUrls.map((url) {
      final controller = VideoPlayerController.networkUrl(Uri.parse(url));
      return controller;
    }).toList();

    // Initialize all controllers
    for (var controller in _videoControllers) {
      await controller.initialize();
      controller.setLooping(true);
    }

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Handle connecting/disconnecting matching items
  void _toggleConnection(int leftIndex, int rightIndex) {
    setState(() {
      // If already connected, disconnect them
      if (leftToRightConnections[leftIndex] == rightIndex) {
        leftToRightConnections.remove(leftIndex);
        rightToLeftConnections.remove(rightIndex);
      } else {
        // Remove any existing connections for either item
        if (leftToRightConnections.containsKey(leftIndex)) {
          rightToLeftConnections.remove(leftToRightConnections[leftIndex]);
        }
        if (rightToLeftConnections.containsKey(rightIndex)) {
          leftToRightConnections.remove(rightToLeftConnections[rightIndex]);
        }

        // Create new connection
        leftToRightConnections[leftIndex] = rightIndex;
        rightToLeftConnections[rightIndex] = leftIndex;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
          ? Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _question.question,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: MatchingQuestionWidget(
                      leftItems: _videoControllers,
                      rightItems: _question.words,
                      leftToRightConnections: leftToRightConnections,
                      onToggleConnection: _toggleConnection,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      )
          : const Center(child: CircularProgressIndicator());
  }
}

class MatchingQuestionWidget extends StatelessWidget {
  final List<VideoPlayerController> leftItems;
  final List<String> rightItems;
  final Map<int, int?> leftToRightConnections;
  final Function(int, int) onToggleConnection;

  const MatchingQuestionWidget({
    super.key,
    required this.leftItems,
    required this.rightItems,
    required this.leftToRightConnections,
    required this.onToggleConnection,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ConnectionsPainter(leftToRightConnections),
      child: Row(
        children: [
          // Left column (videos)
          Expanded(
            child: ListView.separated(
              itemCount: leftItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return VideoItemWidget(
                  controller: leftItems[index],
                  index: index,
                  isLeft: true,
                  onTap: (idx) {
                    // Show bottom sheet to select which right item to connect to
                    _showSelectionBottomSheet(context, idx);
                  },
                );
              },
            ),
          ),
          // Middle space for lines
          const SizedBox(width: 20),
          // Right column (words)
          Expanded(
            child: ListView.separated(
              itemCount: rightItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return WordItemWidget(
                  word: rightItems[index],
                  index: index,
                  isLeft: false,
                  onTap: (idx) {
                    // Show bottom sheet to select which left item to connect to
                    _showSelectionBottomSheet(context, idx, isLeftSelection: false);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showSelectionBottomSheet(BuildContext context, int selectedIndex, {bool isLeftSelection = true}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: isLeftSelection ? rightItems.length : leftItems.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(isLeftSelection ? rightItems[index] : 'Video ${index + 1}'),
              onTap: () {
                Navigator.pop(context);
                if (isLeftSelection) {
                  onToggleConnection(selectedIndex, index);
                } else {
                  onToggleConnection(index, selectedIndex);
                }
              },
            );
          },
        );
      },
    );
  }
}

class VideoItemWidget extends StatelessWidget {
  final VideoPlayerController controller;
  final int index;
  final bool isLeft;
  final Function(int) onTap;

  const VideoItemWidget({
    super.key,
    required this.controller,
    required this.index,
    required this.isLeft,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              // Video player
              AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
              // Play/pause button overlay
              Center(
                child: IconButton(
                  icon: Icon(
                    controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    if (controller.value.isPlaying) {
                      controller.pause();
                    } else {
                      controller.play();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WordItemWidget extends StatelessWidget {
  final String word;
  final int index;
  final bool isLeft;
  final Function(int) onTap;

  const WordItemWidget({
    super.key,
    required this.word,
    required this.index,
    required this.isLeft,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            word,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class ConnectionsPainter extends CustomPainter {
  final Map<int, int?> connections;

  ConnectionsPainter(this.connections);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Get the actual heights for items
    final itemHeight = 80.0;  // matching the height in item widgets
    final itemSpacing = 12.0; // from the separatorBuilder

    connections.forEach((leftIndex, rightIndex) {
      if (rightIndex != null) {
        // Calculate Y positions based on indices and actual spacing/sizing
        final leftY = leftIndex * (itemHeight + itemSpacing) + itemHeight / 2;
        final rightY = rightIndex * (itemHeight + itemSpacing) + itemHeight / 2;

        // Calculate X positions for the start and end of connections
        final leftX = size.width * 0.25; // Left column (25% of total width)
        final rightX = size.width * 0.75; // Right column (75% of total width)

        // Draw a line between the two points
        canvas.drawLine(
          Offset(leftX, leftY),
          Offset(rightX, rightY),
          paint,
        );
      }
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}