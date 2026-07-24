import 'package:flutter/material.dart';
import 'package:quiz_battle/admin/Admin_Deshboard.dart';
import 'package:quiz_battle/admin/Organizer(List_Screen).dart';
import 'package:quiz_battle/admin/Student_ListScreen.dart';
import 'package:quiz_battle/admin/addmin_setting.dart';


class Admin_Nav extends StatefulWidget {
  const Admin_Nav({super.key});

  @override
  State<Admin_Nav> createState() => _Admin_NavState();
}

class _Admin_NavState extends State<Admin_Nav> {

  int _currentIndex = 0;

  late PageController controller = PageController(initialPage: _currentIndex);

  final List<Widget> _screen = [
    AdminDeshboard(),
    Org_List(),
    Stu_List(),
    Admin_setting(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screen[_currentIndex]
      ,bottomNavigationBar: NavigationBarTheme(
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
              // controller.jumpToPage(_currentIndex);
          },
          destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.people_rounded), label: "Organizers"),
          NavigationDestination(icon: Icon(Icons.school_outlined), label: "Students"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Setting"),
          ]),
      ),
    );
  }
}
