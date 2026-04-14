import 'shoe_model.dart';

class WishlistItem {
  final int? id;
  final Shoe shoe;

  WishlistItem({
    this.id,
    required this.shoe,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'shoe_id': shoe.id,
    };
  }
}
