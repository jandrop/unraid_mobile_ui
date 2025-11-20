import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String username;
  final String serverUrl;
  final DateTime? lastLogin;

  const User({
    required this.username,
    required this.serverUrl,
    this.lastLogin,
  });

  @override
  List<Object?> get props => [username, serverUrl, lastLogin];

  User copyWith({
    String? username,
    String? serverUrl,
    DateTime? lastLogin,
  }) {
    return User(
      username: username ?? this.username,
      serverUrl: serverUrl ?? this.serverUrl,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}
