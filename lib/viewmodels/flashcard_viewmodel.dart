import 'package:flashcard_app/models/deck_model.dart';
import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:flashcard_app/services/flashcard_db.dart';
import 'package:flutter/material.dart';

class FlashcardViewModel extends ChangeNotifier {
  List<FlashcardModel> _flashcards = [];
  List<FlashcardModel> get flashcards => _flashcards;

  Future<void> fetchDeckFlashcards(String deckID) async {
    _flashcards = await FlashcardDb.getDeckFlashcards(deckID);
    notifyListeners();
  }

  String getDeckTitle(DeckModel deck) => deck.title;
  int get deckLength => flashcards.length;

  void nextFlashcard(int index) {}
  void prevFlashcard(int index) {}
}
