import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/repositories/auth_repository.dart';
import 'phone_login_sheet.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _onPhoneLogin(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const PhoneLoginSheet(),
    );
  }

  Future<void> _onAppleLogin(BuildContext context) async {
    debugPrint("🍎 _onAppleLogin called");
    try {
      final authRepo = AuthRepository();
      final credential = await authRepo.signInWithApple();

      if (!context.mounted) return;

      if (credential.user != null) {
        final exists = await authRepo.checkProfileExists(credential.user!.uid);
        if (context.mounted) {
           if (exists) {
             context.go('/discover');
           } else {
             context.go('/profile_setup');
           }
        }
      }
    } catch (e) {
      debugPrint("Apple Login Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Apple Login Failed: $e")),
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
          SnackBar(
            content: Text("Google Login Failed: $e"),
            duration: const Duration(seconds: 10), // Show for longer
            action: SnackBarAction(
              label: "Copy Error",
              onPressed: () {
                // Optional: helper to copy if needed
              },
            ),
          ),
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
                onPressed: () => _onAppleLogin(context),
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              _buildSocialButton(
                icon: FontAwesomeIcons.phone,
                text: "Use Phone Number",
                onPressed: () => _onPhoneLogin(context),
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
