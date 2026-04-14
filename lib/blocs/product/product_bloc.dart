import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/shoe_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ShoeRepository _shoeRepo;

  ProductBloc(this._shoeRepo) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<SearchProducts>(_onSearchProducts);
    on<FilterProducts>(_onFilterProducts);
  }

  Future<void> _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final allShoes = await _shoeRepo.getAllShoes();
      final featured = await _shoeRepo.getFeaturedShoes();
      final newArrivals = await _shoeRepo.getNewArrivals();

      emit(ProductLoaded(
        allShoes: allShoes,
        featuredShoes: featured,
        newArrivals: newArrivals,
        filteredShoes: allShoes,
      ));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onSearchProducts(SearchProducts event, Emitter<ProductState> emit) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      try {
        final searchResults = await _shoeRepo.searchShoes(event.query);
        emit(ProductLoaded(
          allShoes: currentState.allShoes,
          featuredShoes: currentState.featuredShoes,
          newArrivals: currentState.newArrivals,
          filteredShoes: searchResults,
        ));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    }
  }

  Future<void> _onFilterProducts(FilterProducts event, Emitter<ProductState> emit) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      try {
        List<dynamic> filtered = currentState.allShoes;
        if (event.category != 'All') {
          filtered = currentState.allShoes
              .where((shoe) => shoe.category == event.category)
              .toList();
        }
        
        emit(ProductLoaded(
          allShoes: currentState.allShoes,
          featuredShoes: currentState.featuredShoes,
          newArrivals: currentState.newArrivals,
          filteredShoes: filtered.cast(),
        ));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    }
  }
}
