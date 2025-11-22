import 'package:hive/hive.dart';
import '../models/recipe.dart';

class LocalDataSource {
  static const String _boxName = 'app_box';

  Future<void> saveRecipes(List<Recipe> recipes) async {
    final box = await Hive.openBox<String>(_boxName);
    final jsonList = recipes.map((r) => recipeToJson(r)).toList();
    await box.put('recipes', jsonList.toString());
  }

  Future<List<Recipe>> getRecipes() async {
    try {
      final box = await Hive.openBox<String>(_boxName);
      final jsonStr = box.get('recipes');
      
      if (jsonStr == null) return [];
      
      // For now, return empty list - proper JSON parsing would be needed
      return [];
    } catch (_) {
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
