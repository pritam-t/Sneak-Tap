import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'blocs/cart/cart_bloc.dart';
import 'blocs/cart/cart_event.dart';
import 'blocs/product/product_bloc.dart';
import 'blocs/product/product_event.dart';
import 'blocs/wishlist/wishlist_bloc.dart';
import 'blocs/wishlist/wishlist_event.dart';
import 'repositories/cart_repository.dart';
import 'repositories/shoe_repository.dart';
import 'repositories/wishlist_repository.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbService = DatabaseService();
  await dbService.init();

  final prefs = await SharedPreferences.getInstance();

  final authService = AuthService(prefs);
  final shoeRepo = ShoeRepository(dbService);
  final cartRepo = CartRepository(dbService);
  final wishlistRepo = WishlistRepository(dbService);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(authService)..add(AppStarted()),
        ),
        BlocProvider<ProductBloc>(
          create: (_) => ProductBloc(shoeRepo)..add(LoadProducts()),
        ),
        BlocProvider<CartBloc>(
          create: (_) => CartBloc(cartRepo)..add(LoadCart()),
        ),
        BlocProvider<WishlistBloc>(
          create: (_) => WishlistBloc(wishlistRepo)..add(LoadWishlist()),
        ),
      ],
      child: const SneakTapApp(),
    ),
  );
}
