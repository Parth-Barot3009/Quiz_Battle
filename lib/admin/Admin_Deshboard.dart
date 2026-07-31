import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_battle/admin/addorganiser.dart';

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

  // Exact Firebase Backend Logic
  Future<int> getActiveBattleCount() async {
    DateTime now = DateTime.now();

    DateTime startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    try {
      AggregateQuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Battle_Room_Details')
          .where('battle_date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('battle_date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 2. GREETING BANNER CARD
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('admin')
                        .where(
                      'email',
                      isEqualTo: user?.email ?? "",
                    )
                        .snapshots(),
                    builder: (context, snapshot) {
                      String adminName = 'Admin';
                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        var data = snapshot.data!.docs.first.data();
                        adminName = data['name'] ?? data['username'] ?? 'Admin';
                      }

                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF3B82F6),
                              Color(0xFF1D4ED8),
                            ],
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
                      // Organizer Card
                      Expanded(
                        child: Container(
                          height: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFFFF5F5), Color(0xFFFEE2E2)],
                            ),
                            border: Border.all(color: const Color(0xFFFECACA), width: 1.2),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFEF4444).withOpacity(0.08),
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
                                    Icons.group_outlined,
                                    size: 75,
                                    color: const Color(0xFFEF4444).withOpacity(0.08),
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
                                            child: const Icon(Icons.group_outlined, color: Color(0xFFEF4444), size: 18),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFEE2E2),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              "Organizers",
                                              style: TextStyle(
                                                color: Color(0xFFEF4444),
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
                                            stream: FirebaseFirestore.instance.collection('organizer').snapshots(),
                                            builder: (context, snapshot) {
                                              int count = snapshot.hasData ? snapshot.data!.docs.length : 0;
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
                                          const Text(
                                            "Organizer",
                                            style: TextStyle(
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
                      ),
                      const SizedBox(width: 14),

                      // Student Card
                      Expanded(
                        child: Container(
                          height: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFF0FDF4), Color(0xFFDCFCE7)],
                            ),
                            border: Border.all(color: const Color(0xFFA7F3D0), width: 1.2),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF10B981).withOpacity(0.08),
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
                                    Icons.person,
                                    size: 75,
                                    color: const Color(0xFF10B981).withOpacity(0.08),
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
                                            child: const Icon(Icons.person, color: Color(0xFF10B981), size: 18),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFD1FAE5),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              "Students",
                                              style: TextStyle(
                                                color: Color(0xFF10B981),
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
                                            stream: FirebaseFirestore.instance.collection('player').snapshots(),
                                            builder: (context, snapshot) {
                                              int count = snapshot.hasData ? snapshot.data!.docs.length : 0;
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
                                          const Text(
                                            "Student",
                                            style: TextStyle(
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 3. STATS GRID (Row 2: Active Battles & Total Battles)
                  Row(
                    children: [
                      // Active Battles Card
                      Expanded(
                        child: Container(
                          height: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFFFF9F3), Color(0xFFFFF1E6)],
                            ),
                            border: Border.all(color: const Color(0xFFFFE0C8), width: 1.2),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF8A00).withOpacity(0.08),
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
                                    Icons.sports_esports,
                                    size: 75,
                                    color: const Color(0xFFFF8A00).withOpacity(0.08),
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
                                            child: const Icon(Icons.sports_esports, color: Color(0xFFFF8A00), size: 18),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFFEAD8),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              "Live Now",
                                              style: TextStyle(
                                                color: Color(0xFFFF8A00),
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
                                          FutureBuilder<int>(
                                            future: getActiveBattleCount(),
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
                                          const Text(
                                            "Active Battles",
                                            style: TextStyle(
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
                      ),
                      const SizedBox(width: 14),

                      // Total Battles Card
                      Expanded(
                        child: Container(
                          height: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFF5F8FF), Color(0xFFE8F1FF)],
                            ),
                            border: Border.all(color: const Color(0xFFD0E1FF), width: 1.2),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4A7CFF).withOpacity(0.08),
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
                                    Icons.book_outlined,
                                    size: 75,
                                    color: const Color(0xFF4A7CFF).withOpacity(0.08),
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
                                            child: const Icon(Icons.book_outlined, color: Color(0xFF4A7CFF), size: 18),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFDCE7FF),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              "Total",
                                              style: TextStyle(
                                                color: Color(0xFF4A7CFF),
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
                                            stream: FirebaseFirestore.instance
                                                .collection('Battle_Room_Details')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              int count = snapshot.hasData ? snapshot.data!.docs.length : 0;
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
                                          const Text(
                                            "Total Battles",
                                            style: TextStyle(
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
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // 4. QUICK ACTIONS SECTION
                  const Text(
                    "QUICK ACTIONS",
                    style: TextStyle(
                      color: textGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Add Organizer Action Button
                  Material(
                    color: surfaceWhite,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Addorganiser(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
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
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: brandBlue,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.person_add_alt_1,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Add Organizer",
                                    style: TextStyle(
                                      color: textDark,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "Create new organizer account",
                                    style: TextStyle(
                                      color: textGrey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded, color: textGrey),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}