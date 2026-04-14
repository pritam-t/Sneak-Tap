import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/product/product_bloc.dart';
import '../blocs/product/product_state.dart';
import '../blocs/wishlist/wishlist_bloc.dart';
import '../blocs/wishlist/wishlist_event.dart';
import '../blocs/wishlist/wishlist_state.dart';
import '../models/shoe_model.dart';
import '../models/cart_item_model.dart';
import '../constants/app_colors.dart';

class ProductDetailScreen extends StatefulWidget {
  final int shoeId;

  const ProductDetailScreen({super.key, required this.shoeId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? selectedSize;
  String? selectedColor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoaded) {
          final shoe = state.allShoes.firstWhere(
            (s) => s.id == widget.shoeId,
            orElse: () => state.allShoes.first,
          );

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
              title: Text(shoe.brand),
              actions: [
                BlocBuilder<WishlistBloc, WishlistState>(
                  builder: (context, wState) {
                    bool isWishlisted = false;
                    if (wState is WishlistLoaded) {
                      isWishlisted = wState.isShoeInWishlist(shoe);
                    }
                    return IconButton(
                      icon: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                        color: isWishlisted ? AppColors.error : AppColors.primary,
                      ),
                      onPressed: () {
                        context.read<WishlistBloc>().add(ToggleWishlist(shoe));
                      },
                    );
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 300,
                    width: double.infinity,
                    color: AppColors.secondaryBackground,
                    child: Center(
                      child: Icon(Icons.shopping_bag, size: 120, color: AppColors.divider),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    shoe.name,
                                    style: Theme.of(context).textTheme.displaySmall,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '\$${shoe.price.toStringAsFixed(2)}',
                                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text('Description', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(
                          shoe.description,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.secondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text('Size', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: shoe.sizes.map((size) {
                            final isSel = size == selectedSize;
                            return GestureDetector(
                              onTap: () => setState(() => selectedSize = size),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: isSel ? AppColors.primary : AppColors.surface,
                                  border: Border.all(
                                    color: isSel ? AppColors.primary : AppColors.divider,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    size,
                                    style: TextStyle(
                                      color: isSel ? Colors.white : AppColors.primary,
                                      fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        Text('Color', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: shoe.colors.map((color) {
                            final isSel = color == selectedColor;
                            return GestureDetector(
                              onTap: () => setState(() => selectedColor = color),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSel ? AppColors.primary : AppColors.surface,
                                  border: Border.all(
                                    color: isSel ? AppColors.primary : AppColors.divider,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  color,
                                  style: TextStyle(
                                    color: isSel ? Colors.white : AppColors.primary,
                                    fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (selectedSize == null || selectedColor == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Please select size and color')),
                                    );
                                    return;
                                  }
                                  context.read<CartBloc>().add(
                                    AddToCart(
                                      CartItem(
                                        shoe: shoe,
                                        size: selectedSize!,
                                        color: selectedColor!,
                                        quantity: 1,
                                      ),
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Added to Cart!')),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: const Text('Add to Cart', style: TextStyle(fontSize: 16)),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: OutlinedButton(
                                onPressed: () {
                                  context.push('/vr-tryon/${shoe.id}');
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  side: const BorderSide(color: AppColors.accent, width: 2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.view_in_ar, color: AppColors.accent),
                                    SizedBox(width: 8),
                                    Text('Try VR', style: TextStyle(color: AppColors.accent, fontSize: 16, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
