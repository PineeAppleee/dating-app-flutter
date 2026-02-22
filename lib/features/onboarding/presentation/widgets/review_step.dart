import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../onboarding_state.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/repositories/auth_repository.dart';
import '../../../../core/repositories/storage_repository.dart';

class ReviewStep extends StatefulWidget {
  const ReviewStep({super.key});

  @override
  State<ReviewStep> createState() => _ReviewStepState();
}

class _ReviewStepState extends State<ReviewStep> {
  bool _isLoading = false;

  Future<void> _completeProfile(BuildContext context, OnboardingState state) async {
    setState(() => _isLoading = true);

    try {
      final authRepo = AuthRepository();
      final storageRepo = StorageRepository();
      final user = authRepo.currentUser;

      if (user == null) {
        if (mounted) context.go('/login');
        return;
      }

      // 1. Upload Photos
      List<String> photoUrls = [];
      for (var xFile in state.photos) {
        final url = await storageRepo.uploadProfileImage(xFile, user.uid);
        photoUrls.add(url);
      }

      // 2. Prepare Data Structure (Optimized)
      final userProfile = {
        'basicInfo': {
          'name': state.name,
          'dob': state.dob != null ? Timestamp.fromDate(state.dob!) : null,
          'gender': state.gender,
          // 'bio': state.bio, // Add bio step later
        },
        'profileParams': {
          'religion': state.religion,
          // 'beliefs': state.beliefs, // Add beliefs step later
          'interests': state.interests,
          'interestedIn': state.interestedIn,
        },
        'photos': photoUrls,
        'meta': {
          'isProfileCompleted': true,
          'createdAt': FieldValue.serverTimestamp(),
          // 'location': GeoPoint(0, 0), // Use later
        }
      };

      // 3. Save to Firestore
      await authRepo.saveUserProfile(user.uid, userProfile);

      // Routing is handled automatically by GoRouter redirect
    } catch (e, stack) {
      debugPrint("❌ SAVE PROFILE ERROR: $e");
      debugPrint("Stack: $stack");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving profile: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingState>();
    final theme = Theme.of(context);

    // Default image
    dynamic mainPhoto;
    if (state.photos.isNotEmpty) {
      if (kIsWeb) {
        mainPhoto = state.photos.first.path;
      } else {
        mainPhoto = File(state.photos.first.path);
      }
    } else {
      mainPhoto = null;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          FadeInDown(
            child: Text(
              "Start Matching!",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ),
          const SizedBox(height: 8),
          FadeInUp(
            child: Text(
              "You're all set. Here's how your profile looks.",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: theme.disabledColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),

          // Profile Preview Card
          ZoomIn(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo
                  if (mainPhoto != null)
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          child: kIsWeb 
                            ? Image.network(
                                mainPhoto as String,
                                height: 300,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                mainPhoto as File,
                                height: 300,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                        ),
                        if (_isLoading)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black45,
                              child: const Center(
                                child: CircularProgressIndicator(color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    ),
                  
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${state.name}, ${state.age}",
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: theme.textTheme.bodyLarge?.color,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (state.gender == "Male")
                               const Icon(Icons.male, color: Colors.blue)
                            else if (state.gender == "Female")
                               const Icon(Icons.female, color: Colors.pink)
                          ],
                        ),
                        const SizedBox(height: 8),
                        
                        // Religion
                        if (state.religion != null && state.religion != "Prefer not to say")
                          Row(
                            children: [
                              Icon(Icons.temple_buddhist, size: 16, color: theme.disabledColor),
                              const SizedBox(width: 6),
                              Text(
                                state.religion!,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: theme.disabledColor,
                                ),
                              ),
                            ],
                          ),
                          
                         const SizedBox(height: 16),
                         // Interests
                         Wrap(
                             spacing: 8,
                             runSpacing: 8,
                             children: state.interests.take(5).map((interest) {
                                 return Container(
                                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                     decoration: BoxDecoration(
                                         color: AppTheme.primaryColor.withOpacity(0.1),
                                         borderRadius: BorderRadius.circular(12),
                                     ),
                                     child: Text(
                                         interest,
                                         style: TextStyle(
                                             color: AppTheme.primaryColor,
                                             fontSize: 12,
                                             fontWeight: FontWeight.w600,
                                         ),
                                     ),
                                 );
                             }).toList(),
                         ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Complete Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : () => _completeProfile(context, state),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
                shadowColor: AppTheme.primaryColor.withOpacity(0.5),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 24, 
                      width: 24, 
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    )
                  : Text(
                      "Complete Profile",
                      style: GoogleFonts.poppins(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
