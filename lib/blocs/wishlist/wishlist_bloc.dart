import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/wishlist_repository.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepository _wishlistRepo;

  WishlistBloc(this._wishlistRepo) : super(WishlistInitial()) {
    on<LoadWishlist>(_onLoadWishlist);
    on<ToggleWishlist>(_onToggleWishlist);
  }

  Future<void> _onLoadWishlist(LoadWishlist event, Emitter<WishlistState> emit) async {
    emit(WishlistLoading());
    try {
      final items = await _wishlistRepo.getWishlist();
      emit(WishlistLoaded(items: items));
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  Future<void> _onToggleWishlist(ToggleWishlist event, Emitter<WishlistState> emit) async {
    try {
      await _wishlistRepo.toggleWishlist(event.shoe);
      add(LoadWishlist()); // Re-load to get latest
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }
}
