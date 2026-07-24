import 'package:flutter/material.dart';
import 'package:quiz_battle/organizer/ProfileInfo(Organizer).dart';
import 'package:quiz_battle/organizer/battle_history.dart';
import 'package:quiz_battle/organizer/create_battle.dart';
import 'package:quiz_battle/organizer/organizer_dashboard.dart';

class Org_Navigationbar extends StatefulWidget {
  const Org_Navigationbar({super.key});

  @override
  State<Org_Navigationbar> createState() => _Org_NavigationbarState();
}

class _Org_NavigationbarState extends State<Org_Navigationbar> {

  int _currentIndex = 0;

  final List<Widget> _screen = [
    org_dashboard(),
    create_battle(),
    BattleHistory(),
    OrganiserProfileInfo()
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
              NavigationDestination(icon: Icon(Icons.add), label: "Create Battle"),
              NavigationDestination(icon: Icon(Icons.emoji_events), label: "History"),
              NavigationDestination(icon: Icon(Icons.person_rounded), label: "Profile"),
            ]),
      ),
    );
  }
}
