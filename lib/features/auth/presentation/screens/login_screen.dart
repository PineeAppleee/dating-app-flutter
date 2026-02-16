import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/repositories/auth_repository.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _onLogin(BuildContext context) async {
    debugPrint("🔘 _onLogin (Phone/Anon) called - STEP 1");
    try {
      // 1. Sign In (using anonymous for demo, replace with Google/Apple later)
      // Ideally inject repository, but for now instantiate directly or use Provider
      final authRepo = AuthRepository();
      debugPrint("Step 2: Calling signInAnonymously...");
      final credential = await authRepo.signInAnonymously();
      debugPrint("Step 3: Signed in. User: ${credential.user?.uid}");
      
      if (credential.user != null) {
        // 2. Check Database for Profile
        debugPrint("Step 4: Checking profile existence...");
        final exists = await authRepo.checkProfileExists(credential.user!.uid);
        debugPrint("Step 5: Profile exists? $exists");
        
        if (context.mounted) {
          if (exists) {
            debugPrint("Step 6: Navigating to /discover");
            context.go('/discover');
          } else {
            debugPrint("Step 6: Navigating to /profile_setup");
            context.go('/profile_setup');
          }
        } else {
          debugPrint("⚠️ Context not mounted after profile check!");
        }
      }
    } catch (e, stack) {
      debugPrint("❌ Login Error: $e");
      debugPrint("Stack: $stack");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Failed: $e")),
        );
      }
    }
  }

  Future<void> _onGoogleLogin(BuildContext context) async {
    debugPrint("🔵 _onGoogleLogin called");
    try {
      final authRepo = AuthRepository();
      // Show loading indicator or disable button here if stateful
      final credential = await authRepo.signInWithGoogle();
      
      if (!context.mounted) return;

      if (credential.user != null) {
        // Check Database for Profile
        try {
          final exists = await authRepo.checkProfileExists(credential.user!.uid);
          
          if (context.mounted) {
            if (exists) {
              context.go('/discover');
            } else {
              context.go('/profile_setup');
            }
          }
        } catch (e) {
          debugPrint("Profile Check Error: $e");
          if (context.mounted) {
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Profile Check Failed: $e")),
            );
          }
        }
      }
    } catch (e) {
      debugPrint("Google Login Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Google Login Failed: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... (build method remains same)
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                // ... (rest of build)
                const Spacer(),
              Icon(
                Icons.favorite_rounded,
                size: 80,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 20),
              Text(
                "Serious Dating",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Sign up to find your perfect match.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.grey[600],
                ),
              ),
              const Spacer(),
              _buildSocialButton(
                icon: FontAwesomeIcons.google,
                text: "Continue with Google",
                onPressed: () => _onGoogleLogin(context),
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              _buildSocialButton(
                icon: FontAwesomeIcons.apple,
                text: "Continue with Apple",
                onPressed: () => _onLogin(context),
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              _buildSocialButton(
                icon: FontAwesomeIcons.phone,
                text: "Use Phone Number",
                onPressed: () => _onLogin(context),
                isDark: isDark,
              ),
              const SizedBox(height: 40),
              Text.rich(
                TextSpan(
                  text: "By continuing, you agree to our ",
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 12,
                  ),
                  children: [
                    const TextSpan(
                      text: "Terms",
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: " and "),
                    const TextSpan(
                      text: "Privacy Policy",
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
    required bool isDark,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        foregroundColor: isDark ? Colors.white : Colors.black87,
      ),
      icon: FaIcon(icon, size: 20),
      label: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
