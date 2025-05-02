class Vocabulary {
  final String id;
  final String word;
  final String meaning;
  final String? exampleSentence;
  final String imageUrl;
  final String? audioUrl;
  final String? braille;

  Vocabulary({
    required this.id,
    required this.word,
    required this.meaning,
    this.exampleSentence,
    required this.imageUrl,
    this.audioUrl,
    this.braille,
  });

  // Factory constructor to create a Vocabulary from flashcard data
  factory Vocabulary.fromFlashcard(Map<String, String> flashcard, int index) {
    return Vocabulary(
      id: index.toString(),
      word: flashcard['word'] ?? '',
      meaning: flashcard['description'] ?? '',
      imageUrl: 'assets/images/${flashcard['image']}',
      braille: flashcard['braille'],
    );
  }
}
