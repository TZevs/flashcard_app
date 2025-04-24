// import 'package:flashcard_app/models/deck_model.dart';
// import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:flashcard_app/services/flashcard_db.dart';
import 'package:flashcard_app/services/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class FlashcardViewModel extends ChangeNotifier {
  List<dynamic> _fetchedFlashcards = [];
  late dynamic _currentFlashcard;
  late dynamic deck;
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

  List<dynamic> get flashcards => _fetchedFlashcards;

  dynamic getCurrentFlashcard() {
    _currentFlashcard = flashcards[_currentIndex];
    notifyListeners();
    return _currentFlashcard;
  }

  String getDeckTitle(dynamic deck) => deck.title;
  int get getDeckCardCount => deck.cardCount;

  void updateCurrentIndex(int index) async {
    if (index >= 0 && index < flashcards.length) {
      _currentIndex = index;
      notifyListeners();
    }
    if (index == flashcards.length) {
      await Future.delayed(Duration(seconds: 40));
      await Notifications.displayEndOfDeckNotification(
        notificationTitle: "Congratulations! You reached the end",
        notificationBody: "Click here to go back to the decks screen",
      );
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
