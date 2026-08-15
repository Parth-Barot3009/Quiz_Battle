import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_battle/admin/Navigation_Admin.dart';
import 'package:quiz_battle/auth/login_admin_organiser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDeshboard extends StatefulWidget {
  const AdminDeshboard({super.key});

  @override
  State<AdminDeshboard> createState() => _AdminDeshboardState();
}

class _AdminDeshboardState extends State<AdminDeshboard> {
  final user = FirebaseAuth.instance.currentUser;

  // Theme Palette
  static const Color brandBlue = Color(0xFF2563EB);
  static const Color bgCanvas = Color(0xFFEBF1FF);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);

  // Stream for active battle count
  Stream<int> getActiveBattleCountStream() {
    final now = Timestamp.now();
    return FirebaseFirestore.instance
        .collection('Battle_Room_Details')
        .where('start_time', isLessThanOrEqualTo: now)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.where((doc) {
        final data = doc.data();
        final Timestamp? endTime = data['end_time'] as Timestamp?;
        if (endTime == null) return false;
        return endTime.compareTo(now) >= 0;
      }).length;
    });
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('role');
    await FirebaseAuth.instance.signOut();
  }

  void _navigateToTab(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Admin_Nav(initialIndex: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = Timestamp.now();

    return Scaffold(
      backgroundColor: bgCanvas,
      body: Stack(
        children: [
          // Background Decorative Soft Blobs
          Positioned(
            top: -40,
            left: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: brandBlue.withOpacity(0.12),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: brandBlue.withOpacity(0.08),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. TOP HEADER BAR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "ADMIN PORTAL",
                            style: TextStyle(
                              color: textGrey,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Dashboard",
                            style: TextStyle(
                              color: textDark,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),

                      // Red-accented Glassy Logout Button
                      InkWell(
                        onTap: () async {
                          await logout();
                          if (!context.mounted) return;
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                                (route) => false,
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: surfaceWhite,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFEE2E2)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFEF4444).withOpacity(0.06),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.logout_rounded,
                            color: Color(0xFFEF4444),
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 2. GREETING BANNER CARD
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('admin')
                        .where('email', isEqualTo: user?.email ?? "")
                        .snapshots(),
                    builder: (context, snapshot) {
                      String adminName = 'Admin';
                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        var data = snapshot.data!.docs.first.data();
                        adminName = data['name'] ?? data['username'] ?? 'Admin';
                      }

                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 26),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1D4ED8).withOpacity(0.35),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Welcome back,",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.85),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  adminName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 58,
                              height: 58,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.20),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.25),
                                ),
                              ),
                              child: const Icon(
                                Icons.shield_outlined,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // 3. STATS GRID (Row 1: Organizer & Student)
                  Row(
                    children: [
                      // Organizer Card (Navigates to Organizers List - Index 1)
                      Expanded(
                        child: _buildDashboardCard(
                          title: "Organizers",
                          subtitle: "Organizer",
                          icon: Icons.group_outlined,
                          gradientColors: const [
                            Color(0xFFFFF5F5),
                            Color(0xFFFEE2E2)
                          ],
                          borderColor: const Color(0xFFFECACA),
                          accentColor: const Color(0xFFEF4444),
                          badgeColor: const Color(0xFFFEE2E2),
                          stream: FirebaseFirestore.instance
                              .collection('organizer')
                              .snapshots(),
                          onTap: () => _navigateToTab(1),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Player/Student Card (Navigates to Players List - Index 2)
                      Expanded(
                        child: _buildDashboardCard(
                          title: "Players",
                          subtitle: "Players",
                          icon: Icons.person,
                          gradientColors: const [
                            Color(0xFFF0FDF4),
                            Color(0xFFDCFCE7)
                          ],
                          borderColor: const Color(0xFFA7F3D0),
                          accentColor: const Color(0xFF10B981),
                          badgeColor: const Color(0xFFD1FAE5),
                          stream: FirebaseFirestore.instance
                              .collection('player')
                              .snapshots(),
                          onTap: () => _navigateToTab(2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 3. STATS GRID (Row 2: Active Battles & Total Battles)
                  Row(
                    children: [
                      // Active Battles Card (Navigates to Battles Tab - Index 3)
                      Expanded(
                        child: _buildDashboardCardCustomStream(
                          title: "Live Now",
                          subtitle: "Active Battles",
                          icon: Icons.sports_esports,
                          gradientColors: const [
                            Color(0xFFFFF9F3),
                            Color(0xFFFFF1E6)
                          ],
                          borderColor: const Color(0xFFFFE0C8),
                          accentColor: const Color(0xFFFF8A00),
                          badgeColor: const Color(0xFFFFEAD8),
                          stream: getActiveBattleCountStream(),
                          onTap: (){},
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Total Battles Card (Navigates to Battles Tab - Index 3)
                      Expanded(
                        child: _buildDashboardCard(
                          title: "Total",
                          subtitle: "Total Battles",
                          icon: Icons.book_outlined,
                          gradientColors: const [
                            Color(0xFFF5F8FF),
                            Color(0xFFE8F1FF)
                          ],
                          borderColor: const Color(0xFFD0E1FF),
                          accentColor: const Color(0xFF4A7CFF),
                          badgeColor: const Color(0xFFDCE7FF),
                          stream: FirebaseFirestore.instance
                              .collection('Battle_Room_Details')
                              .snapshots(),
                          onTap: () => _navigateToTab(3),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 4. ACTIVE BATTLES SECTION
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Active Battles",
                        style: TextStyle(
                          color: textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Battle_Room_Details')
                        .where('start_time', isLessThanOrEqualTo: now)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Text(
                          "Error loading active battles: ${snapshot.error}",
                          style: const TextStyle(color: textGrey, fontSize: 13),
                        );
                      }

                      // Client-side filter for end_time >= now
                      final activeDocs = (snapshot.data?.docs ?? []).where((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final Timestamp? endTime = data['end_time'] as Timestamp?;
                        if (endTime == null) return false;
                        return endTime.compareTo(now) >= 0;
                      }).toList();

                      if (activeDocs.isEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: surfaceWhite,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: borderColor, width: 1.2),
                          ),
                          child: const Text(
                            "No active battles currently live.",
                            style: TextStyle(color: textGrey, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: activeDocs.length,
                        itemBuilder: (context, index) {
                          var battle =
                          activeDocs[index].data() as Map<String, dynamic>;
                          String roomName = battle['room_name'] ?? 'Quiz Battle';
                          String roomCode = battle['room_code'] ?? 'N/A';
                          int questions = battle['questions'] ?? 0;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: surfaceWhite,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: borderColor, width: 1.2),
                                boxShadow: [
                                  BoxShadow(
                                    color: textDark.withOpacity(0.02),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF1E6),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                          color: const Color(0xFFFFE0C8)),
                                    ),
                                    child: const Icon(
                                      Icons.bolt_rounded,
                                      color: Color(0xFFFF8A00),
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          roomName,
                                          style: const TextStyle(
                                            color: textDark,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "Code: $roomCode • $questions Questions",
                                          style: const TextStyle(
                                            color: textGrey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDCFCE7),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      "LIVE",
                                      style: TextStyle(
                                        color: Color(0xFF10B981),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dashboard Query Card Helper
  Widget _buildDashboardCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradientColors,
    required Color borderColor,
    required Color accentColor,
    required Color badgeColor,
    required Stream<QuerySnapshot> stream,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              Positioned(
                right: -10,
                bottom: -10,
                child: Icon(
                  icon,
                  size: 75,
                  color: accentColor.withOpacity(0.08),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: surfaceWhite,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(icon, color: accentColor, size: 18),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: badgeColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            title,
                            style: TextStyle(
                              color: accentColor,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: stream,
                          builder: (context, snapshot) {
                            int count =
                            snapshot.hasData ? snapshot.data!.docs.length : 0;
                            return Text(
                              "$count",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: textDark,
                                letterSpacing: -0.5,
                                height: 1.0,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: textGrey,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dashboard Integer Stream Card Helper
  Widget _buildDashboardCardCustomStream({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradientColors,
    required Color borderColor,
    required Color accentColor,
    required Color badgeColor,
    required Stream<int> stream,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              Positioned(
                right: -10,
                bottom: -10,
                child: Icon(
                  icon,
                  size: 75,
                  color: accentColor.withOpacity(0.08),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: surfaceWhite,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(icon, color: accentColor, size: 18),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: badgeColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            title,
                            style: TextStyle(
                              color: accentColor,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StreamBuilder<int>(
                          stream: stream,
                          builder: (context, snapshot) {
                            int count = snapshot.data ?? 0;
                            return Text(
                              "$count",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: textDark,
                                letterSpacing: -0.5,
                                height: 1.0,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: textGrey,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}