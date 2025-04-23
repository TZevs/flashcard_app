import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flashcard_app/models/firebase_deck_model.dart';
import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:path/path.dart';

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

  static Future<String> uploadImgToFirebase(File imgFile, String userId) async {
    final fileName = basename(imgFile.path);
    final ref = FirebaseStorage.instance
        .ref()
        .child('flashcardImages/$userId/$fileName');

    await ref.putFile(imgFile);
    return await ref.getDownloadURL();
  }

  static Future<List<FirebaseDeckModel>> fetchDecks() async {
    final decksRef = FirebaseFirestore.instance.collection('decks');
    List<FirebaseDeckModel> decks = [];
    await decksRef.get().then((snapshot) {
      for (var doc in snapshot.docs) {
        FirebaseDeckModel deck = FirebaseDeckModel.fromFirestore(doc);
        decks.add(deck);
      }
    });

    return decks;
  }

  static Future<String> fetchUsername(String userID) async {
    String username = '';
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        username = snapshot.data()!['username'];
      }
    });
    return username;
  }

  static Future<void> addSavedDeck(String userId, String deckID) async {
    final userRef =
        await FirebaseFirestore.instance.collection('users').doc(userId);

    final deckData = {'deckID': deckID};
    await userRef.collection('savedDecks').add(deckData);

    final deckRef =
        await FirebaseFirestore.instance.collection('decks').doc(deckID);
    await deckRef.update({
      'savedCount': FieldValue.increment(1),
    });
  }

  static Future<void> removeSavedDeck(String userId, String deckId) async {}

  static Future<void> fetchSavedDecks(String userId) async {
    final userRef =
        await FirebaseFirestore.instance.collection('users').doc(userId);
    List<FirebaseDeckModel> savedDecks = [];
  }

  static Future<List<FirebaseDeckModel>> getQueriedDecks(String query) async {
    final decksRef = FirebaseFirestore.instance.collection('decks');
    List<FirebaseDeckModel> queriedDecks = [];
    List<String> queryList = query.split(' ');

    await decksRef
        .where(Filter.or(
          Filter('title', isEqualTo: query),
          Filter('title', whereIn: queryList),
        ))
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        FirebaseDeckModel deck = FirebaseDeckModel.fromFirestore(doc);
        queriedDecks.add(deck);
      }
    });

    return queriedDecks;
  }
}
