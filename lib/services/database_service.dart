import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart';
import '../utils/seed_data.dart';

class DatabaseService {
  static Database? _database;
  
  // In-memory fallback for Web if sqflite fails
  final Map<String, List<Map<String, dynamic>>> _mockDb = {};
  bool _useMock = false;

  Future<Database?> get _db async {
    if (_useMock) return null;
    try {
      if (_database != null) return _database!;
      _database = await _initDB();
      return _database!;
    } catch (e) {
      debugPrint('Database initialization failed, switching to Mock mode: $e');
      _useMock = true;
      _initMockDb();
      return null;
    }
  }

  void _initMockDb() {
    _mockDb['shoes'] = List.from(seedShoes);
    _mockDb['cart_items'] = [];
    _mockDb['wishlist'] = [];
    debugPrint('Mock database initialized with ${seedShoes.length} shoes');
  }

  Future<Database> _initDB() async {
    const dbName = 'sneaktap_database.db';

    Future<void> onCreate(Database db, int version) async {
      await _createTables(db);
      await _seedData(db);
    }

    if (kIsWeb) {
      // On web, we attempt to use sqflite_ffi_web, but if it fails (missing wasm),
      // the catch block in the `_db` getter will trigger Mock mode.
      final factory = databaseFactoryFfiWeb;
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

  // --- High-level methods for repositories ---

  Future<List<Map<String, dynamic>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final liveDb = await _db;
    if (liveDb != null) {
      return await liveDb.query(
        table,
        distinct: distinct,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );
    }

    // Mock implementation
    debugPrint('Mock Query on $table');
    var results = _mockDb[table] ?? [];
    
    // Simple filtering for 'id = ?' or 'shoe_id = ?' common in this app
    if (where != null && whereArgs != null) {
      if (where.contains('id = ?')) {
        results = results.where((item) => item['id'] == whereArgs[0]).toList();
      } else if (where.contains('shoe_id = ?')) {
        results = results.where((item) => item['shoe_id'] == whereArgs[0]).toList();
      }
    }
    
    return results;
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    final liveDb = await _db;
    if (liveDb != null) {
      return await liveDb.insert(table, values);
    }

    debugPrint('Mock Insert on $table');
    final list = _mockDb[table] ?? [];
    final newId = list.length + 1;
    final newValue = Map<String, dynamic>.from(values);
    if (!newValue.containsKey('id')) {
      newValue['id'] = newId;
    }
    list.add(newValue);
    _mockDb[table] = list;
    return newId;
  }

  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final liveDb = await _db;
    if (liveDb != null) {
      return await liveDb.update(table, values, where: where, whereArgs: whereArgs);
    }

    debugPrint('Mock Update on $table');
    // Minimal mock update for cart quantity
    if (table == 'cart_items' && where != null && whereArgs != null) {
      final list = _mockDb[table] ?? [];
      for (var i = 0; i < list.length; i++) {
        if (list[i]['id'] == whereArgs[0]) {
          list[i] = {...list[i], ...values};
        }
      }
    }
    return 1;
  }

  Future<int> delete(String table, {String? where, List<Object?>? whereArgs}) async {
    final liveDb = await _db;
    if (liveDb != null) {
      return await liveDb.delete(table, where: where, whereArgs: whereArgs);
    }

    debugPrint('Mock Delete on $table');
    if (where != null && whereArgs != null) {
      final list = _mockDb[table] ?? [];
      list.removeWhere((item) => item['id'] == whereArgs[0]);
    } else {
      _mockDb[table] = [];
    }
    return 1;
  }

  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<Object?>? arguments]) async {
    final liveDb = await _db;
    if (liveDb != null) {
      return await liveDb.rawQuery(sql, arguments);
    }

    debugPrint('Mock rawQuery: $sql');
    // Hardcoded support for the JOIN query in CartRepository
    if (sql.contains('FROM cart_items c JOIN shoes s')) {
      final cart = _mockDb['cart_items'] ?? [];
      final shoes = _mockDb['shoes'] ?? [];
      
      return cart.map((c) {
        final shoe = shoes.firstWhere((s) => s['id'] == c['shoe_id'], orElse: () => {});
        final result = Map<String, dynamic>.from(c);
        shoe.forEach((key, value) {
          if (key == 'id') {
            result['shoe_id'] = value;
          } else {
            result[key] = value;
          }
        });
        return result;
      }).toList();
    }

    if (sql.toLowerCase().contains('select count(*) from shoes')) {
      return [{'count(*)': _mockDb['shoes']?.length ?? 0}];
    }
    
    return [];
  }

  Future<void> _createTables(Database db) async {
    // ... (rest of the table creation code)
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
  }

  Future<void> _seedData(Database db) async {
    final batch = db.batch();
    for (var shoeMap in seedShoes) {
      batch.insert('shoes', shoeMap);
    }
    await batch.commit();
  }

  Future<Database?> get database => _db;

  Future<void> init() async {
    try {
      // Check if we need to re-seed (e.g. if we added more shoes to seed_data)
      final results = await rawQuery('SELECT COUNT(*) FROM shoes');
      final count = results.isNotEmpty ? results.first.values.first as int : 0;
      
      if (count < seedShoes.length) {
        debugPrint('Re-seeding database: found $count shoes, expected ${seedShoes.length}');
        // Re-seed: clear and insert all
        await delete('cart_items'); 
        await delete('wishlist');
        await delete('shoes');
        
        for (var shoeMap in seedShoes) {
          await insert('shoes', shoeMap);
        }
      }
    } catch (e) {
      debugPrint('DatabaseService.init() failed: $e');
    }
  }
}
