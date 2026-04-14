import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';

class VrTryOnScreen extends StatelessWidget {
  final int shoeId;

  const VrTryOnScreen({super.key, required this.shoeId});

  Future<void> _launchSnapLens(BuildContext context) async {
    // Demo Nike Sneaker Try-On Lens URL
    final Uri url = Uri.parse(
      'https://www.snapchat.com/unlock/?type=SNAPCODE&uuid=b4b7264a974041b18126d40ff424de81&metadata=01',
    );
    
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error launching Snapchat: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Virtual Try-On'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.secondaryBackground,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.divider, width: 2),
                ),
                child: const Icon(
                  Icons.view_in_ar,
                  size: 100,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Ready to Try?',
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'POWERED BY SNAPCHAT',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Experience these sneakers on your feet right now! We'll open a special Snapchat Lens where you can see the 3D model and check the fit in AR.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.secondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _launchSnapLens(context),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('LAUNCH SNAP LENS'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Maybe Later'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
