import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../onboarding_state.dart';
import '../../../../core/theme/app_theme.dart';

class InterestsStep extends StatelessWidget {
  const InterestsStep({super.key});

  static const List<String> _allInterests = [
    "Gym", "Fitness", "Yoga", "Running", "Hiking",
    "Music", "Concerts", "Festivals", "Spotify",
    "Movies", "Netflix", "Anime", "K-Drama",
    "Travel", "Road trips", "Camping", "Beach",
    "Coding", "Tech", "Design", "Startups",
    "Foodie", "Cooking", "Coffee", "Sushi", "Pizza",
    "Spirituality", "Meditation", "Astrology",
    "Gaming", "Board Games",
    "Photography", "Art", "Museums",
    "Reading", "Writing",
    "Dogs", "Cats",
    "Fashion", "Shopping"
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingState>();
    final theme = Theme.of(context);

    // Filter logic can be added here if search bar is implemented
    // For now, just show all
    
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "What are you into?",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Pick at least 3 interests to help us find people with similar vibes.",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: theme.disabledColor,
                  ),
                ),
                 const SizedBox(height: 16),
                
                // Search Bar Placeholder (Visual only for now or simple implementation)
                TextField(
                    decoration: InputDecoration(
                        hintText: "Search interests",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: theme.cardColor,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (value) {
                        // TODO: Implement search filter
                    },
                ),
                const SizedBox(height: 24),

                // Interests Cloud
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _allInterests.map((interest) {
                    final isSelected = state.interests.contains(interest);
                    return FilterChip(
                      label: Text(
                        interest,
                        style: TextStyle(
                          color: isSelected ? Colors.white : theme.textTheme.bodyLarge?.color,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppTheme.primaryColor,
                      backgroundColor: theme.cardColor,
                      onSelected: (selected) {
                        state.toggleInterest(interest);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? Colors.transparent : theme.disabledColor.withOpacity(0.3),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      showCheckmark: false, // Clean look
                    );
                  }).toList(),
                ),
                // Add some bottom padding so content isn't hidden behind button if absolute positioned
                const SizedBox(height: 100), 
              ],
            ),
          ),
        ),
        
        // Fixed Bottom Button Area
        Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: state.isInterestsValid ? state.nextStep : null,
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
                        "Continue (${state.interests.length}/3)",
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                    ),
                ),
            ),
        ),
      ],
    );
  }
}
