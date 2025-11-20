import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Authentication state model
class AuthState {
  final bool isAuthenticated;
  final String? token;

  const AuthState({
    required this.isAuthenticated,
    this.token,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? token,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      token: token ?? this.token,
    );
  }
}

/// Auth state notifier
class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier() : super(const AuthState(isAuthenticated: false)) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    final serverUrl = prefs.getString('serverUrl');

    if (token != null && serverUrl != null) {
      state = AuthState(isAuthenticated: true, token: token);
    }
  }

  Future<void> login(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
    state = AuthState(isAuthenticated: true, token: token);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('serverUrl');
    state = const AuthState(isAuthenticated: false);
  }
}

/// Global auth state provider
final authState = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier();
});
