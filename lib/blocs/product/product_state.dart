import 'package:equatable/equatable.dart';
import '../../models/shoe_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();
  
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Shoe> allShoes;
  final List<Shoe> featuredShoes;
  final List<Shoe> newArrivals;
  final List<Shoe> filteredShoes; // used for search & category filter

  const ProductLoaded({
    required this.allShoes,
    required this.featuredShoes,
    required this.newArrivals,
    required this.filteredShoes,
  });

  @override
  List<Object?> get props => [allShoes, featuredShoes, newArrivals, filteredShoes];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}
