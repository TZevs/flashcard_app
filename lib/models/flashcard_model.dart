class FlashcardModel {
  final int? id;
  final int deckId;
  final String cardFront;
  final String cardBack;

  FlashcardModel({ this.id, required this.deckId, required this.cardFront, required this.cardBack });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'deckId': deckId,
      'cardFront': cardFront,
      'cardBack': cardBack,
    };
  }
}