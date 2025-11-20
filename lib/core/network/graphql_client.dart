import 'dart:io';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/io_client.dart';

/// Configuration for GraphQL client
class GraphQLConfig {
  final String endpoint;
  final String wsEndpoint;
  final String apiKey;
  final String origin;
  final bool allowInsecureCertificates;

  const GraphQLConfig({
    required this.endpoint,
    required this.wsEndpoint,
    required this.apiKey,
    required this.origin,
    this.allowInsecureCertificates = false,
  });

  /// Create config from IP and protocol
  factory GraphQLConfig.fromConnection({
    required String ip,
    required String protocol,
    required String apiKey,
    required String origin,
  }) {
    final isHttps = protocol == 'https' || protocol == 'https_insecure';
    final allowInsecure = protocol == 'https_insecure';

    return GraphQLConfig(
      endpoint: '${isHttps ? 'https' : 'http'}://$ip/graphql',
      wsEndpoint: '${isHttps ? 'wss' : 'ws'}://$ip/graphql',
      apiKey: apiKey,
      origin: origin,
      allowInsecureCertificates: allowInsecure,
    );
  }
}

/// Abstract interface for GraphQL operations
abstract class IGraphQLClient {
  Future<QueryResult> query(QueryOptions options);
  Future<QueryResult> mutate(MutationOptions options);
  Stream<QueryResult> subscribe(SubscriptionOptions options);
  void dispose();
}

/// Implementation of GraphQL client for Unraid API
class UnraidGraphQLClient implements IGraphQLClient {
  late GraphQLClient _client;
  final GraphQLConfig config;

  UnraidGraphQLClient(this.config) {
    _client = _createClient();
  }

  GraphQLClient _createClient() {
    final httpLink = HttpLink(
      config.endpoint,
      defaultHeaders: {
        'Origin': config.origin,
        'x-api-key': config.apiKey,
      },
      httpClient: _getHttpClient(),
    );

    final wsLink = WebSocketLink(
      config.wsEndpoint,
      config: SocketClientConfig(
        autoReconnect: true,
        initialPayload: {
          'Origin': config.origin,
          'x-api-key': config.apiKey,
        },
      ),
      subProtocol: GraphQLProtocol.graphqlTransportWs,
    );

    final link = Link.split(
      (request) => request.isSubscription,
      wsLink,
      httpLink,
    );

    return GraphQLClient(
      link: link,
      cache: GraphQLCache(),
    );
  }

  IOClient _getHttpClient() {
    final httpClient = HttpClient();
    if (config.allowInsecureCertificates) {
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    }
    return IOClient(httpClient);
  }

  @override
  Future<QueryResult> query(QueryOptions options) async {
    return await _client.query(options);
  }

  @override
  Future<QueryResult> mutate(MutationOptions options) async {
    return await _client.mutate(options);
  }

  @override
  Stream<QueryResult> subscribe(SubscriptionOptions options) {
    return _client.subscribe(options);
  }

  @override
  void dispose() {
    // GraphQL client doesn't need explicit disposal
    // but we provide this for interface completeness
  }

  /// Get the underlying GraphQL client
  GraphQLClient get client => _client;
}
