import 'package:flutter/material.dart';
import 'package:flash_ability/mock_data/flashcards.dart';
import 'package:flutter/services.dart';
import 'flashcard.dart';

class FlashcardScreen extends StatefulWidget {
  final List<String> words;
  final int index;

  const FlashcardScreen({super.key, required this.words, required this.index});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> with SingleTickerProviderStateMixin {
  // Flashcard data
  late List<Map<String, String>> flashcardData = [];
  late int currentIndex;
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut)
    );

    // Populate flashcard data
    for (var word in widget.words) {
      var flashcard = flashcards.firstWhere(
        (flashcard) => flashcard['word'] == word,
        orElse: () => {}
      );
      if (flashcard.isNotEmpty) {
        flashcardData.add(flashcard);
      }
    }

    // Set the current index to the selected word
    currentIndex = widget.index;

    // Initialize page controller
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _animateToPage(int page) {
    _animationController.forward(from: 0.0);
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void moveToNextCard() {
    final nextIndex = (currentIndex + 1) % flashcardData.length;
    setState(() {
      currentIndex = nextIndex;
    });
    _animateToPage(nextIndex);
  }

  void moveToPreviousCard() {
    final prevIndex = (currentIndex - 1 + flashcardData.length) % flashcardData.length;
    setState(() {
      currentIndex = prevIndex;
    });
    _animateToPage(prevIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Flashcards',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => _buildInfoSheet(),
              );
            },
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  '${currentIndex + 1} / ${flashcardData.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    itemCount: flashcardData.length,
                    itemBuilder: (context, index) {
                      return FadeTransition(
                        opacity: _animation,
                        child: FlashCard(data: flashcardData[index]),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavButton(
                      icon: Icons.arrow_back_rounded,
                      label: 'Previous',
                      onPressed: moveToPreviousCard,
                    ),
                    _buildNavButton(
                      icon: Icons.arrow_forward_rounded,
                      label: 'Next',
                      onPressed: moveToNextCard,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 3,
      ),
    );
  }

  Widget _buildInfoSheet() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'How to Use Flashcards',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.touch_app, color: Colors.blue),
            title: const Text('Tap on card to flip'),
            subtitle: const Text('View the description on the back side'),
          ),
          ListTile(
            leading: const Icon(Icons.swipe, color: Colors.blue),
            title: const Text('Swipe left or right'),
            subtitle: const Text('Navigate between flashcards'),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it!'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}