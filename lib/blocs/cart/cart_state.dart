import 'package:equatable/equatable.dart';
import '../../models/cart_item_model.dart';

abstract class CartState extends Equatable {
  const CartState();
  
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;

  const CartLoaded({required this.items});

  double get subtotal => items.fold(0, (total, current) => total + (current.shoe.price * current.quantity));
  double get total => subtotal > 0 ? subtotal + 10.0 : 0; // Flat $10 shipping if cart not empty

  @override
  List<Object?> get props => [items];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}
