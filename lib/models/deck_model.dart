import 'package:flashcard_app/models/flashcard_model.dart';

class DeckModel {
  final int id;
  final String title;
  final List<FlashcardModel>? flashcards;
  final bool isPublic;

  DeckModel({ required this.id, required this.title, this.flashcards, required this.isPublic });
}