import 'package:flashcard_app/models/deck_model.dart';
import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FlashcardDb {
  static Future<Database> _openDatabase() async {
    final database_path = await getDatabasesPath();
    final database_file = join(database_path, 'flashcardDatabase.db');
    return openDatabase(database_file, version: 1, onCreate: createDatabase);
  }

  static Future<void> createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS decks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        isPublic BOOLEAN NOT NULL  
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS flashcards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        deckId INTEGER NOT NULL,
        front TEXT NOT NULL,
        back TEXT NOT NULL,
        FOREIGN KEY (deckId) REFERENCES decks (id) ON DELETE CASCADE
      )
    ''');
  }

  static Future<List<DeckModel>> getDecks() async {
    final db = await _openDatabase();
    final List<Map<String, dynamic>> decks = await db.query('decks');

    return List.generate(decks.length, (i) {
      return DeckModel.fromMap(decks[i]);
    });
  }

  static Future<List<FlashcardModel>> getDeckFlashcards(int deckID) async {
    final db = await _openDatabase();
    List<Map<String, dynamic>> cards =
        await db.query('flashcards', where: 'deckId=?', whereArgs: [deckID]);

    return List.generate(cards.length, (i) {
      return FlashcardModel.fromMap(cards[i]);
    });
  }

  static Future<int> addDeck(DeckModel deck) async {
    final db = await _openDatabase();
    var newDeck = deck.toMap();
    return await db.insert('decks', newDeck);
  }

  // static Future<int> addDeckFlashcards(List<>) async {
  //   final db = await _openDatabase();
  // }
}
