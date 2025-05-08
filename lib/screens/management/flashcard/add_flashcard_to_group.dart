import 'package:flutter/material.dart';

class AddFlashcardScreen extends StatefulWidget {
  final String groupName;

  const AddFlashcardScreen({
    super.key,
    required this.groupName,
  });

  @override
  State<AddFlashcardScreen> createState() => _AddFlashcardScreenState();
}

class _AddFlashcardScreenState extends State<AddFlashcardScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _brailleController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _videoUrlController = TextEditingController();
  String _selectedTopic = '';

  final List<String> _topics = [
    'Business', 'Technology', 'Science', 'Languages',
    'Arts', 'History', 'Mathematics', 'Literature'
  ];

  @override
  void dispose() {
    _wordController.dispose();
    _descriptionController.dispose();
    _brailleController.dispose();
    _imageUrlController.dispose();
    _videoUrlController.dispose();
    super.dispose();
  }

  void _createFlashcard() {
    if (_formKey.currentState!.validate()) {
      // Create flashcard model
      final flashcard = FlashcardModel(
        word: _wordController.text,
        description: _descriptionController.text,
        braille: _brailleController.text,
        imageUrl: _imageUrlController.text,
        videoUrl: _videoUrlController.text,
        topic: _selectedTopic,
      );

      // Here you would typically save the flashcard to your storage
      // For example: DatabaseService().addFlashcardToGroup(widget.groupName, flashcard);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Flashcard created successfully')),
      );

      // Navigate back
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Create new flashcard',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'word',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _wordController,
                  decoration: InputDecoration(
                    hintText: 'enter word',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a word';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                const Text(
                  'description',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  maxLength: 200,
                  decoration: InputDecoration(
                    hintText: 'enter word description (max 200 words)',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                const Text(
                  'braille',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _brailleController,
                  decoration: InputDecoration(
                    hintText: 'enter braille representation',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    suffixIcon: const Icon(Icons.arrow_upward),
                  ),
                ),

                const SizedBox(height: 16),
                const Text(
                  'image',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: InputDecoration(
                    hintText: 'enter image URL (.png, .jpg, .jpeg)',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    suffixIcon: const Icon(Icons.arrow_upward),
                  ),
                ),

                const SizedBox(height: 16),
                const Text(
                  'video',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _videoUrlController,
                  decoration: InputDecoration(
                    hintText: 'enter video URL (.mp4)',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    suffixIcon: const Icon(Icons.arrow_upward),
                  ),
                ),

                const SizedBox(height: 16),
                const Text(
                  'topic',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintText: 'choose a topic',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  isExpanded: true,
                  items: _topics.map((String topic) {
                    return DropdownMenuItem<String>(
                      value: topic,
                      child: Text(topic),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedTopic = newValue;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a topic';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: _createFlashcard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.black, width: 1),
                      ),
                      minimumSize: const Size(200, 48),
                    ),
                    child: const Text(
                      'Create',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
}

// Model for flashcard data
class FlashcardModel {
  final String word;
  final String description;
  final String braille;
  final String imageUrl;
  final String videoUrl;
  final String topic;

  FlashcardModel({
    required this.word,
    required this.description,
    this.braille = '',
    this.imageUrl = '',
    this.videoUrl = '',
    required this.topic,
  });

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'description': description,
      'braille': braille,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'topic': topic,
    };
  }

  // Create from Map for retrieval
  factory FlashcardModel.fromMap(Map<String, dynamic> map) {
    return FlashcardModel(
      word: map['word'] ?? '',
      description: map['description'] ?? '',
      braille: map['braille'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
      topic: map['topic'] ?? '',
    );
  }
}

// Example of how to use this screen
// In your WordListScreen or somewhere else:
void navigateToAddFlashcard(BuildContext context, String groupName) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AddFlashcardScreen(groupName: groupName),
    ),
  );
}

// You may call this function when the FAB is pressed in your WordListScreen:
// FloatingActionButton(
//   onPressed: () => navigateToAddFlashcard(context, widget.groupName),
//   backgroundColor: Colors.blue,
//   child: const Icon(Icons.add, color: Colors.white),
// ),