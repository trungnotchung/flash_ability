import 'package:flash_ability/services/management/flashcard/flashcard.dart';
import 'package:flash_ability/services/user_service.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditFlashcardScreen extends StatefulWidget {
  final String groupName;
  final String word;

  const EditFlashcardScreen({
    super.key,
    required this.groupName,
    required this.word,
  });

  @override
  State<EditFlashcardScreen> createState() => _EditFlashcardScreenState();
}

class _EditFlashcardScreenState extends State<EditFlashcardScreen> {
  late Map<String, String> flashcardData;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _wordController;
  late TextEditingController _descriptionController;
  late TextEditingController _brailleController;
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

    // Initialize controllers with empty values first
    _wordController = TextEditingController();
    _descriptionController = TextEditingController();
    _brailleController = TextEditingController();

    // Initialize flashcardData as empty map
    flashcardData = {};

    // Load data and update controllers afterwards
    _loadFlashcardData();
  }

  void _loadFlashcardData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading flashcard data
    await Future.delayed(const Duration(seconds: 1));
    flashcardData = await FlashcardOperation.getFlashcardData(widget.word);

    // Update controllers with loaded data
    _wordController.text = flashcardData['word'] ?? '';
    _descriptionController.text = flashcardData['description'] ?? '';
    _brailleController.text = flashcardData['braille'] ?? '';

    // Set image and video paths from existing data
    _imagePath = flashcardData['image'] ?? '';
    _videoPath = flashcardData['video'] ?? '';

    // Only create File objects if the paths point to local files
    if (_imagePath != null &&
        _imagePath!.isNotEmpty &&
        File(_imagePath!).existsSync()) {
      _selectedImage = File(_imagePath!);
    }

    if (_videoPath != null &&
        _videoPath!.isNotEmpty &&
        File(_videoPath!).existsSync()) {
      _selectedVideo = File(_videoPath!);
    }

    setState(() {
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

  Future<void> _saveFlashcard() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Create updated data map
        final updatedData = {
          'word': _wordController.text,
          'description': _descriptionController.text,
          'braille': _brailleController.text,
          'image': _imagePath ?? '',
          'video': _videoPath ?? '',
        };

        // Call the editFlashcard method
        await FlashcardOperation.editFlashcard(widget.word, updatedData);

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Flashcard updated successfully'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          Navigator.of(context).pop(true); // Return true to indicate success
        }
      } catch (e) {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating flashcard: ${e.toString()}'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
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
            const Icon(Icons.edit_note, size: 28),
            const SizedBox(width: 8),
            Text(
              'Edit Flashcard',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: _isLoading ? null : _saveFlashcard,
          ),
        ],
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
                      '${widget.groupName} Flashcard',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Edit your flashcard details below',
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
                            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                maxLines: 3,
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter braille representation';
                                  }
                                  return null;
                                },
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
                                                      : _imagePath != null &&
                                                          _imagePath!.isNotEmpty
                                                      ? 'Current image: ${_imagePath!.split('/').last}'
                                                      : 'No image selected',
                                                  style: TextStyle(
                                                    color:
                                                        _selectedImage !=
                                                                    null ||
                                                                (_imagePath !=
                                                                        null &&
                                                                    _imagePath!
                                                                        .isNotEmpty)
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
                                                _selectedVideo != null ||
                                                        (_videoPath != null &&
                                                            _videoPath!
                                                                .isNotEmpty)
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
                                                  : _videoPath != null &&
                                                      _videoPath!.isNotEmpty
                                                  ? 'Current video: ${_videoPath!.split('/').last}'
                                                  : 'No video selected',
                                              style: TextStyle(
                                                color:
                                                    _selectedVideo != null ||
                                                            (_videoPath !=
                                                                    null &&
                                                                _videoPath!
                                                                    .isNotEmpty)
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveFlashcard,
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
                            const Icon(Icons.save, color: Colors.white),
                            const SizedBox(width: 8),
                            const Text(
                              'Save Changes',
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
