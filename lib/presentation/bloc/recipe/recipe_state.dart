import 'package:equatable/equatable.dart';
import '../../../data/models/recipe.dart';

abstract class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object?> get props => [];
}

class RecipeInitial extends RecipeState {
  const RecipeInitial();
}

class RecipeLoading extends RecipeState {
  const RecipeLoading();
}

class RecipeLoaded extends RecipeState {
  final List<Recipe> recipes;
  final List<Recipe> displayedRecipes;
  final int currentPage;
  final String searchQuery;
  final bool? filterHasImage;
  final int? filterMaxPrepTime;
  final bool isOnline;

  const RecipeLoaded({
    required this.recipes,
    required this.displayedRecipes,
    required this.currentPage,
    required this.searchQuery,
    this.filterHasImage,
    this.filterMaxPrepTime,
    required this.isOnline,
  });

  @override
  List<Object?> get props => [
    recipes,
    displayedRecipes,
    currentPage,
    searchQuery,
    filterHasImage,
    filterMaxPrepTime,
    isOnline,
  ];
}

class RecipeError extends RecipeState {
  final String message;

  const RecipeError(this.message);

  @override
  List<Object?> get props => [message];
}
