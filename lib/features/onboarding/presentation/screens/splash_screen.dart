import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    
    if (!mounted) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
          // Check profile
          final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
          if (!mounted) return;
          
          if (doc.exists) {
              context.go('/discover');
          } else {
              context.go('/profile_setup');
          }
      } else {
          if (mounted) context.go('/login'); 
      }
    } catch (e) {
      if (!mounted) return;
      debugPrint("SplashScreen Error: $e");
      // Show error to user
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text("Initialization Error"),
          content: Text("An error occurred while starting the app:\n$e"),
          actions: [
            TextButton(
              onPressed: () {
                // Retry
                Navigator.pop(context);
                _navigateToNext();
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInDown(
              duration: const Duration(seconds: 1),
              child: const Icon(
                Icons.favorite_rounded,
                size: 100,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            FadeInUp(
              duration: const Duration(seconds: 1),
              child: Text(
                'Serious Dating',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            FadeInUp(
              delay: const Duration(milliseconds: 500),
              duration: const Duration(seconds: 1),
              child: Text(
                'Find your forever match',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
