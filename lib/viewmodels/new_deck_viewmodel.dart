import 'package:flashcard_app/models/deck_model.dart';
import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:flashcard_app/services/flashcard_db.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class NewDeckViewmodel extends ChangeNotifier {
  List<FlashcardModel> newFlashcards = [];
  String deckTitle = "";
  bool isPublic = false;
  String theDeckId = uuid.v4();

  List<FlashcardModel> get getFlashcards => newFlashcards;

  void setDeckTitle(String title) {
    deckTitle = title;
    notifyListeners();
  }

  void setIsPublic(bool bool) {
    isPublic = bool;
    notifyListeners();
  }

  void addFlashcard(dynamic front, dynamic back) {
    newFlashcards.add(
        FlashcardModel(deckId: theDeckId, cardFront: front, cardBack: back));
    notifyListeners();
  }

  void removeFlashcard(int index) {
    newFlashcards.removeAt(index);
    notifyListeners();
  }

  void editFlashcard(int index, dynamic front, dynamic back) {
    var toEdit = newFlashcards[index];
    toEdit.cardFront = front;
    toEdit.cardBack = back;
    notifyListeners();
  }

  void addNewDeck() async {
    DeckModel newDeck = DeckModel(
        id: theDeckId,
        title: deckTitle,
        isPublic: isPublic,
        cardCount: newFlashcards.length);

    await FlashcardDb.addDeck(newDeck);
    addFlashcardsToDB();
  }

  void addFlashcardsToDB() async {
    await FlashcardDb.addDeckFlashcards(newFlashcards);
  }

  void reset() {
    theDeckId = uuid.v4();
    newFlashcards = [];
    deckTitle = "";
    isPublic = false;
    notifyListeners();
  }
}
