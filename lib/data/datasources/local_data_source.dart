import 'dart:convert';
import 'dart:developer';
import 'package:hive/hive.dart';
import '../models/recipe.dart';

class LocalDataSource {
  static const String _boxName = 'app_box';
  static const String _recipesKey = 'recipes';

  Future<void> saveRecipes(List<Recipe> recipes) async {
    try {
      final box = await Hive.openBox<String>(_boxName);
      final List<Map<String, dynamic>> jsonList = recipes
          .map((r) => r.toJson())
          .toList();
      await box.put(_recipesKey, jsonEncode(jsonList));
    } catch (e) {
      log('Error saving recipes: $e');
      rethrow;
    }
  }

  Future<List<Recipe>> getRecipes() async {
    try {
      final box = await Hive.openBox<String>(_boxName);
      final jsonStr = box.get(_recipesKey);

      if (jsonStr == null || jsonStr.isEmpty) return [];

      final List<dynamic> jsonList = jsonDecode(jsonStr);
      return jsonList
          .map((json) => Recipe.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      log('Error loading recipes: $e');
      return [];
    }
  }

  Future<void> clearRecipes() async {
    final box = await Hive.openBox<String>(_boxName);
    await box.delete('recipes');
  }

  Future<void> saveTheme(bool isDarkMode) async {
    final box = await Hive.openBox<String>(_boxName);
    await box.put('isDarkMode', isDarkMode.toString());
  }

  Future<bool> getTheme() async {
    try {
      final box = await Hive.openBox<String>(_boxName);
      final isDarkModeStr = box.get('isDarkMode');

      if (isDarkModeStr == null) return false;

      return isDarkModeStr == 'true';
    } catch (_) {
      return false;
    }
  }
}
