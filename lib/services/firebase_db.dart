import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      final user = <String, String>{'userId': userId};
      cardData.addEntries(user.entries);
      await flashcardsRef.add(cardData);
    }
  }

  static Future<void> deletePublicDeck(String deckId) async {
    final deckRef = FirebaseFirestore.instance.collection('decks').doc(deckId);
    await deckRef.delete();

    await deckRef.collection('flashcards').get().then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  static Future<void> updateDeck(String deckId, String deckTitle) async {
    final deckRef = FirebaseFirestore.instance.collection('decks').doc(deckId);
    await deckRef.update({'title': deckTitle});
  }

  static Future<void> updateDeckCards(
      String deckId, List<FlashcardModel> cards, int count) async {
    final deckRef = FirebaseFirestore.instance.collection('decks').doc(deckId);
    await deckRef.update({'cardCount': count});
    final flashcardsRef = deckRef.collection('flashcards');
    await flashcardsRef.get().then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
    for (var card in cards) {
      Map<String, dynamic> cardData = card.toMap();
      final user = <String, String>{
        'userId': FirebaseAuth.instance.currentUser!.uid
      };
      cardData.addEntries(user.entries);
      await flashcardsRef.add(cardData);
    }
  }

  static Future<List<FlashcardModel>> fetchDeckCards(String deckId) async {
    final cardsRef = FirebaseFirestore.instance
        .collection('decks')
        .doc(deckId)
        .collection('flashcards');

    List<FlashcardModel> cards = [];

    await cardsRef.get().then((snapshot) async {
      for (var doc in snapshot.docs) {
        FlashcardModel card = FlashcardModel.fromFirestore(doc);

        if (card.frontImgPath != null && card.frontImgPath!.isNotEmpty) {
          try {
            final ref =
                FirebaseStorage.instance.ref().child(card.frontImgPath!);
            String downloadUrl = await ref.getDownloadURL();
            card.frontImgPath = downloadUrl;
          } catch (e) {
            print('Failed to fetch image for ${card.frontImgPath}: $e');
          }
        }

        if (card.backImgPath != null && card.backImgPath!.isNotEmpty) {
          try {
            final ref = FirebaseStorage.instance.ref().child(card.backImgPath!);
            String downloadUrl = await ref.getDownloadURL();
            card.backImgPath = downloadUrl;
          } catch (e) {
            print('Failed to fetch image for ${card.backImgPath}: $e');
          }
        }

        cards.add(card);
      }
    });

    return cards;
  }

  static Future<String> uploadImgToFirebase(File imgFile, String userId) async {
    final fileName = basename(imgFile.path);
    final path = 'flashcardImages/$userId/$fileName';

    final ref = FirebaseStorage.instance.ref().child(path);

    await ref.putFile(imgFile);
    return path;
    // return await ref.getDownloadURL();
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

  static Future<String?> fetchUsername(String userID) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();
    return doc.data()?['username'];
  }

  static Future<void> addSavedDeck(String userId, String deckID) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    await userRef.update({
      'savedDecks': FieldValue.arrayUnion([deckID])
    });

    await FirebaseFirestore.instance.collection('decks').doc(deckID).update({
      'savedCount': FieldValue.increment(1),
    });
  }

  static Future<void> removeSavedDeck(String userId, String deckId) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);

    await userDoc.update({
      'savedDecks': FieldValue.arrayRemove([deckId])
    });

    await FirebaseFirestore.instance.collection('decks').doc(deckId).update({
      'savedCount': FieldValue.increment(-1),
    });
  }

  static Future<List<FirebaseDeckModel>> fetchSavedDecks(String userId) async {
    List<FirebaseDeckModel> savedDecks = [];

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    List<String> deckIds = List<String>.from(userDoc['savedDecks'] ?? []);

    if (deckIds.isEmpty) return [];

    const int batchSize = 10;
    for (int i = 0; i < deckIds.length; i += batchSize) {
      final batch = deckIds.sublist(
          i, i + batchSize > deckIds.length ? deckIds.length : i + batchSize);

      final snapshot = await FirebaseFirestore.instance
          .collection('decks')
          .where('id', whereIn: batch)
          .get();

      for (var s in snapshot.docs) {
        FirebaseDeckModel deck = FirebaseDeckModel.fromFirestore(s);
        savedDecks.add(deck);
      }
    }

    return savedDecks;
  }

  static Future<List<String>> getSavedDeckIDs(String userID) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();

    List<String> deckIds = List<String>.from(userDoc['savedDecks'] ?? []);
    return deckIds;
  }

  static Future<String> setProfileImg(String userID, File img) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userID);
    final fileName = basename(img.path);

    final ref = FirebaseStorage.instance
        .ref()
        .child('flashcardImages/$userID/$fileName');

    await ref.putFile(img);
    final url = await ref.getDownloadURL();

    await userDoc.update({'profilePic': url});
    return url;
  }

  static Future<void> setProfileBio(String userID, String bio) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userID);

    await userDoc.update({'profileBio': bio});
  }

  static Future<String> fetchBio(String userID) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();
    return doc.data()?['profileBio'];
  }
}
