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
  Future<void> fetchDecks() async {
    // Add try and catch
    _decks = await FlashcardDb.getDecks();
    notifyListeners();
  }

  Future<void> fetchDeckFlashcards(int deckID) async {
    _flashcards = await FlashcardDb.getDeckFlashcards(deckID);
    notifyListeners();
  }
}