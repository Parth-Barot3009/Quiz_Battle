import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quiz_battle/Authantication.dart';
import 'package:quiz_battle/Battle_Room_Org.dart';
import 'package:quiz_battle/Organizer(List_Screen).dart';
import 'package:quiz_battle/ProfileInfo(Organizer).dart';
import 'package:quiz_battle/Student_ListScreen.dart';
import 'package:quiz_battle/addorganiser.dart';
import 'package:quiz_battle/create_battle.dart';
import 'package:quiz_battle/organizer_dashboard.dart';
import 'firebase_options.dart';
import 'package:quiz_battle/Admin_Deshboard.dart';
import 'package:quiz_battle/Choose_Role_Screen.dart';
import 'package:quiz_battle/Navigation(Admin).dart';
import 'package:quiz_battle/User_Registration.dart';
import 'package:quiz_battle/Splash_Screen.dart';
import 'package:quiz_battle/login_admin_organiser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: create_battle(),
    );
  }
}
