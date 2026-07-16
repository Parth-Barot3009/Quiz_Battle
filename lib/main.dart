import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quiz_battle/Organizer(List_Screen).dart';
import 'package:quiz_battle/ProfileInfo(Organizer).dart';
import 'package:quiz_battle/addorganiser.dart';
import 'firebase_options.dart';
import 'package:quiz_battle/Admin_Deshboard.dart';
import 'package:quiz_battle/Choose_Role_Screen.dart';
import 'package:quiz_battle/Navigation(Admin).dart';
import 'package:quiz_battle/User(Registration).dart';
import 'package:quiz_battle/Splash_Screen.dart';
import 'package:quiz_battle/organiser(dashboard).dart';
import 'package:quiz_battle/login(admin-organiser-user).dart';

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
      home: Org_List(),
    );
  }
}
