import 'package:flutter/material.dart';
import 'package:quiz_battle/Admin_Deshboard.dart';


class Checkrole extends StatelessWidget {
  String? role;
  Checkrole({super.key,this.role});

  @override
  Widget build(BuildContext context) {
    if ( role == "admin" ){
        return AdminDeshboard();
    }
    else if (role == "organizer"){
      return AdminDeshboard();
    }
    else
    {
      return AdminDeshboard();
    }
  }
}
