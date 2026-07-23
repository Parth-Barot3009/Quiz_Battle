import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quiz_battle/admin/about_app_setting.dart';

import 'package:quiz_battle/organizer/ProfileInfo(Organizer).dart';
import 'package:quiz_battle/organizer/create_battle.dart';
import 'package:quiz_battle/organizer/organizer_dashboard.dart';
import 'package:quiz_battle/player/after_quiz.dart';
import 'package:quiz_battle/player/quiz_screen.dart';
import 'package:quiz_battle/player/user_profile.dart';
import 'package:quiz_battle/player/waiting_room.dart';
import 'firebase_options.dart';


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
      theme: ThemeData(
        fontFamily: "Roboto",
      ),
      home: create_battle(),
    );
  }
}
