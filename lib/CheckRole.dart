import 'package:flutter/material.dart';
import 'package:quiz_battle/Admin_Deshboard.dart';
import 'package:quiz_battle/Navigation(Admin).dart';
import 'package:quiz_battle/organizer_dashboard.dart';


class Checkrole extends StatelessWidget {
  String? role;
  Checkrole({super.key,this.role});

  @override
  Widget build(BuildContext context) {
    if ( role == "admin" ){
        return Admin_Nav();
    }
    else if ( role == "organizer" ){
      return org_dashboard();
    }
    else
    {
      return AdminDeshboard();
    }
  }
}
