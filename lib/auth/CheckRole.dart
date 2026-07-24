import 'package:flutter/material.dart';
import 'package:quiz_battle/admin/Admin_Deshboard.dart';
import 'package:quiz_battle/admin/Navigation(Admin).dart';
import 'package:quiz_battle/organizer/organizer_dashboard.dart';
import 'package:quiz_battle/player/user_dashboard.dart';



class Checkrole extends StatelessWidget {
  final String? role;
  const Checkrole({super.key,this.role});

  @override
  Widget build(BuildContext context) {
    if ( role == "admin" ){
      return Admin_Nav();
    }
    else if ( role == "organizer" ){
      return org_dashboard();
    }
    else if (role == "player")
    {
      return u_dashboard();
    } else {
      return Scaffold(
        body: Text("Invalid user"),
      );
    }
  }
}
