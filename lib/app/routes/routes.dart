import 'package:flutter/material.dart';
import 'package:unmobile/screens/array.dart';
import 'package:unmobile/screens/dashboard.dart';
import 'package:unmobile/screens/dockers.dart';
import 'package:unmobile/screens/login.dart';
import 'package:unmobile/screens/notifications.dart';
import 'package:unmobile/screens/plugins.dart';
import 'package:unmobile/screens/settings.dart';
import 'package:unmobile/screens/shares.dart';
import 'package:unmobile/screens/system.dart';
import 'package:unmobile/screens/vms.dart';

/// Application route names
class AppRoutes {
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String array = '/array';
  static const String dockers = '/dockers';
  static const String vms = '/vms';
  static const String shares = '/shares';
  static const String system = '/system';
  static const String settings = '/settings';
  static const String plugins = '/plugins';
  static const String notifications = '/notifications';
}

/// Application route configuration
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case AppRoutes.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardPage());
      case AppRoutes.array:
        return MaterialPageRoute(builder: (_) => const ArrayPage());
      case AppRoutes.dockers:
        return MaterialPageRoute(builder: (_) => const DockersPage());
      case AppRoutes.vms:
        return MaterialPageRoute(builder: (_) => const VmsPage());
      case AppRoutes.shares:
        return MaterialPageRoute(builder: (_) => const SharesPage());
      case AppRoutes.system:
        return MaterialPageRoute(builder: (_) => const SystemPage());
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case AppRoutes.plugins:
        return MaterialPageRoute(builder: (_) => const PluginsPage());
      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
