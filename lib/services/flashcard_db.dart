import 'package:flashcard_app/models/deck_model.dart';
import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FlashcardDb {
  static Future<Database> _openDatabase() async {
    final database_path = await getDatabasesPath();
    final database_file = join(database_path, 'flashcardDatabase.db');
    return openDatabase(
      database_file,
      version: 1,
      onCreate: createDatabase,
      onOpen: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  static Future<void> createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE decks (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        isPublic BOOLEAN NOT NULL,
        cardCount INTEGER NOT NULL,
        ownerId TEXT NOT NULL,
      )
    ''');

    await db.execute('''
      CREATE TABLE flashcards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        deckId TEXT NOT NULL,
        cardFront TEXT NOT NULL,
        cardBack TEXT NOT NULL,
        frontImgPath TEXT,
        backImgPath TEXT,
        FOREIGN KEY (deckId) REFERENCES decks (id) ON DELETE CASCADE
      )
    ''');
  }

  static Future<List<DeckModel>> getDecks() async {
    final db = await _openDatabase();
    final List<Map<String, dynamic>> decks = await db.query('decks');

    return decks.map((deck) => DeckModel.fromMap(deck)).toList();
  }

  static Future<List<FlashcardModel>> getDeckFlashcards(String deckID) async {
    final db = await _openDatabase();
    final cards =
        await db.query('flashcards', where: 'deckId=?', whereArgs: [deckID]);

    return cards.map((card) => FlashcardModel.fromMap(card)).toList();
  }

  static Future<int> addDeck(DeckModel deck) async {
    final db = await _openDatabase();
    var newDeck = deck.toMap();
    return await db.insert('decks', newDeck);
  }

  static Future<void> addDeckFlashcards(List<FlashcardModel> cards) async {
    final db = await _openDatabase();

    for (var card in cards) {
      var newCard = card.toMap();
      await db.insert('flashcards', newCard);
    }
  }

  static Future<int> deleteDeck(String deckID) async {
    final db = await _openDatabase();
    return await db.delete('decks', where: 'id=?', whereArgs: [deckID]);
  }

  static Future<int> deleteFlashcards(List<int> cardIds) async {
    final db = await _openDatabase();
    for (int id in cardIds) {
      await db.delete('flashcards', where: 'id=?', whereArgs: [id]);
    }
    return cardIds.length;
  }

  static Future<int> updateFlashcards(FlashcardModel card) async {
    final db = await _openDatabase();

    return await db.update(
      'flashcards',
      card.toMap(),
      where: 'id=?',
      whereArgs: [card.id],
    );
  }

  static Future<int> updateDeck(DeckModel deck) async {
    final db = await _openDatabase();

    return await db.update(
      'decks',
      deck.toMap(),
      where: 'id=?',
      whereArgs: [deck.id],
    );
  }
}
