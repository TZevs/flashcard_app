import 'dart:io';

import 'package:flashcard_app/models/deck_model.dart';
import 'package:flashcard_app/models/firebase_deck_model.dart';
import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:flashcard_app/services/firebase_db.dart';
import 'package:flashcard_app/services/flashcard_db.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class NewDeckViewmodel extends ChangeNotifier {
  String theDeckId = uuid.v4();

  List<String> topics = [
    "Maths",
    "History",
    "Literature",
    "Psychology",
    "Sociology",
    "Biology",
    "Chemistry",
    "Physics",
    "Geography",
    "Health and Medicine",
    "Architecture",
    "Education",
    "Law",
    "Linguistics",
    "Languages",
    "Other",
  ];
  List<String> _selectedTags = [];
  List<String> get selectedTags => _selectedTags;

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

  void clearFrontImg() {
    _frontImg = null;
    notifyListeners();
  }

  void clearBackImg() {
    _backImg = null;
    notifyListeners();
  }

  void addTag(String tag) {
    if (!selectedTags.contains(tag)) {
      _selectedTags.add(tag);
      notifyListeners();
    }
  }

  void removeTag(String tag) {
    _selectedTags.remove(tag);
    notifyListeners();
  }

  void clearTags() {
    _selectedTags.clear();
    notifyListeners();
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

    _newFlashcards.add(FlashcardModel(
        deckId: theDeckId,
        cardFront: front,
        cardBack: back,
        frontImgPath: frontPath,
        backImgPath: backPath));

    _frontImg = null;
    _backImg = null;
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

  void removeFlashcard(int index) {
    _newFlashcards.removeAt(index);
    notifyListeners();
  }

  void editFlashcard(int index, String front, String back) async {
    FlashcardModel toEdit = _newFlashcards[index];

    if (_frontImg != null) {
      toEdit.frontImgPath = await _saveImgPath(_frontImg!, "front");
    }
    if (_backImg != null) {
      toEdit.backImgPath = await _saveImgPath(_backImg!, "back");
    }

    toEdit.cardFront = front;
    toEdit.cardBack = back;

    _frontImg = null;
    _backImg = null;

    notifyListeners();
  }

  Future<void> addNewDeck(String id, String username) async {
    DeckModel newDeck = DeckModel(
        id: theDeckId,
        title: deckTitle,
        isPublic: isPublic,
        cardCount: _newFlashcards.length);

    if (newDeck.isPublic) {
      await _setPublicDeck(newDeck, id, username);
    }

    await FlashcardDb.addDeck(newDeck);
    await FlashcardDb.addDeckFlashcards(_newFlashcards);
    notifyListeners();
  }

  Future<void> _setPublicDeck(
      DeckModel deck, String userId, String username) async {
    FirebaseDeckModel newDeck =
        FirebaseDeckModel.fromLocal(deck, userId, username);

    newDeck.tags = _selectedTags;

    List<FlashcardModel> _updatedFlashcards = [];

    for (var card in _newFlashcards) {
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

  void reset() {
    theDeckId = uuid.v4();
    _newFlashcards = [];
    deckTitle = "";
    isPublic = false;
    notifyListeners();
  }
}
