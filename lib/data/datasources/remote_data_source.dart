import 'dart:convert';

import 'package:dio/dio.dart';
import '../models/recipe.dart';

class RemoteDataSource {
  final Dio _dio;
  static const String _baseUrl =
      'https://madeindream.com/index.php?route=api/app';

  RemoteDataSource(this._dio) {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  Future<List<Recipe>> getRecipes() async {
    try {
      final response = await _dio.get('/getRecipes');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse =
             jsonDecode(response.data) as Map<String, dynamic>;
        final List<dynamic> data = jsonResponse['news'] ?? [];
        
        return data
            .map((json) => Recipe.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Failed to load recipes');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error loading recipes: $e');
    }
  }
}
