import 'package:flutter/material.dart';
import 'package:quiz_battle/player/join_battle.dart';
import 'package:quiz_battle/player/user_dashboard.dart';
import 'package:quiz_battle/player/player_battlehistory.dart';
import 'package:quiz_battle/player/user_profile.dart';

class player_navigationbar extends StatefulWidget {
  final int? currentIndex;
  const player_navigationbar({super.key, this.currentIndex});

  @override
  State<player_navigationbar> createState() => _player_navigationbarState();
}

class _player_navigationbarState extends State<player_navigationbar>
    with WidgetsBindingObserver {
  late int _currentIndex;
  bool _isKeyboardVisible = false;

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
    WidgetsBinding.instance.addObserver(this); // Listen for keyboard metrics
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bottomInset =
        WidgetsBinding.instance.platformDispatcher.views.first.viewInsets.bottom;
    final isVisible = bottomInset > 0;
    if (isVisible != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = isVisible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
        resizeToAvoidBottomInset: false,
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

            // 2. Navigation bar explicitly hidden when keyboard is open
            if (!_isKeyboardVisible)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
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
                          color: const Color(0xFF1E293B).withOpacity(0.08),
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