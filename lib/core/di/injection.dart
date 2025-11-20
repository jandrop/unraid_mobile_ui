import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/graphql_client.dart';
import '../storage/local_storage.dart';
import '../storage/shared_preferences_storage.dart';
import '../utils/logger.dart';

final sl = GetIt.instance;

/// Initialize all dependencies
Future<void> initializeDependencies() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Core - Utils
  sl.registerLazySingleton<AppLogger>(() => AppLogger());

  // Core - Storage
  sl.registerLazySingleton<ILocalStorage>(
    () => SharedPreferencesStorage(sl()),
  );

  // Core - Network (will be configured later with actual config)
  // Note: GraphQL client needs configuration from storage/auth
  // This will be initialized after login
}

/// Initialize GraphQL client with configuration
void initializeGraphQLClient(GraphQLConfig config) {
  if (sl.isRegistered<IGraphQLClient>()) {
    sl.unregister<IGraphQLClient>();
  }

  sl.registerLazySingleton<IGraphQLClient>(
    () => UnraidGraphQLClient(config),
  );
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await sl.reset();
}
