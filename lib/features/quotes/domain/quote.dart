class Quote {
  final String id;
  final String text;
  final String author;
  final String? category;
  final bool isFavorite;

  const Quote({
    required this.id,
    required this.text,
    required this.author,
    this.category,
    this.isFavorite = false,
  });

  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      author: map['author'] ?? '',
      category: map['category'],
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'author': author,
      'category': category,
      'isFavorite': isFavorite,
    };
  }

  Quote copyWith({
    String? id,
    String? text,
    String? author,
    String? category,
    bool? isFavorite,
  }) {
    return Quote(
      id: id ?? this.id,
      text: text ?? this.text,
      author: author ?? this.author,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
