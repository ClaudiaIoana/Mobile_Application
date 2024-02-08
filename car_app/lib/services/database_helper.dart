import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../models/cars.dart';

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
            'CREATE TABLE cars(id INTEGER PRIMARY KEY, name TEXT, supplier TEXT, details TEXT, status TEXT, quantity INTEGER, type TEXT)');
        logger.d("Database created successfully");
      },
      onUpgrade: (db, oldVersion, newVersion) {
        // Handle database upgrades here
        logger.d("Database upgraded from version $oldVersion to $newVersion");
      },
    );
  }


  // get all cars
  static Future<List<Car>> getCars() async {
    logger.log(Level.info, "here");
    final db = await _getDB();
    final result = await db.query('cars');
    logger.log(Level.info, "getCars: $result");

    // Print each car separately
    for (var car in result) {
      logger.log(Level.info, "Car: $car");
    }

    return result.map((e) => Car.fromJson(e)).toList();
  }


  // update cars in database
  static Future<void> updateCars(List<Car> cars) async {
    final db = await _getDB();
    await db.delete('cars');
    for (var i = 0; i < cars.length; i++) {
      await db.insert('cars', cars[i].toJson());
    }
    logger.log(Level.info, "updateCars: $cars");
  }

  // add item
  static Future<Car> addItem(Car item) async {
    final db = await _getDB();
    final id = await db.insert('cars', item.toJsonWithoutId(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    logger.log(Level.info, "addCar: $id");
    return item.copy(id: id);
  }


}
