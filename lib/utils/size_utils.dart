class SizeUtils {
  /// Maps foot length in CM to US Shoe Size
  /// Reference: Rough standard conversion for adults
  static double getRecommendedUSSize(double footLengthCm) {
    if (footLengthCm < 23) return 6.0;
    if (footLengthCm < 24) return 7.0;
    if (footLengthCm < 25) return 8.0;
    if (footLengthCm < 26) return 9.0;
    if (footLengthCm < 27) return 10.0;
    if (footLengthCm < 28) return 11.0;
    if (footLengthCm < 29) return 12.0;
    return 13.0;
  }

  /// Finds the closest available size in the shoe's size list
  static String? findClosestSize(double recommendedSize, List<String> availableSizes) {
    if (availableSizes.isEmpty) return null;
    
    String? bestMatch;
    double minDiff = 100.0;

    for (var sizeStr in availableSizes) {
      final size = double.tryParse(sizeStr);
      if (size != null) {
        final diff = (size - recommendedSize).abs();
        if (diff < minDiff) {
          minDiff = diff;
          bestMatch = sizeStr;
        }
      }
    }
    return bestMatch;
  }
}
