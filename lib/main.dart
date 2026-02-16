import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Prepare Google Sign-In (required for v7+)
  // We don't await the result of initialize unless we need to catch errors,
  // but it returns Future<void>. It's safer to await it.
  try {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.macOS) {
      debugPrint("Skipping GoogleSignIn init on macOS to prevent crash (missing Info.plist config)");
    } else {
      await GoogleSignIn.instance.initialize();
    }
  } catch (e) {
    debugPrint("GoogleSignIn initialize failed: $e");
  }
  
  runApp(const SeriousDatingApp());
}

class SeriousDatingApp extends StatelessWidget {
  const SeriousDatingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Serious Dating',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
