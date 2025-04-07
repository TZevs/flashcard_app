import 'package:flashcard_app/models/deck_model.dart';
import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class NewDeckViewmodel extends ChangeNotifier {
  List<FlashcardModel> _newFlashcards = [];
  var theDeckId = uuid.v4();

  void addNewDeck(String deckName, bool public) {
    DeckModel(id: theDeckId, title: deckName, isPublic: public);
  }

  void addFlashcardsToDB(List<FlashcardModel> cards) {}

  void addFlashcard(dynamic front, dynamic back) {
    _newFlashcards.add(
        FlashcardModel(deckId: theDeckId, cardFront: front, cardBack: back));
    notifyListeners();
  }

  void removeFlashcard(int index) {
    _newFlashcards.removeAt(index);
    notifyListeners();
  }
}
