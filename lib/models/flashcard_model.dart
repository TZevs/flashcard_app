class FlashcardModel {
  final int? id;
  final String deckId;
  final dynamic cardFront;
  final dynamic cardBack;

  FlashcardModel(
      {this.id,
      required this.deckId,
      required this.cardFront,
      required this.cardBack});

  // Converts Flashcard object to a map for sqflite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'deckId': deckId,
      'cardFront': cardFront,
      'cardBack': cardBack,
    };
  }

  // Converts map to a Flashcard object
  factory FlashcardModel.fromMap(Map<String, dynamic> card) {
    return FlashcardModel(
        id: card['id'],
        deckId: card['deckId'],
        cardFront: card['cardFront'],
        cardBack: card['cardBack']);
  }
}
