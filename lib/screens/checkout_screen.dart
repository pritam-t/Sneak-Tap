import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/ai_service.dart';
import '../constants/app_colors.dart';
import 'package:go_router/go_router.dart';

class CheckoutScreen extends StatefulWidget {
  final double totalAmount;

  const CheckoutScreen({super.key, required this.totalAmount});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _nameController = TextEditingController();
  final _cvvController = TextEditingController();

  bool _isScanning = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _nameController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _scanCard() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() => _isScanning = true);
      try {
        final data = await AiService.scanCreditCard(image.path);
        setState(() {
          if (data['cardNumber']!.isNotEmpty) {
            _cardNumberController.text = data['cardNumber']!;
          }
          if (data['expiry']!.isNotEmpty) {
            _expiryController.text = data['expiry']!;
          }
          _isScanning = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Card scanned successfully!')),
          );
        }
      } catch (e) {
        setState(() => _isScanning = false);
        debugPrint('Scan Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Details',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              const Text('Enter your card details or use the AI scanner.'),
              const SizedBox(height: 32),
              
              // Card Number Field with Scan Button
              TextFormField(
                controller: _cardNumberController,
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  hintText: '1234 5678 1234 5678',
                  suffixIcon: IconButton(
                    icon: Icon(_isScanning ? Icons.sync : Icons.camera_alt, color: AppColors.accent),
                    onPressed: _scanCard,
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _expiryController,
                      decoration: const InputDecoration(
                        labelText: 'Expiry Date',
                        hintText: 'MM/YY',
                      ),
                      validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _cvvController,
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        hintText: '123',
                      ),
                      obscureText: true,
                      validator: (value) => (value == null || value.length < 3) ? 'Invalid' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Cardholder Name',
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
              ),
              
              const SizedBox(height: 48),
              
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.secondaryBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total to Pay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(
                      '\$${widget.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
                          content: const Text(
                            'Payment Successful!\nThank you for shopping with Sneak-Tap.',
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                context.go('/home');
                              },
                              child: const Text('BACK TO HOME'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('PAY NOW'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
