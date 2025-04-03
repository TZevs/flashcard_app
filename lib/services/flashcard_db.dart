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
      CREATE TABLE IF NOT EXISTS decks(
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
}