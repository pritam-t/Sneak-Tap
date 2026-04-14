import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/wishlist/wishlist_bloc.dart';
import '../blocs/wishlist/wishlist_state.dart';
import '../constants/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.secondaryBackground,
              child: Icon(Icons.person, size: 50, color: AppColors.secondary),
            ),
            const SizedBox(height: 16),
            Text(
              'pritam123',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Sneakerhead',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 32),
            _buildProfileItem(
              context,
              icon: Icons.shopping_bag_outlined,
              title: 'Order History',
              subtitle: '12 Orders',
              onTap: () {},
            ),
            BlocBuilder<WishlistBloc, WishlistState>(
              builder: (context, state) {
                int wishlistCount = 0;
                if (state is WishlistLoaded) {
                  wishlistCount = state.items.length;
                }
                return _buildProfileItem(
                  context,
                  icon: Icons.favorite_border,
                  title: 'Wishlist',
                  subtitle: '$wishlistCount Items',
                  onTap: () {},
                );
              },
            ),
            _buildProfileItem(
              context,
              icon: Icons.location_on_outlined,
              title: 'Shipping Addresses',
              subtitle: '2 Addresses',
              onTap: () {},
            ),
            _buildProfileItem(
              context,
              icon: Icons.payment_outlined,
              title: 'Payment Methods',
              subtitle: 'Visa ending in 4242',
              onTap: () {},
            ),
            _buildProfileItem(
              context,
              icon: Icons.settings_outlined,
              title: 'Settings',
              subtitle: 'Notifications, Privacy',
              onTap: () {},
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutRequested());
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                ),
                child: const Text('LOG OUT'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.secondaryBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right, color: AppColors.secondary),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}
