import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../onboarding_state.dart';
import '../../../../core/theme/app_theme.dart';

class InterestedInStep extends StatelessWidget {
  const InterestedInStep({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingState>();
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Who are you interested in?",
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Select everyone you're open to meeting. You can change this later.",
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: theme.disabledColor,
            ),
          ),
          const SizedBox(height: 32),

          // Gender Preference Selection
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: ["Men", "Women", "Everyone"].map((gender) {
              final isSelected = state.interestedIn.contains(gender);
              return FilterChip(
                label: Text(
                  gender,
                  style: TextStyle(
                    color: isSelected ? Colors.white : theme.textTheme.bodyLarge?.color,
                    fontSize: 16,
                  ),
                ),
                selected: isSelected,
                selectedColor: AppTheme.primaryColor,
                backgroundColor: theme.cardColor,
                onSelected: (selected) {
                  if (gender == "Everyone") {
                     if (selected) {
                       // If everyone selected, maybe clear others or handle logic in provider?
                       // For simplicity let's just use toggle logic in provider but standard behavior usually implies logic for 'Everyone'
                       // Here just treat it as an option
                     }
                  }
                  state.toggleInterestedIn(gender);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(
                    color: isSelected ? Colors.transparent : theme.disabledColor.withOpacity(0.3),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                showCheckmark: false,
                 avatar: isSelected ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
              );
            }).toList(),
          ),

          const SizedBox(height: 40),

          // Next Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.isInterestedInValid ? state.nextStep : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: Text(
                "Continue",
                style: GoogleFonts.poppins(
                  fontSize: 16, 
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
