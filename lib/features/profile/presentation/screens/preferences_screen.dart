import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/app_theme.dart';

class PreferencesScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const PreferencesScreen({super.key, required this.userData});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  // Preferences
  List<String> _interestedIn = [];
  RangeValues _ageRange = const RangeValues(18, 50);
  double _distance = 50;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final profileParams = widget.userData['profileParams'] ?? widget.userData;

    // Load Interested In
    // It could be List<dynamic> from Firestore, so we cast safely
    if (profileParams['interestedIn'] != null) {
      _interestedIn = List<String>.from(profileParams['interestedIn']);
    }

    // Load Age Range (if exists, else default)
    if (profileParams['ageRange'] != null) {
      final start = profileParams['ageRange']['start'] ?? 18.0;
      final end = profileParams['ageRange']['end'] ?? 50.0;
      _ageRange = RangeValues(start.toDouble(), end.toDouble());
    }
    
    // Load Distance
    if (profileParams['distance'] != null) {
      _distance = profileParams['distance'].toDouble();
    }
  }

  Future<void> _savePreferences() async {
    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final updateData = {
          'profileParams.interestedIn': _interestedIn,
          'profileParams.ageRange': {
            'start': _ageRange.start,
            'end': _ageRange.end,
          },
          'profileParams.distance': _distance,
          
          // Legacy/root support
          'interestedIn': _interestedIn,
        };

        await FirebaseFirestore.instance.collection('users').doc(user.uid).update(updateData);
        
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Preferences Saved!")));
           Navigator.pop(context, true);
        }
      }
    } catch (e) {
      debugPrint("Error saving preferences: $e");
         if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
        }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preferences"),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _savePreferences,
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
            _buildSectionHeader("Interested In"),
            const SizedBox(height: 10),
            _buildGenderOption("Men"),
            _buildGenderOption("Women"),
            _buildGenderOption("Non-binary"),
            
            const SizedBox(height: 30),
            _buildSectionHeader("Age Range (${_ageRange.start.round()} - ${_ageRange.end.round()})"),
            RangeSlider(
              values: _ageRange,
              min: 18,
              max: 60,
              divisions: 42,
              activeColor: AppTheme.primaryColor,
              labels: RangeLabels(
                _ageRange.start.round().toString(),
                _ageRange.end.round().toString(),
              ),
              onChanged: (values) {
                setState(() {
                  _ageRange = values;
                });
              },
            ),
             const Center(child: Text("Age preference for matches")),

            const SizedBox(height: 30),
            _buildSectionHeader("Maximum Distance (${_distance.round()} km)"),
            Slider(
              value: _distance,
              min: 5,
              max: 200,
              divisions: 39, // 5km steps
              activeColor: AppTheme.primaryColor,
              label: "${_distance.round()} km",
              onChanged: (val) {
                setState(() => _distance = val);
              },
            ),
             const Center(child: Text("Search radius")),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16, 
        fontWeight: FontWeight.bold,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildGenderOption(String label) {
    final isSelected = _interestedIn.contains(label);
    return CheckboxListTile(
      title: Text(label),
      value: isSelected,
      activeColor: AppTheme.primaryColor,
      onChanged: (val) {
        setState(() {
          if (val == true) {
            _interestedIn.add(label);
          } else {
            _interestedIn.remove(label);
          }
        });
      },
      contentPadding: EdgeInsets.zero,
    );
  }
}
