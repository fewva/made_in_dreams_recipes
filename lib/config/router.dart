import 'package:go_router/go_router.dart';
import '../presentation/screens/recipe_detail_wrapper.dart';
import '../presentation/screens/recipe_list/recipe_list_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const RecipeListScreen()),
    GoRoute(
      path: '/recipe/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return RecipeDetailWrapper(recipeId: id);
      },
    ),
  ],
);
