import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mid/presentation/screens/recipe_detail/widgets/recipe_energy_section.dart';
import 'package:mid/presentation/screens/recipe_detail/widgets/recipe_ingredient_section.dart';
import 'package:mid/presentation/screens/recipe_detail/widgets/recipe_step_card.dart';
import '../../../data/models/recipe.dart';
import '../../widgets/theme_toggle.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            actions: const [ThemeToggle()],
            flexibleSpace: FlexibleSpaceBar(background: _buildImageSection()),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (recipe.prepTime != null && recipe.prepTime!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${recipe.prepTime}',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                  if (recipe.text != null && recipe.text!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Описание',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          recipe.text!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  if (recipe.ingredientsOne.isNotEmpty ||
                      recipe.ingredientsTwo.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (recipe.ingredientsOne.isNotEmpty)
                          RecipeIngredientSection(
                            sectionTitle: 'Основные ингредиенты',
                            ingredients: recipe.ingredientsOne,
                          ),
                        if (recipe.ingredientsTwo.isNotEmpty)
                          RecipeIngredientSection(
                            sectionTitle: 'Дополнительные ингредиенты',
                            ingredients: recipe.ingredientsTwo,
                          ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  if (recipe.steps.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Шаги',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        ...recipe.steps.asMap().entries.map((entry) {
                          final index = entry.key + 1;
                          final step = entry.value;
                          return RecipeStepCard(index: index, step: step);
                        }),
                        const SizedBox(height: 24),
                      ],
                    ),
                  if (recipe.energy.isNotEmpty)
                    RecipeEnergySection(recipe: recipe),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    if (recipe.image != null && recipe.image!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: recipe.image!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey.shade300,
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey.shade300,
          child: const Icon(Icons.image_not_supported),
        ),
      );
    }
    return Container(
      color: Colors.grey.shade300,
      child: const Icon(Icons.image_not_supported),
    );
  }
}
