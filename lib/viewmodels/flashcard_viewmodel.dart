import 'package:flashcard_app/models/deck_model.dart';
import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:flashcard_app/services/flashcard_db.dart';
import 'package:flutter/material.dart';

class FlashcardViewModel extends ChangeNotifier {
  List<FlashcardModel> _fetchedFlashcards = [];
  List<FlashcardModel> get flashcards => _fetchedFlashcards;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  Future<void> fetchDeckFlashcards(String deckID) async {
    _fetchedFlashcards = await FlashcardDb.getDeckFlashcards(deckID);
    notifyListeners();
  }

  String getDeckTitle(DeckModel deck) => deck.title;
  int get deckLength => flashcards.length;

  void nextFlashcard(int index) {}
  void prevFlashcard(int index) {}
}
