import '../models/cart_item_model.dart';
import '../models/shoe_model.dart';
import '../services/database_service.dart';

class CartRepository {
  final DatabaseService _dbService;

  CartRepository(this._dbService);

  Future<List<CartItem>> getCartItems() async {
    final List<Map<String, dynamic>> maps = await _dbService.rawQuery('''
      SELECT c.*, 
             s.id as shoe_id, s.name, s.brand, s.price, s.category, 
             s.description, s.sizes, s.colors, s.images, 
             s.is_featured, s.is_new_arrival
      FROM cart_items c
      JOIN shoes s ON c.shoe_id = s.id
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
      return CartItem(
        id: e['id'], // cart_item id
        shoe: shoe,
        size: e['size'],
        color: e['color'],
        quantity: e['quantity'],
      );
    }).toList();
  }

  Future<int> addToCart(CartItem item) async {
    // Check if item with same shoe, size, and color exists
    final List<Map<String, dynamic>> existing = await _dbService.query(
      'cart_items',
      where: 'shoe_id = ? AND size = ? AND color = ?',
      whereArgs: [item.shoe.id, item.size, item.color],
    );

    if (existing.isNotEmpty) {
      // Update quantity
      final newQuantity = (existing.first['quantity'] as int) + item.quantity;
      return await _dbService.update(
        'cart_items',
        {'quantity': newQuantity},
        where: 'id = ?',
        whereArgs: [existing.first['id']],
      );
    } else {
      // Insert new
      return await _dbService.insert('cart_items', {
        'shoe_id': item.shoe.id,
        'size': item.size,
        'color': item.color,
        'quantity': item.quantity,
      });
    }
  }

  Future<int> updateQuantity(int cartItemId, int newQuantity) async {
    if (newQuantity <= 0) {
      return await removeFromCart(cartItemId);
    }
    return await _dbService.update(
      'cart_items',
      {'quantity': newQuantity},
      where: 'id = ?',
      whereArgs: [cartItemId],
    );
  }

  Future<int> removeFromCart(int cartItemId) async {
    return await _dbService.delete(
      'cart_items',
      where: 'id = ?',
      whereArgs: [cartItemId],
    );
  }

  Future<void> clearCart() async {
    await _dbService.delete('cart_items');
  }
}
