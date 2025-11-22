import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/recipe/recipe_bloc.dart';
import '../../bloc/recipe/recipe_event.dart';
import '../../bloc/recipe/recipe_state.dart';
import '../../widgets/recipe_card.dart';
import '../../widgets/recipe_filters.dart';
import '../../widgets/theme_toggle.dart';
import 'widgets/recipe_list_error.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  late ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context.read<RecipeBloc>().add(const RecipeLoadRequested());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      context.read<RecipeBloc>().add(const RecipePaginationRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          if (state is RecipeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RecipeError) {
            return RecipeListError(message: state.message);
          }

          if (state is RecipeLoaded) {
            return _buildLoadedState(context, state);
          }

          return const Center(child: Text('Рецепты не найдены'));
        },
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, RecipeLoaded state) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final searchFillColor = isDark
        ? theme.colorScheme.surfaceContainerHighest
        : const Color(0xFFF2F4F7);

    return RefreshIndicator(
      onRefresh: () async {
        context.read<RecipeBloc>().add(const RecipeRefreshRequested());
      },
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.surface,
            titleSpacing: 16,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Рецепты',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const ThemeToggle(),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Поиск по рецептам...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: searchFillColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (query) {
                      context.read<RecipeBloc>().add(
                        RecipeSearchChanged(query),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  RecipeFilters(
                    onFilterChanged: (hasImage, maxPrepTime) {
                      context.read<RecipeBloc>().add(
                        RecipeFilterChanged(
                          hasImage: hasImage,
                          maxPrepTime: maxPrepTime,
                        ),
                      );
                    },
                  ),
                  if (!state.isOnline)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.cloud_off,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSecondaryContainer,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Оффлайн режим · показаны сохраненные рецепты',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSecondaryContainer,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (state.displayedRecipes.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      size: 64,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Рецепты не найдены',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final recipe = state.displayedRecipes[index];
                  return RecipeCard(
                    recipe: recipe,
                    onTap: () {
                      context.push('/recipe/${recipe.id}');
                    },
                  );
                }, childCount: state.displayedRecipes.length),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: state.displayedRecipes.isNotEmpty
                  ? Text(
                      'Показано ${state.displayedRecipes.length} рецептов',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
