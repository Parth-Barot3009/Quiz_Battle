import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quiz_battle/admin/Navigation(Admin).dart';
import 'package:quiz_battle/auth/Choose_Role_Screen.dart';
import 'package:quiz_battle/auth/Splash_Screen.dart';
import 'package:quiz_battle/organizer/organizer_dashboard.dart';
import 'package:quiz_battle/organizer/organizer_navigationbar.dart';
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
      title: 'QuizX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Roboto",
      ),
      home: Choose_Role_Screen(),
    );
  }
}
