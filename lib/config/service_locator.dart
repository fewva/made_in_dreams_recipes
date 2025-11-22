import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import '../data/datasources/local_data_source.dart';
import '../data/datasources/remote_data_source.dart';
import '../data/repositories/recipe_repository.dart';
import '../presentation/bloc/recipe/recipe_bloc.dart';
import '../presentation/bloc/theme/theme_bloc.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();

  factory ServiceLocator() {
    return _instance;
  }

  ServiceLocator._internal();

  late Dio _dio;
  late RemoteDataSource _remoteDataSource;
  late LocalDataSource _localDataSource;
  late RecipeRepository _repository;
  late RecipeBloc _recipeBloc;
  late ThemeBloc _themeBloc;

  Future<void> setup() async {
    // Dio setup
    _dio = Dio();
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );

    // Data sources
    _remoteDataSource = RemoteDataSource(_dio);
    _localDataSource = LocalDataSource();

    // Repository
    _repository = RecipeRepository(
      remoteDataSource: _remoteDataSource,
      localDataSource: _localDataSource,
      connectivity: Connectivity(),
    );

    // BLoCs
    _recipeBloc = RecipeBloc(repository: _repository);
    _themeBloc = ThemeBloc(localDataSource: _localDataSource);
    
    // Load saved theme
    await _themeBloc.loadTheme();
  }

  RecipeBloc get recipeBloc => _recipeBloc;
  ThemeBloc get themeBloc => _themeBloc;
  RecipeRepository get repository => _repository;
}
