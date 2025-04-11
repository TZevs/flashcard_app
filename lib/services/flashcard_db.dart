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
      CREATE TABLE decks (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        isPublic BOOLEAN NOT NULL,
        cardCount INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE flashcards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        deckId TEXT NOT NULL,
        cardFront TEXT NOT NULL,
        cardBack TEXT NOT NULL,
        FOREIGN KEY (deckId) REFERENCES decks (id) ON DELETE CASCADE
      )
    ''');
  }

  static Future<void> deleteDatabaseFile() async {
    final databasePath = await getDatabasesPath();
    final databaseFile = join(databasePath, 'flashcardDatabase.db');
    await deleteDatabase(databaseFile);
  }

  static Future<void> getAllCards() async {
    final db = await _openDatabase();
    final cards = await db.query('flashcards');
    print("Flashcards: $cards");
    print(cards.length);
  }

  static Future<List<DeckModel>> getDecks() async {
    final db = await _openDatabase();
    final List<Map<String, dynamic>> decks = await db.query('decks');

    return List.generate(decks.length, (i) {
      return DeckModel.fromMap(decks[i]);
    });
  }

  static Future<List<FlashcardModel>> getDeckFlashcards(String deckID) async {
    final db = await _openDatabase();
    final cards =
        await db.query('flashcards', where: 'deckId=?', whereArgs: [deckID]);
    print("Queried Flashcards: $cards");
    return cards.map((card) => FlashcardModel.fromMap(card)).toList();
    // final List<Map<String, dynamic>> cards = await db.rawQuery(
    //   'SELECT * FROM flashcards WHERE deckId = ?',
    //   [deckID],
    // );
    // final List<Map<String, dynamic>> cards =
    //     await db.query('flashcards', where: 'deckId=?', whereArgs: [deckID]);

    // print("Queried Flashcards: $cards");

    // return List.generate(cards.length, (i) {
    //   return FlashcardModel.fromMap(cards[i]);
    // });
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

    // List<Map<String, dynamic>> addCards =
    //     cards.map((card) => card.toMap()).toList();

    // Batch batch = db.batch();

    // for (int i = 0; i < addCards.length; i++) {
    //   batch.insert('flashcards', addCards[i]);
    // }

    // // Inserts all records at once
    // List<dynamic> results = await batch.commit();
    // return results.length;
  }

  static Future<int> deleteDeck(String deckID) async {
    final db = await _openDatabase();
    return await db.delete('decks', where: 'id=?', whereArgs: [deckID]);
  }
}
