import 'package:equatable/equatable.dart';
import '../../models/wishlist_item_model.dart';
import '../../models/shoe_model.dart';

abstract class WishlistState extends Equatable {
  const WishlistState();
  
  @override
  List<Object?> get props => [];
}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<WishlistItem> items;

  const WishlistLoaded({required this.items});

  bool isShoeInWishlist(Shoe shoe) {
    return items.any((item) => item.shoe.id == shoe.id);
  }

  @override
  List<Object?> get props => [items];
}

class WishlistError extends WishlistState {
  final String message;

  const WishlistError(this.message);

  @override
  List<Object?> get props => [message];
}
