import 'package:uuid/uuid.dart';

var uuid = Uuid();

class DeckModel {
  final String id;
  final String title;
  final bool isPublic;

  DeckModel({required this.id, required this.title, required this.isPublic});

  // Converts Deck obejct to map
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'isPublic': isPublic};
  }

  // Converts map to a Deck object
  factory DeckModel.fromMap(Map<String, dynamic> deck) {
    return DeckModel(
        id: deck['id'], title: deck['title'], isPublic: deck['isPublic']);
  }
}
