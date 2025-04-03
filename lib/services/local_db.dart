import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDb {

	static Future<Database> _openDatabase() async {
		final database_path = await getDatabasesPath();
		final database_file = join(database_path, 'flashcardDecks.db');
		return openDatabase(database_file, version: 1, onCreate: createDatabase);
	} 

	static Future<void> createDatabase(Database db, int version) async {
		String sql = 'CREATE TABLE IF NOT EXISTS flashcardDecks()';
		db.execute(sql);
	}
}