import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/mock_data.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final CardSwiperController controller = CardSwiperController();
  bool _showUndo = false;
  Timer? _undoTimer;
  bool _showCompliment = false;
  Timer? _lingeringTimer;
  DateTime _cardAppearanceTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _startLingeringTimer();
  }

  @override
  void dispose() {
    controller.dispose();
    _undoTimer?.cancel();
    _lingeringTimer?.cancel();
    super.dispose();
  }

  void _startLingeringTimer() {
    _cardAppearanceTime = DateTime.now();
    _lingeringTimer?.cancel();
    _lingeringTimer = Timer(const Duration(seconds: 7), () {
      if (mounted) {
        setState(() {
          _showCompliment = true;
        });
      }
    });
  }

  void _onUndoAction() {
    controller.undo();
    setState(() {
      _showUndo = false;
    });
    _undoTimer?.cancel();
    _startLingeringTimer(); // Restart for the restored card
  }

  void _onComplimentAction() {
    // Logic for sending compliment
    debugPrint("Compliment sending...");
    setState(() {
      _showCompliment = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(FontAwesomeIcons.fire, color: AppTheme.primaryColor),
        ),
        title: Text(
          "Discover",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: CardSwiper(
                    controller: controller,
                    cardsCount: MockData.users.length,
                    onSwipe: _onSwipe,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    cardBuilder: (context, index, horizontalOffsetPercentage,
                        verticalOffsetPercentage) {
                      return ProfileCard(user: MockData.users[index]);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[900]
                            : Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _ActionButton(
                            icon: Icons.close,
                            color: Colors.red,
                            onPressed: () => controller.swipe(CardSwiperDirection.left),
                            useShadow: false,
                          ),
                          const SizedBox(width: 16),
                          _ActionButton(
                            icon: Icons.star,
                            color: Colors.blue,
                            onPressed: () => controller.swipe(CardSwiperDirection.top),
                            isSmall: true,
                            useShadow: false,
                          ),
                          const SizedBox(width: 16),
                          _ActionButton(
                            icon: Icons.favorite,
                            color: Colors.green,
                            onPressed: () => controller.swipe(CardSwiperDirection.right),
                            useShadow: false,
                          ),
                        ],
                      ),
                    ),
                ),
                const SizedBox(height: 70), // Space for Floating Navigation
              ],
            ),
            if (_showUndo)
              Positioned(
                top: 20,
                right: 0,
                left: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: _onUndoAction,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 300),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Opacity(opacity: value, child: child),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.refresh, color: Colors.orange, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              "Undo Profile",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (_showCompliment)
              Positioned(
                top: 20,
                right: 0,
                left: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: _onComplimentAction,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 500),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: Opacity(opacity: value, child: child),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.pinkAccent, Colors.orangeAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(FontAwesomeIcons.gift, color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              "Send Compliment",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "\$1",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
    );
    
    // Check dwell time
    final duration = DateTime.now().difference(_cardAppearanceTime);
    final isQuickSwipe = duration.inMilliseconds < 1500; // < 1.5 seconds

    // Reset state for next card
    setState(() {
      _showCompliment = false; // Hide compliment if it was showing
      _showUndo = false;
    });
    
    // Cancel lingering timer for previous card
    _lingeringTimer?.cancel();

    if (direction == CardSwiperDirection.left && isQuickSwipe) {
      // Quick Swipe Left -> Show Undo
       setState(() {
        _showUndo = true;
      });
      _undoTimer?.cancel();
      _undoTimer = Timer(const Duration(seconds: 4), () {
        if (mounted) {
          setState(() {
            _showUndo = false;
          });
        }
      });
    }

    // Start timer for the NEXT card (since swipe is happening/happened)
    _startLingeringTimer();
    
    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $currentIndex was undod from the ${direction.name}',
    );
    return true;
  }
}

class ProfileCard extends StatelessWidget {
  final UserModel user;

  const ProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          context.push('/discover/profile', extra: user);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
          fit: StackFit.expand,
          children: [
            Builder(
              builder: (context) {
                if (user.imageUrl.startsWith('http')) {
                  return Image.network(
                    user.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[800],
                      child: const Icon(Icons.error, color: Colors.white),
                    ),
                  );
                } else {
                  return Image.file(
                    File(user.imageUrl),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[800],
                      child: const Icon(Icons.error, color: Colors.white),
                    ),
                  );
                }
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "${user.name}, ${user.age}",
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.verified, color: Colors.blue, size: 20),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.white70, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "${user.location} • ${user.distance} km away",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.bio,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: user.interests
                        .map((interest) => Chip(
                              label: Text(interest),
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.1),
                              labelStyle: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final bool isSmall;
  final bool useShadow;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    this.isSmall = false,
    this.useShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: useShadow
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.all(isSmall ? 10 : 14),
          backgroundColor: Colors.white, // Dark mode might want dark bg
          foregroundColor: color,
          elevation: 0, // Using manual shadow
          minimumSize: Size.zero,
        ),
        child: Icon(icon, size: isSmall ? 20 : 28, color: color),
      ),
    );
  }
}
