import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart';
import '../utils/seed_data.dart';
import '../models/shoe_model.dart';
import '../models/cart_item_model.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    const dbName = 'sneaktap_database.db';

    Future<void> onCreate(Database db, int version) async {
      await db.execute('''
        CREATE TABLE shoes (
          id INTEGER PRIMARY KEY,
          name TEXT,
          brand TEXT,
          price REAL,
          category TEXT,
          description TEXT,
          sizes TEXT,
          colors TEXT,
          images TEXT,
          is_featured INTEGER,
          is_new_arrival INTEGER
        )
      ''');

      await db.execute('''
        CREATE TABLE cart_items (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          shoe_id INTEGER,
          size TEXT,
          color TEXT,
          quantity INTEGER,
          FOREIGN KEY(shoe_id) REFERENCES shoes(id)
        )
      ''');

      await db.execute('''
        CREATE TABLE wishlist (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          shoe_id INTEGER UNIQUE,
          FOREIGN KEY(shoe_id) REFERENCES shoes(id)
        )
      ''');

      // Seed data
      final batch = db.batch();
      for (var shoeMap in seedShoes) {
        batch.insert('shoes', shoeMap);
      }
      await batch.commit();
    }

    if (kIsWeb) {
      // Use web-specific factory for sqflite
      var factory = databaseFactoryFfiWeb;
      return await factory.openDatabase(
        dbName,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: onCreate,
        ),
      );
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: onCreate,
    );
  }

  Future<void> init() async {
    await database; // Trigger init
  }
}
