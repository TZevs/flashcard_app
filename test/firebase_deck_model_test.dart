import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/models/deck_model.dart';
import 'package:flashcard_app/models/firebase_deck_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Convert from to Firebase Deck Model Firebase Map', () {
    // Arrange
    final model = FirebaseDeckModel(
      id: "123",
      title: "TestingModel",
      userId: "456",
      username: "Test789",
      createdAt: Timestamp.now(),
      isPublic: true,
      cardCount: 20,
      savedCount: 2,
      tags: ['tag1', 'tag2'],
    );

    final Map<String, dynamic> expected = {
      'id': model.id,
      'title': model.title,
      'userId': model.userId,
      'username': model.username,
      'createdAt': model.createdAt,
      'isPublic': model.isPublic,
      'cardCount': model.cardCount,
      'savedCount': model.savedCount,
      'tags': model.tags,
    };

    // Act
    final result = model.toFirestore();

    // Assert
    expect(result['id'], expected['id']);
    expect(result['title'], expected['title']);
    expect(result['userId'], expected['userId']);
    expect(result['username'], expected['username']);
    expect(result['createdAt'].seconds, expected['createdAt'].seconds);
    expect(result['isPublic'], expected['isPublic']);
    expect(result['cardCount'], expected['cardCount']);
    expect(result['savedCount'], expected['savedCount']);
    expect(result['tags'], expected['tags']);
  });

  test('Convert a Local Deck Model to a Firebase Deck Model', () {
    // Arrange
    final model = DeckModel(
        id: "123", title: "TestingModel", isPublic: true, cardCount: 8);

    final expected = FirebaseDeckModel(
      id: "123",
      title: "TestingModel",
      userId: "456",
      username: "Test789",
      createdAt: Timestamp.now(),
      isPublic: true,
      cardCount: 8,
      savedCount: 0,
      tags: null,
    );

    // Act
    final result = FirebaseDeckModel.fromLocal(model, "456", "Test789");

    // Assert
    expect(result.id, expected.id);
    expect(result.title, expected.title);
    expect(result.userId, expected.userId);
    expect(result.username, expected.username);
    expect(result.createdAt.seconds, expected.createdAt.seconds);
    expect(result.isPublic, expected.isPublic);
    expect(result.cardCount, expected.cardCount);
    expect(result.savedCount, expected.savedCount);
    expect(result.tags, expected.tags);
  });
}
