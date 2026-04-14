import 'package:equatable/equatable.dart';
import '../../models/shoe_model.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object?> get props => [];
}

class LoadWishlist extends WishlistEvent {}

class ToggleWishlist extends WishlistEvent {
  final Shoe shoe;

  const ToggleWishlist(this.shoe);

  @override
  List<Object?> get props => [shoe];
}
