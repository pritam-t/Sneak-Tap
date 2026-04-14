import 'shoe_model.dart';

class CartItem {
  final int? id; // nullable since it's auto-incremented by db
  final Shoe shoe;
  final String size;
  final String color;
  final int quantity;

  CartItem({
    this.id,
    required this.shoe,
    required this.size,
    required this.color,
    this.quantity = 1,
  });

  CartItem copyWith({
    int? id,
    Shoe? shoe,
    String? size,
    String? color,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      shoe: shoe ?? this.shoe,
      size: size ?? this.size,
      color: color ?? this.color,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'shoe_id': shoe.id,
      'size': size,
      'color': color,
      'quantity': quantity,
    };
  }
}
