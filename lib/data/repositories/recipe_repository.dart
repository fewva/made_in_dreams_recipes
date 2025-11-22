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
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _connectivity = connectivity;

  Future<List<Recipe>> getRecipes() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      final isOnline = connectivityResult != ConnectivityResult.none;

      if (isOnline) {
        final recipes = await _remoteDataSource.getRecipes();
        await _localDataSource.saveRecipes(recipes);
        return recipes;
      } else {
        return await _localDataSource.getRecipes();
      }
    } catch (e) {
      // Fallback to local cache on error
      return await _localDataSource.getRecipes();
    }
  }

  Future<bool> isOnline() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
