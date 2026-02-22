import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/providers/auth_notifier.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  try {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.macOS) {
      debugPrint("Skip GoogleSignIn macOS");
    } else {
      await GoogleSignIn.instance.initialize();
    }
  } catch (e) {
    debugPrint("GoogleSignIn init error: $e");
  }

  final authNotifier = AuthNotifier();
  final router = AppRouter.createRouter(authNotifier);

  runApp(
    ChangeNotifierProvider.value(
      value: authNotifier,
      child: SeriousDatingApp(router: router),
    ),
  );
}

class SeriousDatingApp extends StatelessWidget {
  final GoRouter router;
  const SeriousDatingApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Serious Dating',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}