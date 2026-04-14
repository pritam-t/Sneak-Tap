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

  DatabaseService? dbService;
  AuthService? authService;
  ShoeRepository? shoeRepo;
  CartRepository? cartRepo;
  WishlistRepository? wishlistRepo;
  SharedPreferences? prefs;

  try {
    dbService = DatabaseService();
    // We try to init, but if it fails (common on web without wasm), 
    // we continue so the app doesn't stay blank.
    await dbService.init().timeout(const Duration(seconds: 5), onTimeout: () {
      debugPrint('Database initialization timed out');
    });
  } catch (e) {
    debugPrint('Database initialization failed: $e');
  }

  try {
    prefs = await SharedPreferences.getInstance();
    authService = AuthService(prefs);
    shoeRepo = ShoeRepository(dbService ?? DatabaseService()); 
    cartRepo = CartRepository(dbService ?? DatabaseService());
    wishlistRepo = WishlistRepository(dbService ?? DatabaseService());
  } catch (e) {
    debugPrint('Service initialization failed: $e');
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(authService ?? AuthService(prefs!))..add(AppStarted()),
        ),
        BlocProvider<ProductBloc>(
          create: (_) => ProductBloc(shoeRepo!)..add(LoadProducts()),
        ),
        BlocProvider<CartBloc>(
          create: (_) => CartBloc(cartRepo!)..add(LoadCart()),
        ),
        BlocProvider<WishlistBloc>(
          create: (_) => WishlistBloc(wishlistRepo!)..add(LoadWishlist()),
        ),
      ],
      child: const SneakTapApp(),
    ),
  );
}
