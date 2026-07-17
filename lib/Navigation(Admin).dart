import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:quiz_battle/User_Registration.dart';
import 'package:quiz_battle/organiser(dashboard).dart';
import 'package:quiz_battle/Admin_Deshboard.dart';

class Admin_Nav extends StatefulWidget {
  const Admin_Nav({super.key});

  @override
  State<Admin_Nav> createState() => _Admin_NavState();
}

class _Admin_NavState extends State<Admin_Nav> {
  @override

  int _currentIndex = 0;

  late PageController controller = PageController(initialPage: _currentIndex);

  final List<Widget> _screen = [
    AdminDeshboard(),
    o_dashboard(),
    Register(),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        children: _screen,
    ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color(0xffF4F4F4),
        buttonBackgroundColor: Color(0xFF320451),
        color: Color(0xFF320451),
        animationDuration: Duration(milliseconds: 300),
        animationCurve: TreeSliver.defaultAnimationCurve,
        index: _currentIndex,
        items: <Widget>[
          Icon(Icons.home_outlined, color: Color(0xffF4F4F4)),
          Icon(Icons.person_2_outlined, color: Color(0xffF4F4F4)),
          Icon(Icons.school_outlined, color: Color(0xffF4F4F4)),
          Icon(Icons.settings, color: Color(0xffF4F4F4)),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          controller.jumpToPage(_currentIndex);
        },
      ),
    );
  }
}
