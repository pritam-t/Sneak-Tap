import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../blocs/wishlist/wishlist_bloc.dart';
import '../blocs/wishlist/wishlist_event.dart';
import '../blocs/wishlist/wishlist_state.dart';
import '../models/shoe_model.dart';
import '../constants/app_colors.dart';

class ShoeCard extends StatelessWidget {
  final Shoe shoe;

  const ShoeCard({super.key, required this.shoe});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/product/${shoe.id}'),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                   Container(
                     decoration: const BoxDecoration(
                       color: AppColors.secondaryBackground,
                       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                     ),
                     child: ClipRRect(
                       borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                       child: CachedNetworkImage(
                         imageUrl: shoe.images.isNotEmpty ? shoe.images.first : '',
                         fit: BoxFit.cover,
                         placeholder: (context, url) => Center(
                           child: CircularProgressIndicator(
                             strokeWidth: 2,
                             color: AppColors.divider,
                           ),
                         ),
                         errorWidget: (context, url, error) => Center(
                           child: Icon(Icons.shopping_bag_outlined, size: 64, color: AppColors.divider),
                         ),
                       ),
                     ),
                   ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: BlocBuilder<WishlistBloc, WishlistState>(
                      builder: (context, state) {
                        bool isWishlisted = false;
                        if (state is WishlistLoaded) {
                          isWishlisted = state.isShoeInWishlist(shoe);
                        }
                        return IconButton(
                          icon: Icon(
                            isWishlisted ? Icons.favorite : Icons.favorite_border,
                            color: isWishlisted ? AppColors.error : AppColors.secondary,
                          ),
                          onPressed: () {
                            context.read<WishlistBloc>().add(ToggleWishlist(shoe));
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shoe.brand.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.accent,
                          letterSpacing: 1.2,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    shoe.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${shoe.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
