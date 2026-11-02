/// Constant route names and paths for the GoRouter configuration.
class RouteNames {
  // Main shell / tabs
  static const String home = '/';
  static const String today = '/today';
  static const String pantry = '/pantry';
  static const String discover = '/discover';
  static const String shopping = '/shopping';
  static const String settings = '/settings';

  // Standalone / Stack screens
  static const String onboarding = '/onboarding';
  static const String recipeDetail = '/recipe/:id';
  static const String cookMode = '/cook-mode/:id';
  static const String cookCompleted = '/cook-completed';
  static const String fridgeScanner = '/fridge-scanner';
  static const String aiInspire = '/ai-inspire';
  static const String paywall = '/paywall';

  // Helper generators for parameterized routes
  static String recipeDetailPath(String id) => '/recipe/$id';
  static String cookModePath(String id) => '/cook-mode/$id';
}
