import '../models/shoe_model.dart';
import '../services/database_service.dart';

class ShoeRepository {
  final DatabaseService _dbService;

  ShoeRepository(this._dbService);

  Future<List<Shoe>> getAllShoes() async {
    final List<Map<String, dynamic>> maps = await _dbService.query('shoes');
    return maps.map((e) => Shoe.fromMap(e)).toList();
  }

  Future<Shoe?> getShoeById(int id) async {
    final List<Map<String, dynamic>> maps = await _dbService.query(
      'shoes',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Shoe.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Shoe>> getFeaturedShoes() async {
    final List<Map<String, dynamic>> maps = await _dbService.query(
      'shoes',
      where: 'is_featured = ?',
      whereArgs: [1],
    );
    return maps.map((e) => Shoe.fromMap(e)).toList();
  }

  Future<List<Shoe>> getNewArrivals() async {
    final List<Map<String, dynamic>> maps = await _dbService.query(
      'shoes',
      where: 'is_new_arrival = ?',
      whereArgs: [1],
    );
    return maps.map((e) => Shoe.fromMap(e)).toList();
  }

  Future<List<Shoe>> searchShoes(String query) async {
    final List<Map<String, dynamic>> maps = await _dbService.query(
      'shoes',
      where: 'name LIKE ? OR brand LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return maps.map((e) => Shoe.fromMap(e)).toList();
  }
}
