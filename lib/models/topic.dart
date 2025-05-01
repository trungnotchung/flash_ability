class Topic {
  final String id;
  final String name;
  final String imageUrl;
  final int? vocabularyCount;

  Topic({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.vocabularyCount,
  });
}
