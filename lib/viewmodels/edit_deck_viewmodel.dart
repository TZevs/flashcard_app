import 'package:flashcard_app/models/deck_model.dart';
import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:flashcard_app/services/flashcard_db.dart';
import 'package:flutter/material.dart';

class EditDeckViewmodel extends ChangeNotifier {
  List<FlashcardModel> _flashcards = [];
  List<FlashcardModel> get getFlashcards => _flashcards;
  List<FlashcardModel> _newFlashcards = [];

  List<FlashcardModel> editedCards = [];
  List<int> deletedCards = [];

  late DeckModel deckToEdit;

  String deckTitle = "";
  bool isPublic = false;

  String publicOrPrivateLabel = "";

  Future<void> fetchDeckFlashcards(String deckID) async {
    await Future.delayed(Duration(seconds: 1));
    _flashcards = await FlashcardDb.getDeckFlashcards(deckID);
    notifyListeners();
  }

  Future<void> updateCards() async {
    if (deletedCards.isNotEmpty) {
      await FlashcardDb.deleteFlashcards(deletedCards);
    } else if (editedCards.isNotEmpty) {
      for (var card in editedCards) {
        await FlashcardDb.updateFlashcards(card);
      }
    } else if (_newFlashcards.isNotEmpty) {
      await FlashcardDb.addDeckFlashcards(_newFlashcards);
    }
    notifyListeners();
  }

  Future<void> updateDeck() async {
    DeckModel newDeck = DeckModel(
      id: deckToEdit.id,
      title: deckTitle,
      isPublic: isPublic,
      cardCount: _flashcards.length,
    );
    await FlashcardDb.updateDeck(newDeck);
    notifyListeners();
  }

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
    FlashcardModel newCard =
        FlashcardModel(deckId: deckToEdit.id, cardFront: front, cardBack: back);
    _flashcards.add(newCard);
    _newFlashcards.add(newCard);
    notifyListeners();
  }

  void removeFlashcard(int index) {
    if (_flashcards[index].id != null) {
      deletedCards.add(_flashcards[index].id!);
      _flashcards.removeAt(index);
    } else {
      _flashcards.removeAt(index);
      _newFlashcards.removeAt(index);
    }
    notifyListeners();
  }

  void editFlashcard(int index, String front, String back) {
    FlashcardModel toEdit;
    if (_flashcards[index].id != null) {
      editedCards.add(_flashcards[index]);
    }
    toEdit = _flashcards[index];
    toEdit.cardFront = front;
    toEdit.cardBack = back;
    notifyListeners();
  }
}
