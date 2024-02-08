import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../models/books.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _databaseName = 'shareitems.db';
  static Logger logger = Logger();

  static Future<Database> _getDB() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, _databaseName);

    return await openDatabase(
      path,
      version: _version,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE books(id INTEGER PRIMARY KEY, title TEXT, author TEXT, genre TEXT, quantity INTEGER, reserved INTEGER)');
        await db.execute(
            'CREATE TABLE books(id INTEGER PRIMARY KEY, title TEXT)');
        logger.d("Database created successfully");
      },
      onUpgrade: (db, oldVersion, newVersion) {
        // Handle database upgrades here
        logger.d("Database upgraded from version $oldVersion to $newVersion");
      },
    );
  }

  // get all books
  static Future<List<Book>> getBooks() async {
    logger.log(Level.info, "here");
    final db = await _getDB();
    final result = await db.query('books');
    logger.log(Level.info, "getBooks: $result");

    // Print each book separately
    for (var book in result) {
      logger.log(Level.info, "Book: $book");
    }

    return result.map((e) => Book.fromJson(e)).toList();
  }


  // update books in database
  static Future<void> updateBooks(List<Book> books) async {
    final db = await _getDB();
    await db.delete('books');
    for (var i = 0; i < books.length; i++) {
      await db.insert('books', books[i].toJson()); // Convert Book to Map using toJson()
    }
    logger.log(Level.info, "updateBooks: $books");
  }

  // add item
  static Future<Book> addItem(Book item) async {
    final db = await _getDB();
    final id = await db.insert('books', item.toJsonWithoutId(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    logger.log(Level.info, "addBook: $id");
    return item.copy(id: id);
  }
}
