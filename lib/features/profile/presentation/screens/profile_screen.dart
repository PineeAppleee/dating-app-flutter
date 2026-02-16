import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/repositories/auth_repository.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final authRepo = AuthRepository();
    final user = authRepo.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists && mounted) {
           setState(() {
             _userData = doc.data();
             _isLoading = false;
           });
        }
      } catch (e) {
        debugPrint("Error fetching profile: $e");
         if (mounted) setState(() => _isLoading = false);
      }
    } else {
        if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_userData == null) {
      return const Scaffold(body: Center(child: Text("Profile not found")));
    }
    
    final name = _userData!['name'] ?? 'User';
    // Calculate age from DOB if available, else Mock
    final dobStr = _userData!['dob'];
    int age = 25;
    if (dobStr != null) {
        try {
            final dob = DateTime.parse(dobStr);
            final now = DateTime.now();
            age = now.year - dob.year;
             if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
                age--;
            }
        } catch (_) {}
    }

    final location = _userData!['location'] ?? 'Unknown Location';
    final bio = _userData!['bio'] ?? 'No bio yet.';
    final interests = List<String>.from(_userData!['interests'] ?? []);
    final photoUrls = List<String>.from(_userData!['photoUrls'] ?? []);
    final mainPhoto = photoUrls.isNotEmpty ? photoUrls.first : null;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: mainPhoto != null
                  ? (mainPhoto.startsWith('http')
                      ? Image.network(mainPhoto, fit: BoxFit.cover)
                      : Image.file(File(mainPhoto), fit: BoxFit.cover))
                  : Container(color: Colors.grey),
            ),
            actions: [
               IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {},
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.3),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    children: [
                      Text(
                        "$name, $age",
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.verified, color: Colors.blue, size: 24),
                    ],
                  ),
                  Text(
                    location,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Stats Row (Mock for now)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem("Matches", "0"),
                      _buildStatItem("Likes", "0"),
                      _buildStatItem("Visits", "0"),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),

                  Text(
                    "About",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    bio,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey, // Adjust for dark mode if needed
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    "Interests",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: interests.map((interest) {
                      return Chip(
                        label: Text(interest),
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                        side: const BorderSide(color: AppTheme.primaryColor),
                        labelStyle: const TextStyle(color: AppTheme.primaryColor),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  
                  // Settings Actions
                  _buildSettingsTile(Icons.person, "Edit Profile", () {}),
                  _buildSettingsTile(Icons.photo_library, "Change Photos", () {}),
                  _buildSettingsTile(Icons.tune, "Preferences", () {}),
                  _buildSettingsTile(Icons.privacy_tip, "Privacy Settings", () {}),
                  const SizedBox(height: 20),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                          await AuthRepository().signOut();
                          // Navigate to Login/Splash
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.withOpacity(0.1),
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text("Logout"),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppTheme.primaryColor, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    );
  }
}
