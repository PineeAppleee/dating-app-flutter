import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Find meaningful connections",
      "text": "We focus on real relationships, not just endless swiping.",
      "icon": "favorite", 
    },
    {
      "title": "Match with people nearby",
      "text": "Discover singles in your area who are looking for the same thing.",
      "icon": "location_on",
    },
    {
      "title": "Safe & verified profiles",
      "text": "Say goodbye to bots and catfishing. Real people only.",
      "icon": "verified_user",
    },
  ];

  void _onNext() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _finishOnboarding,
                child: Text(
                  "Skip",
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey[600],
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) => OnboardingContent(
                  title: _onboardingData[index]["title"]!,
                  text: _onboardingData[index]["text"]!,
                  iconData: _getIconData(_onboardingData[index]["icon"]!),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingData.length,
                (index) => buildDot(index, theme),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 5,
                    shadowColor: AppTheme.primaryColor.withValues(alpha: 0.5),
                  ),
                  child: Text(
                    _currentPage == _onboardingData.length - 1
                        ? "Get Started"
                        : "Next",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'favorite': return Icons.favorite_rounded;
      case 'location_on': return Icons.location_on_rounded;
      case 'verified_user': return Icons.verified_user_rounded;
      default: return Icons.star_rounded;
    }
  }

  AnimatedContainer buildDot(int index, ThemeData theme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: _currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: _currentPage == index 
            ? AppTheme.primaryColor 
            : theme.disabledColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final String title, text;
  final IconData iconData;

  const OnboardingContent({
    super.key,
    required this.title,
    required this.text,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInDown(
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    iconData,
                    size: 80,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              FadeInUp(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: isDark ? Colors.white70 : Colors.grey[600],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
