import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/recipe/recipe_bloc.dart';
import '../bloc/recipe/recipe_state.dart';
import 'recipe_detail/recipe_detail_screen.dart';

class RecipeDetailWrapper extends StatelessWidget {
  final String recipeId;

  const RecipeDetailWrapper({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(
      builder: (context, state) {
        if (state is RecipeLoaded) {
          try {
            final recipe = state.recipes.firstWhere((r) => r.id == recipeId);
            return RecipeDetailScreen(recipe: recipe);
          } catch (_) {
            return Scaffold(
              appBar: AppBar(title: const Text('Рецепт')),
              body: const Center(child: Text('Рецепт не найден')),
            );
          }
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Рецепт')),
          body: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
