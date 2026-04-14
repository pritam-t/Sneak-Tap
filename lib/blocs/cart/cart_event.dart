import 'package:equatable/equatable.dart';
import '../../models/cart_item_model.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {}

class AddToCart extends CartEvent {
  final CartItem item;

  const AddToCart(this.item);

  @override
  List<Object?> get props => [item];
}

class UpdateCartQuantity extends CartEvent {
  final int cartItemId;
  final int quantity;

  const UpdateCartQuantity(this.cartItemId, this.quantity);

  @override
  List<Object?> get props => [cartItemId, quantity];
}

class RemoveFromCart extends CartEvent {
  final int cartItemId;

  const RemoveFromCart(this.cartItemId);

  @override
  List<Object?> get props => [cartItemId];
}

class ClearCart extends CartEvent {}
