import 'package:flutter/material.dart';
import 'package:quiz_battle/player/join_battle.dart';
import 'package:quiz_battle/player/user_dashboard.dart';
import 'package:quiz_battle/player/player_battlehistory.dart';
import 'package:quiz_battle/player/user_profile.dart';

class PlayerNavigationBar extends StatefulWidget {
  final int? currentIndex;
  const PlayerNavigationBar({super.key, this.currentIndex});

  @override
  State<PlayerNavigationBar> createState() => _PlayerNavigationBarState();
}

class _PlayerNavigationBarState extends State<PlayerNavigationBar>
    {
  late int _currentIndex;

  // App Theme Palette
  static const Color brandBlue = Color(0xFF306AE7);
  static const Color activeLightBlue = Color(0xFFEFF6FF);
  static const Color textGrey = Color(0xFF94A3B8);

  final List<Widget> _screen = const [
    StudentDashboard(),
    JoinBattleScreen(),
    PlayerBattleHistory(),
    UserProfileInfo(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    // Driven by MediaQuery rather than a mirrored bool in State, so the bar
    // tracks the keyboard without an extra setState per transition.
    final bool isKeyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;

    return PopScope(
      // Allows popping/exiting only when already on index 0
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;

        // Redirect to Home tab (index 0) if on any other tab
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7FF),
        body: Stack(
          children: [
            // 1. Screens view
            Positioned.fill(
              child: IndexedStack(
                index: _currentIndex,
                children: _screen,
              ),
            ),

            // 2. Navigation bar slides out of the way while the keyboard is
            //    up. It used to be dropped from the tree outright, which made
            //    it pop in and out with no transition.
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                offset: isKeyboardVisible ? const Offset(0, 1.5) : Offset.zero,
                child: IgnorePointer(
                  ignoring: isKeyboardVisible,
                  child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Container(
                    height: 66,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1E293B).withValues(alpha: 0.08),
                          blurRadius: 16,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(
                          index: 0,
                          icon: Icons.home_rounded,
                          outlinedIcon: Icons.home_outlined,
                          label: "Home",
                        ),
                        _buildNavItem(
                          index: 1,
                          icon: Icons.sports_esports_rounded,
                          outlinedIcon: Icons.sports_esports_outlined,
                          label: "Join",
                        ),
                        _buildNavItem(
                          index: 2,
                          icon: Icons.emoji_events_rounded,
                          outlinedIcon: Icons.emoji_events_outlined,
                          label: "History",
                        ),
                        _buildNavItem(
                          index: 3,
                          icon: Icons.person_rounded,
                          outlinedIcon: Icons.person_outline_rounded,
                          label: "Profile",
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

  // Smooth Tab Button Builder
  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData outlinedIcon,
    required String label,
  }) {
    final bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeLightBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? icon : outlinedIcon,
                color: isSelected ? brandBlue : textGrey,
                size: 22,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isSelected ? 1.0 : 0.0,
                child: Text(
                  label,
                  style: const TextStyle(
                    color: brandBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}