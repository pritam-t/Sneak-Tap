import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RecommendationService {
  static const String _keyViews = 'category_views';

  // Log a view for a specific category
  static Future<void> logCategoryView(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final String? viewsJson = prefs.getString(_keyViews);
    Map<String, int> views = {};

    if (viewsJson != null) {
      views = Map<String, int>.from(json.decode(viewsJson));
    }

    views[category] = (views[category] ?? 0) + 1;
    await prefs.setString(_keyViews, json.encode(views));
  }

  // Get the most viewed category
  static Future<String?> getTopCategory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? viewsJson = prefs.getString(_keyViews);
    
    if (viewsJson == null) return null;

    final Map<String, dynamic> views = json.decode(viewsJson);
    if (views.isEmpty) return null;

    String? topCategory;
    int maxViews = -1;

    views.forEach((category, count) {
      if (count is int && count > maxViews) {
        maxViews = count;
        topCategory = category;
      }
    });

    return topCategory;
  }
  
  // Reset for demo purposes if needed
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyViews);
  }
}
