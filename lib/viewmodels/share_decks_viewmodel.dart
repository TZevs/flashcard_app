import 'package:flashcard_app/models/firebase_deck_model.dart';
import 'package:flashcard_app/services/firebase_db.dart';
import 'package:flutter/material.dart';

class ShareDecksViewmodel extends ChangeNotifier {
  List<FirebaseDeckModel> _publicDecks = [];
  List<FirebaseDeckModel> get getPublicDecks => _publicDecks;
  List<FirebaseDeckModel> _queriedDecks = [];
  List<FirebaseDeckModel> get getQueriedDecks => _queriedDecks;

  Future<void> fetchPublicDecks() async {
    _publicDecks = await FirebaseDb.fetchDecks();
    notifyListeners();
  }

  Future<void> queryDecks(String query) async {
    _queriedDecks = await FirebaseDb.getQueriedDecks(query);
    notifyListeners();
  }

  void getUsername(String userId) async {
    await FirebaseDb.fetchUsername(userId);
  }

  Future<void> saveDeck(String deckId, String userId) async {
    await FirebaseDb.addSavedDeck(deckId, userId);
    notifyListeners();
  }
}
