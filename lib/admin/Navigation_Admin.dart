import 'package:flutter/material.dart';
import 'package:quiz_battle/admin/Admin_Deshboard.dart';
import 'package:quiz_battle/admin/Organizer(List_Screen).dart';
import 'package:quiz_battle/admin/Student_ListScreen.dart';
import 'package:quiz_battle/admin/admin_setting.dart';

class Admin_Nav extends StatefulWidget {
  const Admin_Nav({super.key});

  @override
  State<Admin_Nav> createState() => _Admin_NavState();
}

class _Admin_NavState extends State<Admin_Nav> {
  int _currentIndex = 0;

  // App Theme Palette
  static const Color brandBlue = Color(0xFF306AE7);
  static const Color activeLightBlue = Color(0xFFEFF6FF);
  static const Color textGrey = Color(0xFF94A3B8);

  final List<Widget> _screen = const [
    AdminDeshboard(),
    Org_List(),
    Stu_List(),
    GlobalBattleHistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack preserves state across screen switches without using PageView
      body: IndexedStack(
        index: _currentIndex,
        children: _screen,
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFFF4F7FF), // Matches screen canvas
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
                icon: Icons.people_rounded,
                outlinedIcon: Icons.people_outline_rounded,
                label: "Organizers",
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.school_rounded,
                outlinedIcon: Icons.school_outlined,
                label: "Students",
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.emoji_events,
                outlinedIcon: Icons.emoji_events,
                label: "Battles",
              ),
            ],
          ),
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