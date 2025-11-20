import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unmobile/app/routes/routes.dart';
import 'package:unmobile/app/theme/app_theme.dart';
import 'package:unmobile/notifiers/auth_state.dart';
import 'package:unmobile/screens/dashboard.dart';
import 'package:unmobile/screens/login.dart';

/// Main application widget
/// Configures theme, routing, and authentication state
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthState>(
      builder: (context, authState, _) {
        if (!authState.initialized) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return MaterialApp(
          title: 'Unraid Mobile',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          onGenerateRoute: AppRouter.generateRoute,
          home: authState.client != null
              ? const DashboardPage()
              : const LoginPage(),
        );
      },
    );
  }
}
