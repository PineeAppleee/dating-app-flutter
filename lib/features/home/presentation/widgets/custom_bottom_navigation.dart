import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_theme.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Center(
        heightFactor: 1,
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              // Swipe Left -> Next Tab
              if (selectedIndex < 4) onItemTapped(selectedIndex + 1);
            } else if (details.primaryVelocity! > 0) {
              // Swipe Right -> Previous Tab
              if (selectedIndex > 0) onItemTapped(selectedIndex - 1);
            }
          },
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black.withValues(alpha: 0.6)
                          : Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNavItem(context, 0, FontAwesomeIcons.heart, 'Matches'), 
                        _buildNavItem(context, 1, FontAwesomeIcons.thumbsUp, 'Likes'), 
                        _buildNavItem(context, 2, FontAwesomeIcons.fire, 'Discover', isCenter: true),
                        _buildNavItem(context, 3, FontAwesomeIcons.solidComments, 'Messages'),
                        _buildNavItem(context, 4, FontAwesomeIcons.user, 'Profile'),
                      ],
                    ),
                  ),
                ),
              ),
              // Floating Boost Bubble
              Positioned(
                top: -20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange, Colors.deepOrange],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(FontAwesomeIcons.bolt, color: Colors.white, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        'Boost',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Wait, let's correct the order based on standard dating apps and the prompt's likely intent for "Center icon".
  // If Discover is Center, it must be the 3rd item in a 5-item list.
  // The items listed are: 1. Discover, 2. Matches, 3. Likes, 4. Messages, 5. Profile.
  // If I strictly follow the numbered list, Discover is 1st (Leftmost). 
  // BUT "Center icon (Discover/Swipe) should be slightly larger" suggests it should be in the middle of the bar.
  // So I will arrange them: Matches, Likes, DISCOVER, Messages, Profile. This is a common pattern (e.g. Tinder has Discover in middle).
  // Let's refine the items and icons:
  // 1. Matches (or maybe a list of people?) -> Let's use `FontAwesomeIcons.layerGroup` or similar for "Cards"? No, Matches usually people.
  // Let's use:
  // Left 1: Matches (List of matched users) -> `FontAwesomeIcons.handshake` or `heart`? usually `comments` is chat.
  // Let's stick to a logical flow:
  // Scale: [Matches, Likes] [DISCOVER] [Messages, Profile]
  
  // Let's try to map the user's list to this:
  // User list: 1. Discover, 2. Matches, 3. Likes, 4. Messages, 5. Profile.
  // Visual Layout:
  // [Matches] [Likes] [DISCOVER] [Messages] [Profile]
  // This seems most logical for a "Center Discover" requirement.
  
  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label, {bool isCenter = false}) {
    final isSelected = selectedIndex == index;
    final color = isSelected ? AppTheme.primaryColor : Colors.grey; // Using primary color from theme
    
    // Mapping index to the actual logical route/feature might be tricky if I rearrange visually.
    // Let's mapping:
    // Visual Index 0 -> Matches
    // Visual Index 1 -> Likes
    // Visual Index 2 -> Discover (Center)
    // Visual Index 3 -> Messages
    // Visual Index 4 -> Profile
    
    // We need to ensure the parent `onItemTapped` handles this correctly. 
    // I will pass the *Visual Index* back, and the parent `MainScreen` will map it to routes.
    
    return GestureDetector(
      onTap: () => onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                 padding: isCenter ? const EdgeInsets.all(12) : const EdgeInsets.all(0),
                 decoration: isCenter && isSelected ? BoxDecoration(
                   shape: BoxShape.circle,
                   gradient: LinearGradient(
                     colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                     begin: Alignment.topLeft,
                     end: Alignment.bottomRight,
                   ),
                   boxShadow: [
                     BoxShadow(
                       color: AppTheme.primaryColor.withOpacity(0.4),
                       blurRadius: 10,
                       spreadRadius: 2,
                     )
                   ]
                 ) : null,
                 child: Icon(
                  icon,
                  size: isCenter ? 28 : 22,
                  color: isCenter && isSelected ? Colors.white : color,
                ),
              ),
            ),
            if (!isCenter && isSelected) // Optional: Show dot or label for non-center items
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
              )
          ],
        ),
      ),
    );
  }
}
