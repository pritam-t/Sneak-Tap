import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';

class AiService {
  // --- Visual Search (Image Labeling) ---
  
  static Future<List<String>> getLabelsForImage(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final ImageLabelerOptions options = ImageLabelerOptions(confidenceThreshold: 0.5);
    final imageLabeler = ImageLabeler(options: options);

    try {
      final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
      return labels.map((label) => label.label.toLowerCase()).toList();
    } finally {
      imageLabeler.close();
    }
  }

  // --- OCR (Text Recognition) ---

  static Future<Map<String, String>> scanCreditCard(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final textRecognizer = TextRecognizer();

    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      
      String cardNumber = '';
      String expiry = '';

      // Simple RegEx patterns for demo
      final RegExp cardRegex = RegExp(r'\b(?:\d{4}[ -]?){3}\d{4}\b');
      final RegExp expiryRegex = RegExp(r'\b\d{2}/\d{2}\b');

      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          final cardMatch = cardRegex.firstMatch(line.text);
          if (cardMatch != null && cardNumber.isEmpty) {
            cardNumber = cardMatch.group(0)!;
          }

          final expiryMatch = expiryRegex.firstMatch(line.text);
          if (expiryMatch != null && expiry.isEmpty) {
            expiry = expiryMatch.group(0)!;
          }
        }
      }

      return {
        'cardNumber': cardNumber.replaceAll(' ', '').replaceAll('-', ''),
        'expiry': expiry,
      };
    } finally {
      textRecognizer.close();
    }
  }
}
