import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/models/deck_model.dart';

class FirebaseDeckModel {
  final String id;
  final String title;
  final String userId;
  final Timestamp createdAt;
  final bool isPublic;
  final int cardCount;

  FirebaseDeckModel({
    required this.id,
    required this.title,
    required this.userId,
    required this.createdAt,
    required this.isPublic,
    required this.cardCount,
  });

  factory FirebaseDeckModel.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> deckSnapshot) {
    final data = deckSnapshot.data();
    return FirebaseDeckModel(
      id: data['id'],
      title: data['title'],
      userId: data['userId'],
      createdAt: data['createdAt'],
      isPublic: data['isPublic'],
      cardCount: data['cardCount'],
    );
  }

  factory FirebaseDeckModel.fromLocal(DeckModel local, String userId) {
    return FirebaseDeckModel(
      id: local.id,
      title: local.title,
      userId: userId,
      createdAt: Timestamp.fromDate(DateTime.now()),
      isPublic: local.isPublic,
      cardCount: local.cardCount,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'userId': userId,
      'createdAt': createdAt,
      'isPublic': isPublic,
      'cardCount': cardCount,
    };
  }
}
