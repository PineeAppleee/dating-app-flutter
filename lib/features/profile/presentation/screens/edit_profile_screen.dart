import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/theme/app_theme.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditProfileScreen({super.key, required this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  
  // Read-only fields
  late String _gender;
  late String _dob;
  
  // Editable fields
  List<String> _interests = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final basicInfo = widget.userData['basicInfo'] ?? {};
    final profileParams = widget.userData['profileParams'] ?? widget.userData; // Fallback for old structure

    _nameController = TextEditingController(text: basicInfo['name'] ?? widget.userData['name'] ?? '');
    _bioController = TextEditingController(text: basicInfo['bio'] ?? widget.userData['bio'] ?? '');
    
    _gender = basicInfo['gender'] ?? widget.userData['gender'] ?? 'Not specified';
    
    // Handle DOB
    if (basicInfo['dob'] != null) {
        if (basicInfo['dob'] is Timestamp) {
            _dob = (basicInfo['dob'] as Timestamp).toDate().toString().split(' ')[0];
        } else {
             _dob = basicInfo['dob'].toString();
        }
    } else {
        _dob = widget.userData['dob'] ?? 'Not specified';
    }

    _interests = List<String>.from(profileParams['interests'] ?? widget.userData['interests'] ?? []);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Construct updated data preserving structure
        // We only update specific fields to avoid overwriting photos or other params
        
        final updateData = {
          'basicInfo.name': _nameController.text.trim(),
          'basicInfo.bio': _bioController.text.trim(),
          'profileParams.interests': _interests,
          // Support flat structure for backward compatibility/simplicity if needed, 
          // but best to stick to 'basicInfo' naming convention we started.
          // ALSO updating root level for easier querying if needed, or migration.
          'name': _nameController.text.trim(), 
          'bio': _bioController.text.trim(),
          'interests': _interests,
        };

        await FirebaseFirestore.instance.collection('users').doc(user.uid).update(updateData);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile Updated!")),
          );
          Navigator.pop(context, true); // Return true to trigger refresh
        }
      }
    } catch (e) {
      debugPrint("Error updating profile: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading 
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) 
                : Text("Save", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("About You"),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bioController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Bio",
                hintText: "Write something about yourself...",
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 24),
            _buildSectionTitle("Personal Info (Read-only)"),
            const SizedBox(height: 10),
            _buildReadOnlyField("Gender", _gender),
            const SizedBox(height: 10),
            _buildReadOnlyField("Date of Birth", _dob),

            const SizedBox(height: 24),
            _buildSectionTitle("Interests"),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._interests.map((e) => Chip(
                  label: Text(e),
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () {
                    setState(() => _interests.remove(e));
                  },
                )),
                ActionChip(
                  label: const Text("+ Add"),
                  onPressed: _showAddInterestDialog,
                  avatar: const Icon(Icons.add, size: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey)),
        ],
      ),
    );
  }

  void _showAddInterestDialog() {
    String newInterest = "";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Interest"),
        content: TextField(
          autofocus: true,
          onChanged: (val) => newInterest = val,
          decoration: const InputDecoration(hintText: "e.g. Photography"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (newInterest.trim().isNotEmpty) {
                setState(() => _interests.add(newInterest.trim()));
              }
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
