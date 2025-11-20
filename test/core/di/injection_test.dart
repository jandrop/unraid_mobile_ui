import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unmobile/core/di/injection.dart';
import 'package:unmobile/core/network/graphql_client.dart';
import 'package:unmobile/core/storage/local_storage.dart';
import 'package:unmobile/core/storage/shared_preferences_storage.dart';

void main() {
  setUp(() async {
    // Ensure clean state before each test
    await resetDependencies();
  });

  tearDown(() async {
    // Clean up after each test
    await resetDependencies();
  });

  group('Dependency Injection', () {
    test('should initialize core dependencies successfully', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});

      // Act
      await initializeDependencies();

      // Assert
      expect(sl.isRegistered<SharedPreferences>(), isTrue);
      expect(sl.isRegistered<ILocalStorage>(), isTrue);
    });

    test('should register SharedPreferences as singleton', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});

      // Act
      await initializeDependencies();

      // Assert
      final instance1 = sl<SharedPreferences>();
      final instance2 = sl<SharedPreferences>();
      expect(identical(instance1, instance2), isTrue);
    });

    test('should register ILocalStorage as singleton', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});

      // Act
      await initializeDependencies();

      // Assert
      final instance1 = sl<ILocalStorage>();
      final instance2 = sl<ILocalStorage>();
      expect(identical(instance1, instance2), isTrue);
    });

    test('should register ILocalStorage as SharedPreferencesStorage', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});

      // Act
      await initializeDependencies();

      // Assert
      final storage = sl<ILocalStorage>();
      expect(storage, isA<SharedPreferencesStorage>());
    });

    test('should not register GraphQL client during initialization', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});

      // Act
      await initializeDependencies();

      // Assert
      expect(sl.isRegistered<IGraphQLClient>(), isFalse);
    });

    test('should reset all dependencies', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      await initializeDependencies();
      expect(sl.isRegistered<SharedPreferences>(), isTrue);

      // Act
      await resetDependencies();

      // Assert
      expect(sl.isRegistered<SharedPreferences>(), isFalse);
      expect(sl.isRegistered<ILocalStorage>(), isFalse);
    });

    test('should be able to reinitialize after reset', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      await initializeDependencies();
      await resetDependencies();

      // Act
      await initializeDependencies();

      // Assert
      expect(sl.isRegistered<SharedPreferences>(), isTrue);
      expect(sl.isRegistered<ILocalStorage>(), isTrue);
    });

    test('should provide working ILocalStorage instance', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      await initializeDependencies();

      // Act
      final storage = sl<ILocalStorage>();
      await storage.setString('test_key', 'test_value');
      final value = await storage.getString('test_key');

      // Assert
      expect(value, 'test_value');
    });

    test('should handle multiple initializations gracefully', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});

      // Act
      await initializeDependencies();

      // Assert - Should throw on second initialization
      expect(
        () async => await initializeDependencies(),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('Dependency Resolution', () {
    test('should resolve dependencies in correct order', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});

      // Act
      await initializeDependencies();

      // Assert - Storage depends on SharedPreferences
      final sharedPrefs = sl<SharedPreferences>();
      final storage = sl<ILocalStorage>();
      expect(sharedPrefs, isNotNull);
      expect(storage, isNotNull);

      // Verify storage can use shared preferences
      await storage.setString('test', 'value');
      expect(sharedPrefs.getString('test'), 'value');
    });
  });

  group('GraphQL Client Initialization', () {
    test('should initialize GraphQL client with config', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      await initializeDependencies();

      final config = GraphQLConfig(
        endpoint: 'http://test.local/graphql',
        wsEndpoint: 'ws://test.local/graphql',
        apiKey: 'test-key',
        origin: 'http://test.local',
      );

      // Act
      initializeGraphQLClient(config);

      // Assert
      expect(sl.isRegistered<IGraphQLClient>(), isTrue);
      final client = sl<IGraphQLClient>();
      expect(client, isA<UnraidGraphQLClient>());
    });

    test('should replace existing GraphQL client on reinitialization',
        () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      await initializeDependencies();

      final config1 = GraphQLConfig(
        endpoint: 'http://test1.local/graphql',
        wsEndpoint: 'ws://test1.local/graphql',
        apiKey: 'key1',
        origin: 'http://test1.local',
      );

      final config2 = GraphQLConfig(
        endpoint: 'http://test2.local/graphql',
        wsEndpoint: 'ws://test2.local/graphql',
        apiKey: 'key2',
        origin: 'http://test2.local',
      );

      // Act
      initializeGraphQLClient(config1);
      final client1 = sl<IGraphQLClient>() as UnraidGraphQLClient;

      initializeGraphQLClient(config2);
      final client2 = sl<IGraphQLClient>() as UnraidGraphQLClient;

      // Assert
      expect(client1.config.apiKey, 'key1');
      expect(client2.config.apiKey, 'key2');
      expect(identical(client1, client2), isFalse);
    });

    test('should create singleton GraphQL client', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      await initializeDependencies();

      final config = GraphQLConfig(
        endpoint: 'http://test.local/graphql',
        wsEndpoint: 'ws://test.local/graphql',
        apiKey: 'test-key',
        origin: 'http://test.local',
      );

      // Act
      initializeGraphQLClient(config);

      // Assert
      final instance1 = sl<IGraphQLClient>();
      final instance2 = sl<IGraphQLClient>();
      expect(identical(instance1, instance2), isTrue);
    });
  });
}
