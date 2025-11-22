import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import '../datasources/local_data_source.dart';
import '../datasources/remote_data_source.dart';
import '../models/recipe.dart';

class RecipeRepository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  final Connectivity _connectivity;

  RecipeRepository({
    required RemoteDataSource remoteDataSource,
    required LocalDataSource localDataSource,
    required Connectivity connectivity,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _connectivity = connectivity;

  Future<List<Recipe>> getRecipes() async {
    try {
      try {
        final connectivityResult = await _connectivity.checkConnectivity();
        final isOnline = connectivityResult != ConnectivityResult.none;

        if (isOnline) {
          final recipes = await _remoteDataSource.getRecipes();
          await _localDataSource.saveRecipes(recipes);
          return recipes;
        }
      } catch (e) {
        log('Error fetching remote recipes: $e');
      }

      final localRecipes = await _localDataSource.getRecipes();
      if (localRecipes.isNotEmpty) {
        return localRecipes;
      }

      throw Exception('No internet connection and no local data available');
    } catch (e) {
      log('Error in getRecipes: $e');
      return _localDataSource.getRecipes();
    }
  }

  Future<bool> isOnline() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
