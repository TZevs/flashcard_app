import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/models/deck_model.dart';

class FirebaseDeckModel {
  final String id;
  final String title;
  final String userId;
  final String username;
  final Timestamp createdAt;
  final bool isPublic;
  final int cardCount;
  int? savedCount;
  List<dynamic>? tags;

  FirebaseDeckModel({
    required this.id,
    required this.title,
    required this.userId,
    required this.username,
    required this.createdAt,
    required this.isPublic,
    required this.cardCount,
    this.savedCount = 0,
    this.tags,
  });

  // Converting Firestore document snapshot to a FirebaseDeckModel
  factory FirebaseDeckModel.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> deckSnapshot) {
    final data = deckSnapshot.data();
    return FirebaseDeckModel(
      id: data['id'],
      title: data['title'],
      userId: data['userId'],
      username: data['username'],
      createdAt: data['createdAt'],
      isPublic: data['isPublic'],
      cardCount: data['cardCount'],
      savedCount: data['savedCount'],
      tags: data['tags'],
    );
  }

  // Converting a DeckModel to a FirebaseDeckModel - Deck going from private to public
  factory FirebaseDeckModel.fromLocal(
      DeckModel local, String userId, String userName) {
    return FirebaseDeckModel(
      id: local.id,
      title: local.title,
      userId: userId,
      username: userName,
      createdAt: Timestamp.fromDate(DateTime.now()),
      isPublic: local.isPublic,
      cardCount: local.cardCount,
    );
  }

  // Converting FirebaseDeckModel to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'userId': userId,
      'username': username,
      'createdAt': createdAt,
      'isPublic': isPublic,
      'cardCount': cardCount,
      'savedCount': savedCount,
      'tags': tags,
    };
  }
}
