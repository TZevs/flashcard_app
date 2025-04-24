import 'package:flashcard_app/models/deck_model.dart';
import 'package:flashcard_app/models/firebase_deck_model.dart';
import 'package:flashcard_app/services/firebase_db.dart';
import 'package:flashcard_app/services/flashcard_db.dart';
import 'package:flutter/material.dart';

class DeckViewModel extends ChangeNotifier {
  List<DeckModel> _decks = [];
  List<DeckModel> get decks => _decks;

  List<FirebaseDeckModel> _savedDecks = [];
  List<FirebaseDeckModel> get savedDecks => _savedDecks;

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
    _savedDecks = (await FirebaseDb.fetchSavedDecks(userId))!;
    notifyListeners();
  }

  bool isDeckPublic(int index) {
    return _decks[index].isPublic;
  }

  int getCardCount(int index) {
    return _decks[index].cardCount;
  }
}
