import 'package:flash_ability/services/learning/topic/all_topic.dart';
import 'package:flash_ability/services/learning/topic/topic.dart';
import 'package:flash_ability/services/management/flashcard/flashcard.dart';
import 'package:flash_ability/services/user_service.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddFlashcardScreen extends StatefulWidget {
  final String groupName;

  const AddFlashcardScreen({super.key, required this.groupName});

  @override
  State<AddFlashcardScreen> createState() => _AddFlashcardScreenState();
}

class _AddFlashcardScreenState extends State<AddFlashcardScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _brailleController = TextEditingController();
  String _selectedTopic = '';

  List<String> _topics = [];
  bool _isLoading = false;

  // File handling variables
  File? _selectedImage;
  File? _selectedVideo;
  String? _imagePath;
  String? _videoPath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    setState(() {
      _isLoading = true;
    });

    final topics = await AllTopicsOperation.getAllTopics();

    setState(() {
      _topics = topics;
      _isLoading = false;
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedImage != null) {
        setState(() {
          _imagePath = pickedImage.path;
          _selectedImage = File(_imagePath!);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickVideo() async {
    try {
      final XFile? pickedVideo = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 1),
      );

      if (pickedVideo != null) {
        setState(() {
          _videoPath = pickedVideo.path;
          _selectedVideo = File(_videoPath!);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking video: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _wordController.dispose();
    _descriptionController.dispose();
    _brailleController.dispose();
    super.dispose();
  }

  void _createFlashcard() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Create flashcard model
      final flashcard = Map<String, String>.from({
        'word': _wordController.text,
        'description': _descriptionController.text,
        'braille': _brailleController.text,
        'imageUrl': _imagePath ?? '',
        'videoUrl': _videoPath ?? '',
      });

      // Here you would typically save the flashcard to your storage
      FlashcardOperation.addFlashcard(
        flashcard['word']!,
        flashcard['videoUrl']!,
        flashcard['imageUrl']!,
        flashcard['braille']!,
        flashcard['description']!,
      );

      FlashcardOperation.addFlashcardToGroup(widget.groupName, flashcard);

      // Add flashcard to the selected topic
      if (_selectedTopic.isNotEmpty) {
        TopicOperation.addFlashcardToTopic(_selectedTopic, flashcard);
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Flashcard created successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get username for personalized greeting
    final username = UserService.getCurrentUser()['name'] ?? 'User';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: BackButton(color: Theme.of(context).colorScheme.onSurface),
        title: Row(
          children: [
            const Icon(Icons.add_card, size: 28),
            const SizedBox(width: 8),
            const Text(
              'Add Flashcard',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header section
                    Text(
                      'Hello, $username!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create a new flashcard for ${widget.groupName}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Form section
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Word Field
                              TextFormField(
                                controller: _wordController,
                                decoration: InputDecoration(
                                  labelText: 'Word',
                                  prefixIcon: Icon(
                                    Icons.text_fields,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a word';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Description Field
                              TextFormField(
                                controller: _descriptionController,
                                maxLines: 3,
                                maxLength: 200,
                                decoration: InputDecoration(
                                  labelText: 'Description',
                                  prefixIcon: Icon(
                                    Icons.description,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a description';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Braille Field
                              TextFormField(
                                controller: _brailleController,
                                decoration: InputDecoration(
                                  labelText: 'Braille',
                                  prefixIcon: Icon(
                                    Icons.translate,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Image File Picker
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Image',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade400,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        if (_selectedImage != null) ...[
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                  top: Radius.circular(12),
                                                ),
                                            child: Image.file(
                                              _selectedImage!,
                                              height: 150,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                        ],
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  _selectedImage != null
                                                      ? _imagePath!
                                                          .split('/')
                                                          .last
                                                      : 'No image selected',
                                                  style: TextStyle(
                                                    color:
                                                        _selectedImage != null
                                                            ? Colors.black
                                                            : Colors.grey,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              ElevatedButton.icon(
                                                onPressed: _pickImage,
                                                icon: const Icon(Icons.image),
                                                label: const Text('Browse'),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.primary,
                                                  foregroundColor: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Video File Picker
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Video',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade400,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.video_file,
                                            color:
                                                _selectedVideo != null
                                                    ? Theme.of(
                                                      context,
                                                    ).colorScheme.primary
                                                    : Colors.grey,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              _selectedVideo != null
                                                  ? _videoPath!.split('/').last
                                                  : 'No video selected',
                                              style: TextStyle(
                                                color:
                                                    _selectedVideo != null
                                                        ? Colors.black
                                                        : Colors.grey,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton.icon(
                                            onPressed: _pickVideo,
                                            icon: const Icon(Icons.videocam),
                                            label: const Text('Browse'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                              foregroundColor: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Topic Dropdown
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Topic',
                                  prefixIcon: Icon(
                                    Icons.category,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                isExpanded: true,
                                items:
                                    _topics.map((String topic) {
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Create Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _createFlashcard,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.add, color: Colors.white),
                            const SizedBox(width: 8),
                            const Text(
                              'Create Flashcard',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
