import '../models/shoe_model.dart';
import '../models/wishlist_item_model.dart';
import '../services/database_service.dart';

class WishlistRepository {
  final DatabaseService _dbService;

  WishlistRepository(this._dbService);

  Future<List<WishlistItem>> getWishlist() async {
    final List<Map<String, dynamic>> maps = await _dbService.rawQuery('''
      SELECT w.*, 
             s.id as shoe_id, s.name, s.brand, s.price, s.category, 
             s.description, s.sizes, s.colors, s.images, 
             s.is_featured, s.is_new_arrival
      FROM wishlist w
      JOIN shoes s ON w.shoe_id = s.id
    ''');

    return maps.map((e) {
      final shoe = Shoe(
        id: e['shoe_id'],
        name: e['name'],
        brand: e['brand'],
        price: e['price'],
        category: e['category'],
        description: e['description'],
        sizes: (e['sizes'] as String).split(','),
        colors: (e['colors'] as String).split(','),
        images: (e['images'] as String).split(','),
        isFeatured: e['is_featured'] == 1,
        isNewArrival: e['is_new_arrival'] == 1,
      );
      return WishlistItem(
        id: e['id'],
        shoe: shoe,
      );
    }).toList();
  }

  Future<bool> isInWishlist(int shoeId) async {
    final List<Map<String, dynamic>> maps = await _dbService.query(
      'wishlist',
      where: 'shoe_id = ?',
      whereArgs: [shoeId],
    );
    return maps.isNotEmpty;
  }

  Future<int> toggleWishlist(Shoe shoe) async {
    final inList = await isInWishlist(shoe.id);
    
    if (inList) {
      return await _dbService.delete(
        'wishlist',
        where: 'shoe_id = ?',
        whereArgs: [shoe.id],
      );
    } else {
      return await _dbService.insert('wishlist', {
        'shoe_id': shoe.id,
      });
    }
  }
}
