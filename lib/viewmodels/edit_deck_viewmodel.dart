import 'dart:io';

import 'package:flashcard_app/models/deck_model.dart';
import 'package:flashcard_app/models/firebase_deck_model.dart';
import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:flashcard_app/services/firebase_db.dart';
import 'package:flashcard_app/services/flashcard_db.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class EditDeckViewmodel extends ChangeNotifier {
  List<FlashcardModel> _flashcards = [];
  List<FlashcardModel> get getFlashcards => _flashcards;
  List<FlashcardModel> _newFlashcards = [];

  List<FlashcardModel> editedCards = [];
  List<int> deletedCards = [];

  late DeckModel deckToEdit;

  File? _frontImg;
  File? _backImg;
  File? get frontImg => _frontImg;
  File? get backImg => _backImg;

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

  Future<void> newPublicDeck(DeckModel deck, String userId) async {
    FirebaseDeckModel newDeck = FirebaseDeckModel.fromLocal(deck, userId);
    List<FlashcardModel> _updatedFlashcards = [];

    for (var card in _flashcards) {
      if (card.frontImgPath != null) {
        String frontUrl = await FirebaseDb.uploadImgToFirebase(
            File(card.frontImgPath!), userId);
        card.frontImgUrl = frontUrl;
      }
      if (card.backImgPath != null) {
        String backUrl = await FirebaseDb.uploadImgToFirebase(
            File(card.frontImgPath!), userId);
        card.frontImgUrl = backUrl;
      }

      _updatedFlashcards.add(card);
    }

    await FirebaseDb.addPublicDeck(newDeck, userId, _updatedFlashcards);
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

  Future<void> galleryImg({required bool isFront}) async {
    final XFile? pickedImg =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImg == null) return;

    final file = File(pickedImg.path);
    if (isFront) {
      _frontImg = file;
    } else {
      _backImg = file;
    }

    notifyListeners();
  }

  Future<void> captureImg({required bool isFront}) async {
    final XFile? pickedImg =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedImg == null) return;

    final file = File(pickedImg.path);
    if (isFront) {
      _frontImg = file;
    } else {
      _backImg = file;
    }

    notifyListeners();
  }

  Future<String> _saveImgPath(File imageFile, String label) async {
    final dir = await getApplicationDocumentsDirectory();
    final newPath =
        '${dir.path}/${DateTime.now().millisecondsSinceEpoch}_$label.jpg';
    final savedPath = await imageFile.copy(newPath);
    return savedPath.path;
  }

  void addFlashcard(String front, String back) async {
    String? frontPath;
    String? backPath;

    if (_frontImg != null) {
      frontPath = await _saveImgPath(_frontImg!, "front");
    }
    if (_backImg != null) {
      backPath = await _saveImgPath(_backImg!, "back");
    }

    FlashcardModel newCard = FlashcardModel(
        deckId: deckToEdit.id,
        cardFront: front,
        cardBack: back,
        frontImgPath: frontPath,
        backImgPath: backPath);

    _flashcards.add(newCard);
    _newFlashcards.add(newCard);

    _frontImg = null;
    _backImg = null;
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

  void editFlashcard(int index, String front, String back) async {
    if (_flashcards[index].id != null) {
      editedCards.add(_flashcards[index]);
    }

    FlashcardModel toEdit = _flashcards[index];
    toEdit.cardFront = front;
    toEdit.cardBack = back;

    if (_frontImg != null) {
      toEdit.frontImgPath = await _saveImgPath(_frontImg!, "front");
    }
    if (_backImg != null) {
      toEdit.backImgPath = await _saveImgPath(_backImg!, "back");
    }

    _frontImg = null;
    _backImg = null;

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
