import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:flutter/material.dart';

class EditDeckViewmodel extends ChangeNotifier {
  List<FlashcardModel> _flashcards = [];
  List<FlashcardModel> get getFlashcards => _flashcards;
  String theDeckId = "";

  String deckTitle = "";
  bool isPublic = false;

  String publicOrPrivateLabel = "Make Public?";

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
    _flashcards.add(
        FlashcardModel(deckId: theDeckId, cardFront: front, cardBack: back));
    notifyListeners();
  }

  void removeFlashcard(int index) {
    _flashcards.removeAt(index);
    notifyListeners();
  }

  void editFlashcard(int index, String front, String back) {
    var toEdit = _flashcards[index];
    toEdit.cardFront = front;
    toEdit.cardBack = back;
    notifyListeners();
  }
}
