import 'package:flash_ability/services/management/flashcard/flashcard.dart';
import 'package:flutter/material.dart';

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
  late TextEditingController _imageUrlController;
  late TextEditingController _videoUrlController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with empty values first
    _wordController = TextEditingController();
    _descriptionController = TextEditingController();
    _brailleController = TextEditingController();
    _imageUrlController = TextEditingController();
    _videoUrlController = TextEditingController();

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
    _imageUrlController.text = flashcardData['image'] ?? '';
    _videoUrlController.text = flashcardData['video'] ?? '';

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _wordController.dispose();
    _descriptionController.dispose();
    _brailleController.dispose();
    _imageUrlController.dispose();
    _videoUrlController.dispose();
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
          'image': _imageUrlController.text,
          'video': _videoUrlController.text,
        };

        // Call the editFlashcard method
        await FlashcardOperation.editFlashcard(widget.word, updatedData);

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Flashcard updated successfully')),
          );
          Navigator.of(context).pop(true); // Return true to indicate success
        }
      } catch (e) {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating flashcard: ${e.toString()}'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Flashcard in ${widget.groupName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveFlashcard,
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Word Field
                      TextFormField(
                        controller: _wordController,
                        decoration: const InputDecoration(
                          labelText: 'Word',
                          border: OutlineInputBorder(),
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
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
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
                        decoration: const InputDecoration(
                          labelText: 'Braille',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter braille representation';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Image URL Field
                      TextFormField(
                        controller: _imageUrlController,
                        decoration: const InputDecoration(
                          labelText: 'Image URL',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an image URL';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Video URL Field
                      TextFormField(
                        controller: _videoUrlController,
                        decoration: const InputDecoration(
                          labelText: 'Video URL (Optional)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Save Button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _saveFlashcard,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Save Changes'),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
