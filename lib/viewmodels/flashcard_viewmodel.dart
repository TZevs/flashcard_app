import 'package:flashcard_app/models/deck_model.dart';
import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:flashcard_app/services/flashcard_db.dart';
import 'package:flutter/material.dart';

class FlashcardViewModel extends ChangeNotifier {
  List<FlashcardModel> _fetchedFlashcards = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  Future<void> fetchDeckFlashcards(String deckID) async {
    _isLoading = true;
    notifyListeners();

    _fetchedFlashcards = await FlashcardDb.getDeckFlashcards(deckID);

    _isLoading = false;
    notifyListeners();
  }

  List<FlashcardModel> get flashcards => _fetchedFlashcards;

  String getDeckTitle(DeckModel deck) => deck.title;
  int get deckLength => flashcards.length;

  void nextFlashcard(int index) {}
  void prevFlashcard(int index) {}
}
