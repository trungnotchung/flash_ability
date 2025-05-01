class Vocabulary {
  final String id;
  final String word;
  final String meaning;
  final String exampleSentence;
  final String imageUrl;
  final String? audioUrl;

  Vocabulary({
    required this.id,
    required this.word,
    required this.meaning,
    required this.exampleSentence,
    required this.imageUrl,
    this.audioUrl,
  });
}
