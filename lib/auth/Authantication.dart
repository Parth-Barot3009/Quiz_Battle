import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_battle/admin/Admin_Deshboard.dart';
import 'package:quiz_battle/admin/Navigation(Admin).dart';
import 'package:quiz_battle/auth/CheckRole.dart';
import 'package:quiz_battle/auth/Choose_Role_Screen.dart';
import 'package:quiz_battle/organizer/organizer_dashboard.dart';
import 'package:quiz_battle/player/user_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authantication extends StatelessWidget {
  const Authantication({super.key});
  Future<Widget> authenticat() async{
    if(FirebaseAuth.instance.currentUser!=null){
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? role = await prefs.getString('role');
      if(role=="admin"){
        return Admin_Nav();
      } else if(role=="organizer"){
        return org_dashboard();
      } else if(role=="users"){
        return u_dashboard();
      }
    }
    return Choose_Role_Screen();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: authenticat(),
          builder: (context, snapshot) {
            return snapshot.data!;
          },
      )
    );
  }
}
