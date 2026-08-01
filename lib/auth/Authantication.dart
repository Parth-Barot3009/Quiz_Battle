import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_battle/admin/Navigation_Admin.dart';
import 'package:quiz_battle/organizer/organizer_navigationbar.dart';
import 'package:quiz_battle/player/player_navigationbar.dart';
import 'package:quiz_battle/auth/login_admin_organiser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authantication extends StatelessWidget {
  const Authantication({super.key});

  Future<Widget> authenticate() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? role = prefs.getString('role');

      if (role == "admin") {
        return const Admin_Nav();
      } else if (role == "organizer" || role == "organiser") {
        return const Org_Navigationbar();
      } else if (role == "player") {
        return const player_navigationbar();
      }
    }

    // Default to LoginScreen if user is not authenticated or no role is stored
    return const LoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Widget>(
        future: authenticate(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1D61E7),
              ),
            );
          }
          if (snapshot.hasData) {
            return snapshot.data!;
          }
          return const LoginScreen();
        },
      ),
    );
  }
}