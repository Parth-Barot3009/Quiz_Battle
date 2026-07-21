import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_battle/auth/CheckRole.dart';
import 'package:quiz_battle/auth/Choose_Role_Screen.dart';

class Authantication extends StatelessWidget {
  const Authantication({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context , snapshot){
            if (snapshot.hasData){
              return Checkrole();
            }
            else{
              return Choose_Role_Screen();
            }
          },
      ),
    );
  }
}
