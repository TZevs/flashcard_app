import 'package:flashcard_app/models/deck_model.dart';
import 'package:flashcard_app/models/firebase_deck_model.dart';
import 'package:flashcard_app/services/firebase_db.dart';
import 'package:flashcard_app/services/flashcard_db.dart';
import 'package:flashcard_app/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';

enum DeckCategory { myDecks, savedDecks }

class DeckViewModel extends ChangeNotifier {
  late AuthViewModel _auth;

  void updateAuth(AuthViewModel auth) {
    _auth = auth;
    notifyListeners();
  }

  String? get userId => _auth.userId;
  String? get username => _auth.username;

  DeckCategory _currentCategory = DeckCategory.myDecks;
  DeckCategory get currentCategory => _currentCategory;

  List<DeckModel> _decks = [];
  List<DeckModel> get decks => _decks;

  List<FirebaseDeckModel> _savedDecks = [];
  List<FirebaseDeckModel> get savedDecks => _savedDecks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchDecks() async {
    _isLoading = true;
    notifyListeners();

    _decks = await FlashcardDb.getDecks();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> removeDeck(int index) async {
    final id = _decks[index].id;
    if (_decks[index].isPublic) {
      await FirebaseDb.deletePublicDeck(id);
    }
    await FlashcardDb.deleteDeck(id);
    await fetchDecks();
    notifyListeners();
  }

  Future<void> fetchSavedDecks() async {
    _isLoading = true;
    notifyListeners();

    _savedDecks = await FirebaseDb.fetchSavedDecks(userId!);

    _isLoading = false;
    notifyListeners();
  }

  void switchCategory(DeckCategory category) async {
    _currentCategory = category;

    if (category == DeckCategory.myDecks && decks.isEmpty) {
      await fetchDecks();
    } else if (category == DeckCategory.savedDecks && savedDecks.isEmpty) {
      await fetchSavedDecks();
    }

    notifyListeners();
  }

  Future<void> unSaveDeck(String deckId) async {
    await FirebaseDb.removeSavedDeck(userId!, deckId);
    notifyListeners();
  }
}
