import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstract interface for checking network connectivity
abstract class INetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

/// Implementation of network info using connectivity_plus
class NetworkInfo implements INetworkInfo {
  final Connectivity connectivity;

  NetworkInfo(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return _isConnected(result);
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return connectivity.onConnectivityChanged.map(_isConnected);
  }

  bool _isConnected(List<ConnectivityResult> results) {
    return results.any((result) =>
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.ethernet);
  }
}
