import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/product/product_bloc.dart';
import '../blocs/product/product_event.dart';
import '../blocs/product/product_state.dart';
import '../constants/app_colors.dart';
import '../widgets/hero_banner.dart';
import '../widgets/category_chip.dart';
import '../widgets/shoe_card.dart';
import '../services/recommendation_service.dart';
import '../models/shoe_model.dart';
import 'package:collection/collection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> categories = ['All', 'Sneakers', 'Running', 'Casual', 'Sport'];
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sneak-Tap'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.accent));
          } else if (state is ProductError) {
            return Center(child: Text(state.message));
          } else if (state is ProductLoaded) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HeroBanner(),
                        const SizedBox(height: 24),
                        Text(
                          'Categories',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              return CategoryChip(
                                label: category,
                                isSelected: selectedCategory == category,
                                onTap: () {
                                  setState(() {
                                    selectedCategory = category;
                                  });
                                  context.read<ProductBloc>().add(FilterProducts(category));
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        FutureBuilder<String?>(
                          future: RecommendationService.getTopCategory(),
                          builder: (context, snapshot) {
                            final topCategory = snapshot.data;
                            if (topCategory == null) return const SizedBox.shrink();

                            final recommendedShoes = state.allShoes
                                .where((s) => s.category == topCategory)
                                .take(5)
                                .toList();

                            if (recommendedShoes.isEmpty) return const SizedBox.shrink();

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Recommended for You',
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  height: 240,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: recommendedShoes.length,
                                    itemBuilder: (context, index) {
                                      return SizedBox(
                                        width: 180,
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 16),
                                          child: ShoeCard(shoe: recommendedShoes[index]),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Featured',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return ShoeCard(shoe: state.filteredShoes[index]);
                      },
                      childCount: state.filteredShoes.length, // Just showing filtered here for simplicity
                    ),
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
