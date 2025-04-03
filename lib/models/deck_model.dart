import 'package:flashcard_app/models/flashcard_model.dart';

class DeckModel {
  final String owner;
  final String title;
  final List<FlashcardModel> cards;
  final bool isPublic;

  DeckModel({ required this.owner, required this.title, required this.cards, required this.isPublic });
}