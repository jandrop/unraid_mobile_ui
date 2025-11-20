import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unmobile/app/app.dart';
import 'package:unmobile/core/di/injection.dart';
import 'package:unmobile/notifiers/auth_state.dart';
import 'package:unmobile/notifiers/theme_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await initializeDependencies();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthState()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: const App(),
    ),
  );
}
