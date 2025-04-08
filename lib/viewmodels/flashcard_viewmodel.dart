import 'package:flashcard_app/models/deck_model.dart';
import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:flashcard_app/services/flashcard_db.dart';
import 'package:flutter/material.dart';

class FlashcardViewModel extends ChangeNotifier {
  List<DeckModel> _decks = [];
  List<FlashcardModel> _flashcards = [];

  // Gets the current deck and flashcard lists
  List<DeckModel> get currentDecks => _decks;
  List<FlashcardModel> get currentCards => _flashcards;
  // Possible add a loading bool and an error message string

  // Gets the Decks from the DB
  void fetchDecks() async {
    // Add try and catch
    _decks = await FlashcardDb.getDecks();
    notifyListeners();
  }

  void fetchDeckFlashcards(String deckID) async {
    _flashcards = await FlashcardDb.getDeckFlashcards(deckID);
    notifyListeners();
  }

  void removeDeck(int index) async {
    await FlashcardDb.deleteDeck(currentDecks[index].id);
    fetchDecks();
  }

  String getDeckTitle(String id) {
    DeckModel deck = currentDecks.firstWhere((deck) => deck.id == id);
    return deck.title;
  }

  void nextFlashcard(int index) {}
  void prevFlashcard(int index) {}

  int deckLength() => currentCards.length;
}
