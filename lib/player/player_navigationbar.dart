import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_battle/organizer/create_battle.dart';
import 'package:quiz_battle/organizer/organizer_dashboard.dart';
import 'package:quiz_battle/player/join_battle.dart';
import 'package:quiz_battle/player/user_dashboard.dart';
import 'package:quiz_battle/player/user_leaderboard.dart';
import 'package:quiz_battle/player/user_profile.dart';

class player_navigationbar extends StatefulWidget {
  const player_navigationbar({super.key});

  @override
  State<player_navigationbar> createState() => _player_navigationbarState();
}

class _player_navigationbarState extends State<player_navigationbar> {

  int _currentIndex = 0;

  final List<Widget> _screen = [
    StudentDashboard(),
    JoinBattleScreen(),
    LeaderboardScreen(),
    UserProfileInfo()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screen[_currentIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Color(0xFF306AE7),
          labelTextStyle: WidgetStateProperty.all(TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          )
          ),
          iconTheme: WidgetStateProperty.all(
            IconThemeData(
              color: Colors.white,
            ),
          ),
          indicatorColor: Color(0x33FFFFFF),
        ),
        child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (value){
              setState(() {
                _currentIndex = value;
              });
            },
            destinations: [
              NavigationDestination(icon: Icon(Icons.home), label: "Home"),
              NavigationDestination(icon: Icon(Icons.sports_esports), label: "Join Battle"),
              NavigationDestination(icon: Icon(Icons.emoji_events), label: "Leaderboard"),
              NavigationDestination(icon: Icon(Icons.person_rounded), label: "Profile"),
            ]),
      ),
    );
  }
}
