import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_battle/admin/navigation_admin.dart';
import 'package:quiz_battle/organizer/organizer_navigationbar.dart';
import 'package:quiz_battle/player/player_navigationbar.dart';
import 'package:quiz_battle/auth/login_admin_organiser.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Decides which shell to open for the signed-in user, or sends them to login.
class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  // Resolved once. Rebuilding the FutureBuilder used to restart the whole
  // check, because the future was created inside build().
  late final Future<Widget> _landingScreen = _resolveLandingScreen();

  /// The cached role is a convenience, not an authorization decision. The
  /// user's profile is re-read on every launch so that an account blocked or
  /// deleted since the last session is turned away here rather than keeping
  /// access until it next signs out.
  Future<Widget> _resolveLandingScreen() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const LoginScreen();

    final prefs = await SharedPreferences.getInstance();
    final String? role = prefs.getString('role');
    if (role == null) return const LoginScreen();

    try {
      final bool allowed = await _accountIsActive(role, user);
      if (!allowed) {
        await prefs.remove('role');
        await FirebaseAuth.instance.signOut();
        return const LoginScreen();
      }
    } catch (e) {
      // Offline or a transient Firestore error: fall through on the cached
      // role rather than locking a legitimate user out of the whole app.
      debugPrint("Could not verify account status: $e");
    }

    switch (role) {
      case "admin":
        return const AdminNav();
      case "organizer":
        return const OrgNavigationBar();
      case "player":
        return const PlayerNavigationBar();
      default:
        return const LoginScreen();
    }
  }

  /// True when the account still exists and has not been blocked.
  Future<bool> _accountIsActive(String role, User user) async {
    final firestore = FirebaseFirestore.instance;

    switch (role) {
      case "admin":
        final admin = await firestore
            .collection('admin')
            .where('email', isEqualTo: user.email)
            .limit(1)
            .get();
        return admin.docs.isNotEmpty;

      case "organizer":
        final organizer =
            await firestore.collection('organizer').doc(user.uid).get();
        return organizer.exists && organizer.data()?['is_blocked'] != true;

      case "player":
        final player =
            await firestore.collection('player').doc(user.uid).get();
        return player.exists && player.data()?['is_blocked'] != true;

      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Widget>(
        future: _landingScreen,
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
