import 'package:flutter_test/flutter_test.dart';
import 'package:unmobile/core/network/graphql_client.dart';

void main() {
  group('GraphQLConfig', () {
    test('should create config with all parameters', () {
      const config = GraphQLConfig(
        endpoint: 'https://192.168.1.1/graphql',
        wsEndpoint: 'wss://192.168.1.1/graphql',
        apiKey: 'test-key',
        origin: 'com.example.app',
        allowInsecureCertificates: true,
      );

      expect(config.endpoint, 'https://192.168.1.1/graphql');
      expect(config.wsEndpoint, 'wss://192.168.1.1/graphql');
      expect(config.apiKey, 'test-key');
      expect(config.origin, 'com.example.app');
      expect(config.allowInsecureCertificates, true);
    });

    test('should create config from HTTP connection', () {
      final config = GraphQLConfig.fromConnection(
        ip: '192.168.1.1',
        protocol: 'http',
        apiKey: 'test-key',
        origin: 'com.example.app',
      );

      expect(config.endpoint, 'http://192.168.1.1/graphql');
      expect(config.wsEndpoint, 'ws://192.168.1.1/graphql');
      expect(config.apiKey, 'test-key');
      expect(config.origin, 'com.example.app');
      expect(config.allowInsecureCertificates, false);
    });

    test('should create config from HTTPS connection', () {
      final config = GraphQLConfig.fromConnection(
        ip: '192.168.1.1',
        protocol: 'https',
        apiKey: 'test-key',
        origin: 'com.example.app',
      );

      expect(config.endpoint, 'https://192.168.1.1/graphql');
      expect(config.wsEndpoint, 'wss://192.168.1.1/graphql');
      expect(config.allowInsecureCertificates, false);
    });

    test('should create config from HTTPS insecure connection', () {
      final config = GraphQLConfig.fromConnection(
        ip: '192.168.1.1',
        protocol: 'https_insecure',
        apiKey: 'test-key',
        origin: 'com.example.app',
      );

      expect(config.endpoint, 'https://192.168.1.1/graphql');
      expect(config.wsEndpoint, 'wss://192.168.1.1/graphql');
      expect(config.allowInsecureCertificates, true);
    });

    test('should default allowInsecureCertificates to false', () {
      const config = GraphQLConfig(
        endpoint: 'https://192.168.1.1/graphql',
        wsEndpoint: 'wss://192.168.1.1/graphql',
        apiKey: 'test-key',
        origin: 'com.example.app',
      );

      expect(config.allowInsecureCertificates, false);
    });
  });

  group('UnraidGraphQLClient', () {
    test('should create client with config', () {
      const config = GraphQLConfig(
        endpoint: 'https://192.168.1.1/graphql',
        wsEndpoint: 'wss://192.168.1.1/graphql',
        apiKey: 'test-key',
        origin: 'com.example.app',
      );

      final client = UnraidGraphQLClient(config);

      expect(client.config, config);
      expect(client.client, isNotNull);
    });

    test('should dispose without errors', () {
      const config = GraphQLConfig(
        endpoint: 'https://192.168.1.1/graphql',
        wsEndpoint: 'wss://192.168.1.1/graphql',
        apiKey: 'test-key',
        origin: 'com.example.app',
      );

      final client = UnraidGraphQLClient(config);

      expect(() => client.dispose(), returnsNormally);
    });
  });
}
