import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/recipe.dart';
import '../../../data/repositories/recipe_repository.dart';
import 'recipe_event.dart';
import 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository _repository;
  static const int _pageSize = 10;

  RecipeBloc({required RecipeRepository repository})
    : _repository = repository,
      super(const RecipeInitial()) {
    on<RecipeLoadRequested>(_onLoadRequested);
    on<RecipeRefreshRequested>(_onRefreshRequested);
    on<RecipeSearchChanged>(_onSearchChanged);
    on<RecipeFilterChanged>(_onFilterChanged);
    on<RecipePaginationRequested>(_onPaginationRequested);
  }

  Future<void> _onLoadRequested(
    RecipeLoadRequested event,
    Emitter<RecipeState> emit,
  ) async {
    emit(const RecipeLoading());
    try {
      final recipes = await _repository.getRecipes();
      final isOnline = await _repository.isOnline();
      final displayedRecipes = _getDisplayedRecipes(recipes, 0, '', null, null);

      emit(
        RecipeLoaded(
          recipes: recipes,
          displayedRecipes: displayedRecipes,
          currentPage: 0,
          searchQuery: '',
          filterHasImage: null,
          filterMaxPrepTime: null,
          isOnline: isOnline,
        ),
      );
    } catch (e) {
      emit(RecipeError('Failed to load recipes: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshRequested(
    RecipeRefreshRequested event,
    Emitter<RecipeState> emit,
  ) async {
    if (state is! RecipeLoaded) {
      emit(const RecipeLoading());
    }

    try {
      final recipes = await _repository.getRecipes();
      final isOnline = await _repository.isOnline();
      final displayedRecipes = _getDisplayedRecipes(recipes, 0, '', null, null);

      emit(
        RecipeLoaded(
          recipes: recipes,
          displayedRecipes: displayedRecipes,
          currentPage: 0,
          searchQuery: '',
          filterHasImage: null,
          filterMaxPrepTime: null,
          isOnline: isOnline,
        ),
      );
    } catch (e) {
      emit(RecipeError('Failed to refresh recipes: ${e.toString()}'));
    }
  }

  Future<void> _onSearchChanged(
    RecipeSearchChanged event,
    Emitter<RecipeState> emit,
  ) async {
    if (state is! RecipeLoaded) return;

    final currentState = state as RecipeLoaded;
    final displayedRecipes = _getDisplayedRecipes(
      currentState.recipes,
      0,
      event.query,
      currentState.filterHasImage,
      currentState.filterMaxPrepTime,
    );

    emit(
      RecipeLoaded(
        recipes: currentState.recipes,
        displayedRecipes: displayedRecipes,
        currentPage: 0,
        searchQuery: event.query,
        filterHasImage: currentState.filterHasImage,
        filterMaxPrepTime: currentState.filterMaxPrepTime,
        isOnline: currentState.isOnline,
      ),
    );
  }

  Future<void> _onFilterChanged(
    RecipeFilterChanged event,
    Emitter<RecipeState> emit,
  ) async {
    if (state is! RecipeLoaded) return;

    final currentState = state as RecipeLoaded;
    final displayedRecipes = _getDisplayedRecipes(
      currentState.recipes,
      0,
      currentState.searchQuery,
      event.hasImage,
      event.maxPrepTime,
    );

    emit(
      RecipeLoaded(
        recipes: currentState.recipes,
        displayedRecipes: displayedRecipes,
        currentPage: 0,
        searchQuery: currentState.searchQuery,
        filterHasImage: event.hasImage,
        filterMaxPrepTime: event.maxPrepTime,
        isOnline: currentState.isOnline,
      ),
    );
  }

  Future<void> _onPaginationRequested(
    RecipePaginationRequested event,
    Emitter<RecipeState> emit,
  ) async {
    if (state is! RecipeLoaded) return;

    final currentState = state as RecipeLoaded;
    final nextPage = currentState.currentPage + 1;

    emit(
      RecipeLoaded(
        recipes: currentState.recipes,
        displayedRecipes: currentState.displayedRecipes,
        currentPage: nextPage,
        searchQuery: currentState.searchQuery,
        filterHasImage: currentState.filterHasImage,
        filterMaxPrepTime: currentState.filterMaxPrepTime,
        isOnline: currentState.isOnline,
      ),
    );
  }

  List<Recipe> _getDisplayedRecipes(
    List<Recipe> recipes,
    int page,
    String searchQuery,
    bool? filterHasImage,
    int? filterMaxPrepTime,
  ) {
    var filtered = recipes;

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((recipe) {
        final titleMatch = recipe.title.toLowerCase().contains(
          searchQuery.toLowerCase(),
        );
        final ingredientsMatch =
            recipe.ingredientsOne.any(
              (ing) =>
                  ing.title.toLowerCase().contains(searchQuery.toLowerCase()),
            ) ||
            recipe.ingredientsTwo.any(
              (ing) =>
                  ing.title.toLowerCase().contains(searchQuery.toLowerCase()),
            );

        return titleMatch || ingredientsMatch;
      }).toList();
    }

    // Apply image filter
    if (filterHasImage != null) {
      filtered = filtered.where((recipe) {
        if (filterHasImage) {
          return recipe.image != null && recipe.image!.isNotEmpty;
        } else {
          return recipe.image == null || recipe.image!.isEmpty;
        }
      }).toList();
    }

    // Apply prep time filter
    if (filterMaxPrepTime != null) {
      filtered = filtered.where((recipe) {
        if (recipe.prepTime == null) return false;
        try {
          final match = RegExp(r'\d+').firstMatch(recipe.prepTime!);
          if (match == null) return false;

          final prepTime = int.parse(match.group(0)!);
          return prepTime <= filterMaxPrepTime;
        } catch (_) {
          return false;
        }
      }).toList();
    }

    // Apply pagination
    final startIndex = page * _pageSize;
    final endIndex = (page + 1) * _pageSize;

    if (startIndex >= filtered.length) {
      return [];
    }

    return filtered.sublist(
      startIndex,
      endIndex > filtered.length ? filtered.length : endIndex,
    );
  }
}
