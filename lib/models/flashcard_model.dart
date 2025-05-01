import 'package:cloud_firestore/cloud_firestore.dart';

class FlashcardModel {
  final int? id;
  final String deckId;
  String? cardFront;
  String? cardBack;
  String? frontImgPath;
  String? backImgPath;
  String? frontImgUrl;
  String? backImgUrl;

  FlashcardModel(
      {this.id,
      required this.deckId,
      this.cardFront,
      this.cardBack,
      this.frontImgPath,
      this.backImgPath,
      this.frontImgUrl,
      this.backImgUrl});

  // Converts Flashcard object to a map for databases
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'deckId': deckId,
      'cardFront': cardFront,
      'cardBack': cardBack,
      'frontImgPath': frontImgPath,
      'backImgPath': backImgPath,
    };
  }

  // Converts map to a Flashcard object for SQFlite
  factory FlashcardModel.fromMap(Map<String, dynamic> card) {
    return FlashcardModel(
        id: card['id'],
        deckId: card['deckId'],
        cardFront: card['cardFront'],
        cardBack: card['cardBack'],
        frontImgPath: card['frontImgPath'],
        backImgPath: card['backImgPath']);
  }

  // Converting Firestore document snapshot to a FlashcardModel
  factory FlashcardModel.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> cardSnapshot) {
    final data = cardSnapshot.data();
    return FlashcardModel(
      id: data['id'],
      deckId: data['deckId'],
      cardFront: data['cardFront'],
      cardBack: data['cardBack'],
      frontImgPath: data['frontImgPath'],
      backImgPath: data['backImgPath'],
    );
  }
}
