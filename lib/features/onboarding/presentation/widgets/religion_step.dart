import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../onboarding_state.dart';
import '../../../../core/theme/app_theme.dart';

class ReligionStep extends StatelessWidget {
  const ReligionStep({super.key});

  static const List<String> _religions = [
    "Hindu", "Muslim", "Christian", "Sikh", 
    "Buddhist", "Jain", "Jewish", 
    "Atheist", "Spiritual", "Agnostic",
    "Prefer not to say"
  ];

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
            "Religion & Beliefs",
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "This helps us find matches with similar values. You can skip this if you prefer.",
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: theme.disabledColor,
            ),
          ),
          const SizedBox(height: 32),

          // Religion Selection List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _religions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final religion = _religions[index];
              final isSelected = state.religion == religion;
              
              return InkWell(
                onTap: () => state.setReligion(religion),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryColor : theme.disabledColor.withOpacity(0.1),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        religion,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? AppTheme.primaryColor : theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle, color: AppTheme.primaryColor),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 40),

          // Buttons
          Row(
             children: [
                 Expanded(
                     child: TextButton(
                         onPressed: state.nextStep,
                         child: Text(
                             "Skip",
                             style: TextStyle(
                                 color: theme.disabledColor,
                                 fontSize: 16,
                             ),
                         ),
                     ),
                 ),
                 const SizedBox(width: 16),
                 Expanded(
                     flex: 2,
                     child: ElevatedButton(
                         onPressed: state.nextStep, // Can always proceed even if null
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
        ],
      ),
    );
  }
}
