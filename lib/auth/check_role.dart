// import 'package:flutter/material.dart';
// import 'package:quiz_battle/admin/Navigation(Admin).dart';
// import 'package:quiz_battle/auth/Authantication.dart';
// import 'package:quiz_battle/auth/Choose_Role_Screen.dart';
// import 'package:quiz_battle/organizer/organizer_dashboard.dart';
// import 'package:quiz_battle/organizer/organizer_navigationbar.dart';
// import 'package:quiz_battle/player/player_navigationbar.dart';
//
// class CheckRole extends StatelessWidget {
//   final String? role;
//   const CheckRole({super.key,this.role});
//
//   Widget getRole(){
//
//     switch (role){
//       case 'admin':
//         return const Admin_Nav();
//       case 'organizer':
//         return const Org_Navigationbar();
//       case 'users':
//         return const player_navigationbar();
//       default:
//         return Choose_Role_Screen();
//     }
//   }
//   // Future<Widget> getRole() async{
//   //   if (role == "admin"){
//   //     return Admin_Nav();
//   //   }
//   //   else if (role == "organizer"){
//   //     return Org_Navigationbar();
//   //   }
//   //   return player_navigationbar();
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: getRole(),
//     );
//   }
// }
//
