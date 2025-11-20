import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unmobile/app/routes/routes.dart';
import 'package:unmobile/app/theme/app_theme.dart';
import 'package:unmobile/global/auth_state.dart';
import 'package:unmobile/screens/dashboard.dart';
import 'package:unmobile/screens/login.dart';

/// Main application widget
/// Configures theme, routing, and authentication state
class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateValue = ref.watch(authState);

    return MaterialApp(
      title: 'Unraid Mobile',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      onGenerateRoute: AppRouter.generateRoute,
      home: authStateValue.isAuthenticated
          ? const MyDashboardPage()
          : const MyLoginPage(),
    );
  }
}
