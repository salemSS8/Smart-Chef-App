import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/mock/recipes_data.dart';
import '../../domain/models/recipe.dart';
import '../../presentation/screens/ai_inspire_screen.dart';
import '../../presentation/screens/cook_completed_screen.dart';
import '../../presentation/screens/cook_mode_screen.dart';
import '../../presentation/screens/error_screen.dart';
import '../../presentation/screens/fridge_scanner_screen.dart';
import '../../presentation/screens/main_navigation_screen.dart';
import '../../presentation/screens/onboarding_screen.dart';
import '../../presentation/screens/paywall_screen.dart';
import '../../presentation/screens/recipe_detail_screen.dart';
import 'route_names.dart';

/// Centralized GoRouter provider managed via Riverpod.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.home,
    debugLogDiagnostics: false,
    routes: [
      // 1. Root & Tab routes mapping to MainNavigationScreen
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const MainNavigationScreen(initialIndex: 0),
      ),
      GoRoute(
        path: RouteNames.today,
        builder: (context, state) => const MainNavigationScreen(initialIndex: 0),
      ),
      GoRoute(
        path: RouteNames.pantry,
        builder: (context, state) => const MainNavigationScreen(initialIndex: 1),
      ),
      GoRoute(
        path: RouteNames.discover,
        builder: (context, state) => const MainNavigationScreen(initialIndex: 2),
      ),
      GoRoute(
        path: RouteNames.shopping,
        builder: (context, state) => const MainNavigationScreen(initialIndex: 3),
      ),
      GoRoute(
        path: RouteNames.settings,
        builder: (context, state) => const MainNavigationScreen(initialIndex: 4),
      ),

      // 2. Onboarding
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // 3. Recipe details with deep link or passed object support
      GoRoute(
        path: RouteNames.recipeDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          final recipe = (state.extra is Recipe)
              ? state.extra as Recipe
              : RecipesData.allRecipes.firstWhere(
                  (r) => r.id == id,
                  orElse: () => RecipesData.allRecipes.first,
                );
          return RecipeDetailScreen(recipe: recipe);
        },
      ),

      // 4. Cook mode
      GoRoute(
        path: RouteNames.cookMode,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          final recipe = (state.extra is Recipe)
              ? state.extra as Recipe
              : RecipesData.allRecipes.firstWhere(
                  (r) => r.id == id,
                  orElse: () => RecipesData.allRecipes.first,
                );
          return CookModeScreen(recipe: recipe);
        },
      ),

      // 5. Cook completed celebration
      GoRoute(
        path: RouteNames.cookCompleted,
        builder: (context, state) {
          final recipe = (state.extra is Recipe)
              ? state.extra as Recipe
              : RecipesData.allRecipes.first;
          return CookCompletedScreen(recipe: recipe);
        },
      ),

      // 6. Camera / Fridge scanner
      GoRoute(
        path: RouteNames.fridgeScanner,
        builder: (context, state) => const FridgeScannerScreen(),
      ),

      // 7. AI Recipe Generator
      GoRoute(
        path: RouteNames.aiInspire,
        builder: (context, state) => const AiInspireScreen(),
      ),

      // 8. Paywall / Pro upgrade
      GoRoute(
        path: RouteNames.paywall,
        builder: (context, state) => const PaywallScreen(),
      ),
    ],

    // Fallback error page
    errorBuilder: (context, state) => ErrorScreen(
      errorMessage: state.error?.message,
    ),
  );
});
