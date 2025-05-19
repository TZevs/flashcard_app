import 'package:flashcard_app/models/firebase_deck_model.dart';
import 'package:flashcard_app/services/firebase_db.dart';
import 'package:flutter/material.dart';

class ShareDecksViewmodel extends ChangeNotifier {
  List<FirebaseDeckModel> _allDecks = [];
  List<FirebaseDeckModel> get allDecks => _allDecks;

  Map<String, List<FirebaseDeckModel>> decksByTag = {};

  bool _hasFetched = false;
  bool isSearching = false;
  String selectedTag = "";
  List<FirebaseDeckModel> searchResults = [];

  List<String> _savedIDs = [];
  List<String> get savedIDs => _savedIDs;

  final List<String> _tags = [
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
  List<String> get tags => _tags;

  Future<void> fetchPublicDecks() async {
    if (_hasFetched) return;
    _hasFetched = true;

    _allDecks = await FirebaseDb.fetchDecks();
    _groupByDecks();
    notifyListeners();
  }

  Future<void> toggleSavedDeck(String deckId, String userId) async {
    if (!_savedIDs.contains(deckId)) {
      await FirebaseDb.addSavedDeck(userId, deckId);
      await getSavedIDs(userId);
      return;
    }

    if (_savedIDs.contains(deckId)) {
      _savedIDs.remove(deckId);
      await FirebaseDb.removeSavedDeck(userId, deckId);
      await getSavedIDs(userId);
      return;
    }
    notifyListeners();
  }

  Future<void> getSavedIDs(String userID) async {
    _savedIDs = await FirebaseDb.getSavedDeckIDs(userID);
    notifyListeners();
  }

  void _groupByDecks() {
    decksByTag.clear();

    for (var deck in _allDecks) {
      for (var tag in deck.tags!) {
        if (!decksByTag.containsKey(tag)) {
          decksByTag[tag] = [];
        }
        decksByTag[tag]!.add(deck);
      }
    }
  }

  List<String> getTopTags() {
    final sortedTags = decksByTag.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));
    return sortedTags.take(3).map((e) => e.key).toList();
  }

  List<FirebaseDeckModel> getDecksForTag(String tag) {
    return decksByTag[tag]?.take(10).toList() ?? [];
  }

  void searchDecks(String query) {
    isSearching = true;
    selectedTag = "";
    searchResults = _allDecks.where((deck) {
      return deck.title.toLowerCase().contains(query.toLowerCase());
    }).toList();
    notifyListeners();
  }

  void filterByTag(String tag) {
    isSearching = false;
    selectedTag = tag;
    notifyListeners();
  }

  void clearFilterAndSearch() {
    isSearching = false;
    selectedTag = "";
    searchResults = [];
    notifyListeners();
  }
}
