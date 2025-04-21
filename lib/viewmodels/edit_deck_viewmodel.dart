// import 'package:firebase_core/firebase_core.dart';
import 'package:flashcard_app/models/deck_model.dart';
import 'package:flashcard_app/models/firebase_deck_model.dart';
import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:flashcard_app/services/firebase_db.dart';
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
    }
    if (editedCards.isNotEmpty) {
      for (var card in editedCards) {
        await FlashcardDb.updateFlashcards(card);
      }
    }
    if (_newFlashcards.isNotEmpty) {
      await FlashcardDb.addDeckFlashcards(_newFlashcards);
    }
    notifyListeners();
  }

  Future<void> updateDeck(String id) async {
    DeckModel newDeck = DeckModel(
      id: deckToEdit.id,
      title: deckTitle,
      isPublic: isPublic,
      cardCount: _flashcards.length,
    );

    if (!deckToEdit.isPublic && isPublic) {
      await newPublicDeck(newDeck, id);
    }
    if (deckToEdit.isPublic && isPublic == false) {
      await FirebaseDb.deletePublicDeck(newDeck.id);
    }
    if (deckToEdit.isPublic && isPublic) {
      if (deckTitle != "") {
        await FirebaseDb.updateDeck(newDeck.id, deckTitle);
      } else if (deletedCards.isNotEmpty ||
          editedCards.isNotEmpty ||
          _newFlashcards.isNotEmpty) {
        await FirebaseDb.updateDeckCards(
            newDeck.id, _flashcards, newDeck.cardCount);
      }
    }

    await FlashcardDb.updateDeck(newDeck);
    await updateCards();
    notifyListeners();
  }

  Future<void> newPublicDeck(DeckModel deck, String id) async {
    FirebaseDeckModel newDeck = FirebaseDeckModel.fromLocal(deck, id);

    await FirebaseDb.addPublicDeck(newDeck, id, _flashcards);
    notifyListeners();
  }

  void setDeckTitle(String title) {
    deckTitle = title;
    notifyListeners();
  }

  String setIsPublicLabel() {
    if (isPublic) {
      publicOrPrivateLabel = "Make Private?";
    } else {
      publicOrPrivateLabel = "Make Public?";
    }
    return publicOrPrivateLabel;
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

  void reset() {
    _newFlashcards.clear();
    editedCards.clear();
    deletedCards.clear();
    _flashcards.clear();
    deckTitle = "";
    isPublic = false;
    notifyListeners();
  }
}
