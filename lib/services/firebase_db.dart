import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/models/firebase_deck_model.dart';
import 'package:flashcard_app/models/flashcard_model.dart';

class FirebaseDb {
  static Future<void> addPublicDeck(FirebaseDeckModel newDeck, String userId,
      List<FlashcardModel> cards) async {
    Map<String, dynamic> deckData = newDeck.toFirestore();
    final deckRef =
        FirebaseFirestore.instance.collection('decks').doc(newDeck.id);
    await deckRef.set(deckData);

    final flashcardsRef = deckRef.collection('flashcards');
    for (var card in cards) {
      Map<String, dynamic> cardData = card.toMap();
      await flashcardsRef.add(cardData);
    }
  }

  static Future<void> deletePublicDeck(String deckId) async {
    final deckRef =
        await FirebaseFirestore.instance.collection('decks').doc(deckId);
    await deckRef.delete();

    await deckRef.collection('flashcards').get().then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  static Future<void> updateDeck(String deckId, String deckTitle) async {
    final deckRef =
        await FirebaseFirestore.instance.collection('decks').doc(deckId);
    await deckRef.update({'title': deckTitle});
  }

  static Future<void> updateDeckCards(
      String deckId, List<FlashcardModel> cards, int count) async {
    final deckRef =
        await FirebaseFirestore.instance.collection('decks').doc(deckId);
    await deckRef.update({'cardCount': count});
    final flashcardsRef = deckRef.collection('flashcards');
    await flashcardsRef.get().then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
    for (var card in cards) {
      Map<String, dynamic> cardData = card.toMap();
      await flashcardsRef.add(cardData);
    }
  }

  // static Future<List<FirebaseDeckModel>> getPublicDecks() async {
  //   final decksRef = FirebaseFirestore.instance.collection('decks');
  // }
}
