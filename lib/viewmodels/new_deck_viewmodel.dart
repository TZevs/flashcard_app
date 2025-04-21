import 'dart:io';

import 'package:flashcard_app/models/deck_model.dart';
import 'package:flashcard_app/models/firebase_deck_model.dart';
import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:flashcard_app/services/firebase_db.dart';
import 'package:flashcard_app/services/flashcard_db.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class NewDeckViewmodel extends ChangeNotifier {
  String theDeckId = uuid.v4();

  List<FlashcardModel> _newFlashcards = [];
  String deckTitle = "";
  bool isPublic = false;
  String publicOrPrivateLabel = "Make Public?";
  File? _frontImg;
  File? _backImg;

  List<FlashcardModel> get flashcards => _newFlashcards;
  File? get frontImg => _frontImg;
  File? get backImg => _backImg;

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
      await setPublicDeck(newDeck, id);
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
