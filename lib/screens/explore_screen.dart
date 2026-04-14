import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/product/product_bloc.dart';
import '../blocs/product/product_event.dart';
import '../blocs/product/product_state.dart';
import '../constants/app_colors.dart';
import '../widgets/shoe_card.dart';
import '../services/ai_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _runVisualSearch() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () async {
                final res = await picker.pickImage(source: ImageSource.camera);
                if (mounted) Navigator.pop(context, res);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from Gallery'),
              onTap: () async {
                final res = await picker.pickImage(source: ImageSource.gallery);
                if (mounted) Navigator.pop(context, res);
              },
            ),
          ],
        ),
      ),
    );

    if (image != null) {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(child: CircularProgressIndicator()),
        );
      }

      try {
        final labels = await AiService.getLabelsForImage(image.path);
        
        // Match labels to our categories
        String? bestCategory;
        if (labels.contains('sneaker') || labels.contains('shoe')) {
          // If it's a shoe, try to find a sub-category label
          if (labels.contains('running')) bestCategory = 'Running';
          else if (labels.contains('athletic')) bestCategory = 'Sport';
          else bestCategory = 'Sneakers';
        }

        if (mounted) Navigator.pop(context); // Close loading

        if (bestCategory != null) {
          if (mounted) {
            context.read<ProductBloc>().add(FilterProducts(bestCategory));
            _searchController.text = bestCategory;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Found matching category: $bestCategory')),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No matching sneaker category found.')),
            );
          }
        }
      } catch (e) {
        if (mounted) Navigator.pop(context);
        debugPrint('Visual Search Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                context.read<ProductBloc>().add(SearchProducts(value));
              },
              decoration: InputDecoration(
                hintText: 'Search sneakers...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: _runVisualSearch,
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProductLoaded) {
                  if (state.filteredShoes.isEmpty) {
                    return const Center(child: Text('No sneakers found.'));
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: state.filteredShoes.length,
                    itemBuilder: (context, index) {
                      return ShoeCard(shoe: state.filteredShoes[index]);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
