import 'package:flashcard_app/models/deck_model.dart';
import 'package:flashcard_app/models/firebase_deck_model.dart';
import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:flashcard_app/services/firebase_db.dart';
import 'package:flashcard_app/services/flashcard_db.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class NewDeckViewmodel extends ChangeNotifier {
  String theDeckId = uuid.v4();

  List<FlashcardModel> _newFlashcards = [];
  String deckTitle = "";
  bool isPublic = false;
  String publicOrPrivateLabel = "Make Public?";

  List<FlashcardModel> get flashcards => _newFlashcards;

  void setDeckTitle(String title) {
    deckTitle = title;
    notifyListeners();
  }

  void setIsPublic(bool value) {
    isPublic = value;
    if (isPublic) {
      publicOrPrivateLabel = "Make Private?";
    } else {
      publicOrPrivateLabel = "Make Public?";
    }
    notifyListeners();
  }

  void addFlashcard(String front, String back) {
    _newFlashcards.add(
        FlashcardModel(deckId: theDeckId, cardFront: front, cardBack: back));
    notifyListeners();
  }

  void removeFlashcard(int index) {
    _newFlashcards.removeAt(index);
    notifyListeners();
  }

  void editFlashcard(int index, String front, String back) {
    var toEdit = _newFlashcards[index];
    toEdit.cardFront = front;
    toEdit.cardBack = back;
    notifyListeners();
  }

  Future<void> addNewDeck(String id) async {
    DeckModel newDeck = DeckModel(
        id: theDeckId,
        title: deckTitle,
        isPublic: isPublic,
        cardCount: _newFlashcards.length);

    if (newDeck.isPublic) {
      setPublicDeck(newDeck, id);
    }

    await FlashcardDb.addDeck(newDeck);
    await FlashcardDb.addDeckFlashcards(_newFlashcards);
    notifyListeners();
  }

  Future<void> setPublicDeck(DeckModel deck, String id) async {
    FirebaseDeckModel newDeck = FirebaseDeckModel.fromLocal(deck, id);

    await FirebaseDb.addPublicDeck(newDeck, id, _newFlashcards);
    notifyListeners();
  }

  void reset() {
    theDeckId = uuid.v4();
    _newFlashcards = [];
    deckTitle = "";
    isPublic = false;
    notifyListeners();
  }
}
