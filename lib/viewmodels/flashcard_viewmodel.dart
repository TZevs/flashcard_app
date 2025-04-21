import 'package:flashcard_app/models/deck_model.dart';
import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:flashcard_app/services/flashcard_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class FlashcardViewModel extends ChangeNotifier {
  List<FlashcardModel> _fetchedFlashcards = [];
  late FlashcardModel _currentFlashcard;
  late DeckModel deck;
  final tts = FlutterTts();

  bool isSwiping = false;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  Future<void> fetchDeckFlashcards(String deckID) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 1));
    _fetchedFlashcards = await FlashcardDb.getDeckFlashcards(deckID);

    _currentIndex = 0;
    _isLoading = false;
    notifyListeners();
  }

  List<FlashcardModel> get flashcards => _fetchedFlashcards;

  FlashcardModel getCurrentFlashcard() {
    _currentFlashcard = flashcards[_currentIndex];
    notifyListeners();
    return _currentFlashcard;
  }

  String getDeckTitle(DeckModel deck) => deck.title;
  int get getDeckCardCount => deck.cardCount;

  void updateCurrentIndex(int index) {
    if (index >= 0 && index < flashcards.length) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  Future<void> speak(String text) async {
    await tts.setLanguage("en-US");
    await tts.setPitch(1.0);
    await tts.setSpeechRate(0.5);

    if (text.isNotEmpty) {
      await tts.speak(text);
    }
  }
}
