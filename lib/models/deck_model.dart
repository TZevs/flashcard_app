import 'package:uuid/uuid.dart';

var uuid = Uuid();

class DeckModel {
  final String id;
  String title;
  bool isPublic;
  int cardCount;

  DeckModel(
      {required this.id,
      required this.title,
      required this.isPublic,
      required this.cardCount});

  // Converts Deck obejct to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isPublic': isPublic,
      'cardCount': cardCount
    };
  }

  // Converts map to a Deck object
  factory DeckModel.fromMap(Map<String, dynamic> deck) {
    return DeckModel(
        id: deck['id'],
        title: deck['title'],
        isPublic: deck['isPublic'] == 0 ? false : true,
        cardCount: deck['cardCount']);
  }
}
