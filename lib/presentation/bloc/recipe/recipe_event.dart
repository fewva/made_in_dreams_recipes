import 'package:equatable/equatable.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object?> get props => [];
}

class RecipeLoadRequested extends RecipeEvent {
  const RecipeLoadRequested();
}

class RecipeRefreshRequested extends RecipeEvent {
  const RecipeRefreshRequested();
}

class RecipeSearchChanged extends RecipeEvent {
  final String query;

  const RecipeSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class RecipeFilterChanged extends RecipeEvent {
  final bool? hasImage;
  final int? maxPrepTime;

  const RecipeFilterChanged({
    this.hasImage,
    this.maxPrepTime,
  });

  @override
  List<Object?> get props => [hasImage, maxPrepTime];
}

class RecipePaginationRequested extends RecipeEvent {
  const RecipePaginationRequested();
}
