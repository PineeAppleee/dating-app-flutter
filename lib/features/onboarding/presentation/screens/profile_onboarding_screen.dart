import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../onboarding_state.dart';
import '../widgets/identity_step.dart';
import '../widgets/interested_in_step.dart';
import '../widgets/interests_step.dart';
import '../widgets/photos_step.dart';
import '../widgets/religion_step.dart';
import '../widgets/review_step.dart';
import '../../../../core/theme/app_theme.dart';

class ProfileOnboardingScreen extends StatelessWidget {
  const ProfileOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingState(),
      child: const _ProfileOnboardingContent(),
    );
  }
}

class _ProfileOnboardingContent extends StatefulWidget {
  const _ProfileOnboardingContent();

  @override
  State<_ProfileOnboardingContent> createState() => _ProfileOnboardingContentState();
}

class _ProfileOnboardingContentState extends State<_ProfileOnboardingContent> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingState>();

    // Sync PageController with State
    // We use a post-frame callback to ensure the PageView is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients && 
          _pageController.page?.round() != state.currentStep) {
        
        // Ensure keyboard is dismissed to avoid layout issues during transition
        FocusScope.of(context).unfocus();

        _pageController.animateToPage(
          state.currentStep,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Custom Progress Bar
            _buildProgressBar(context, state),
            
            // Main Content
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                // Using distinct keys for steps might help if rebuilds are an issue, 
                // but const constructors usually sufficient.
                children: const [
                  IdentityStep(),
                  InterestedInStep(),
                  InterestsStep(),
                  PhotosStep(),
                  ReligionStep(),
                  ReviewStep(),
                ],
                onPageChanged: (index) {
                   // State is managed by provider, handled by nextStep()
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, OnboardingState state) {
    final theme = Theme.of(context);
    final progress = (state.currentStep + 1) / state.totalSteps;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (state.currentStep > 0)
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  onPressed: state.previousStep,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: theme.disabledColor,
                )
              else
                const SizedBox(width: 20),
              
              Text(
                "Step ${state.currentStep + 1} of ${state.totalSteps}",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: theme.disabledColor,
                ),
              ),
              
              // Placeholder for Skip button if we want one efficiently
               const SizedBox(width: 20),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: theme.disabledColor.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
