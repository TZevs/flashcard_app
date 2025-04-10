import 'package:flashcard_app/models/deck_model.dart';
import 'package:flashcard_app/services/flashcard_db.dart';
import 'package:flutter/material.dart';

class DeckViewModel extends ChangeNotifier {
  List<DeckModel> _decks = [];
  List<DeckModel> get decks => _decks;

  void fetchDecks() async {
    _decks = await FlashcardDb.getDecks();
    notifyListeners();
  }

  void removeDeck(int index) async {
    await FlashcardDb.deleteDeck(decks[index].id);
    fetchDecks();
    notifyListeners();
  }
}
