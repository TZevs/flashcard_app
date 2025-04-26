import 'package:flashcard_app/models/deck_model.dart';
import 'package:flashcard_app/models/firebase_deck_model.dart';
import 'package:flashcard_app/services/firebase_db.dart';
import 'package:flashcard_app/services/flashcard_db.dart';
import 'package:flutter/material.dart';

enum DeckCategory { myDecks, savedDecks }

class DeckViewModel extends ChangeNotifier {
  DeckCategory _currentCategory = DeckCategory.myDecks;
  DeckCategory get currentCategory => _currentCategory;

  List<DeckModel> _decks = [];
  List<DeckModel> get decks => _decks;

  List<FirebaseDeckModel> _savedDecks = [];
  List<FirebaseDeckModel> get savedDecks => _savedDecks;
  bool _savedDecksFetched = false;

  Future<void> fetchDecks() async {
    _decks = await FlashcardDb.getDecks();
    notifyListeners();
  }

  Future<void> removeDeck(int index) async {
    final id = _decks[index].id;
    if (_decks[index].isPublic) {
      await FirebaseDb.deletePublicDeck(id);
    }
    await FlashcardDb.deleteDeck(id);
    await fetchDecks();
    notifyListeners();
  }

  Future<void> fetchSavedDecks(String userId) async {
    if (_savedDecksFetched) return;
    _savedDecks = await FirebaseDb.fetchSavedDecks(userId);
    _savedDecksFetched = true;
    notifyListeners();
  }

  void switchCategory(DeckCategory category, {String? userId}) async {
    _currentCategory = category;

    if (category == DeckCategory.myDecks && decks.isEmpty) {
      await fetchDecks();
    } else if (category == DeckCategory.savedDecks &&
        userId != null &&
        savedDecks.isEmpty) {
      await fetchSavedDecks(userId);
    }

    notifyListeners();
  }

  // Future<void> unSaveDeck(String deckId, String userId) async {
  //   await FirebaseDb.removeSavedDeck(userId, deckId);
  //   notifyListeners();
  // }
}
