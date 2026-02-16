import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../onboarding_state.dart';
import '../../../../core/theme/app_theme.dart';

class IdentityStep extends StatefulWidget {
  const IdentityStep({super.key});

  @override
  State<IdentityStep> createState() => _IdentityStepState();
}

class _IdentityStepState extends State<IdentityStep> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final state = Provider.of<OnboardingState>(context, listen: false);
    _nameController = TextEditingController(text: state.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, OnboardingState state) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: state.dob ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != state.dob) {
      state.setDob(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingState>();
    final theme = Theme.of(context);

    // Sync controller if state changes externally (optional but good practice)
    if (_nameController.text != state.name) {
       _nameController.text = state.name;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's start with the basics",
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tell us a bit about yourself so we can find the best matches for you.",
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: theme.disabledColor,
            ),
          ),
          const SizedBox(height: 32),

          // Name Input
          Text(
            "My name is",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            onChanged: state.setName,
            decoration: InputDecoration(
              hintText: "Enter your full name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: theme.cardColor,
            ),
          ),
          const SizedBox(height: 24),

          // DOB Input
          Text(
            "My birthday is",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _selectDate(context, state),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: theme.disabledColor.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12),
                color: theme.cardColor,
              ),
              child: Row(
                children: [
                   Icon(Icons.calendar_today, color: theme.disabledColor),
                   const SizedBox(width: 12),
                   Text(
                     state.dob == null
                         ? "MM / DD / YYYY"
                         : "${state.dob!.month}/${state.dob!.day}/${state.dob!.year} (${state.age} y/o)",
                     style: GoogleFonts.poppins(
                       fontSize: 16,
                       color: state.dob == null ? theme.disabledColor : theme.textTheme.bodyLarge?.color,
                     ),
                   ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Gender Selection
          Text(
            "I identify as",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: ["Male", "Female", "Non-binary", "Prefer not to say"].map((gender) {
              final isSelected = state.gender == gender;
              return ChoiceChip(
                label: Text(
                  gender,
                  style: TextStyle(
                    color: isSelected ? Colors.white : theme.textTheme.bodyLarge?.color,
                  ),
                ),
                selected: isSelected,
                selectedColor: AppTheme.primaryColor,
                backgroundColor: theme.cardColor,
                onSelected: (selected) {
                  if (selected) state.setGender(gender);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? Colors.transparent : theme.disabledColor.withOpacity(0.3),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                showCheckmark: false,
              );
            }).toList(),
          ),

          const SizedBox(height: 40),

          // Next Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.isIdentityValid ? () {
                  FocusScope.of(context).unfocus(); // Ensure keyboard closed
                  state.nextStep();
              } : null,
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
