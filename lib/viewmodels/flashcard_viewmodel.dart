import 'package:flashcard_app/models/deck_model.dart';
import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:flashcard_app/services/flashcard_db.dart';
import 'package:flutter/material.dart';

class FlashcardViewModel extends ChangeNotifier {
  late DeckModel _openDeck;
  List<FlashcardModel> _flashcards = [];

  List<FlashcardModel> get flashcards => _flashcards;

  void setOpenDeck(DeckModel deck) {
    _openDeck = deck;
    notifyListeners();
  }

  void fetchDeckFlashcards(String deckID) async {
    _flashcards = await FlashcardDb.getDeckFlashcards(deckID);
    notifyListeners();
  }

  String get getDeckTitle => _openDeck.title;

  void nextFlashcard(int index) {}
  void prevFlashcard(int index) {}

  int deckLength() => flashcards.length;
}
