import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_battle/organizer/organizer_navigationbar.dart';

class OrgDashboard extends StatefulWidget {
  const OrgDashboard({super.key});

  @override
  State<OrgDashboard> createState() => _OrgDashboardState();
}

class _OrgDashboardState extends State<OrgDashboard> {
  final currentUser = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userInfo;

  Future<void> _handleRefresh() async {
    // Triggers a State rebuild to update time-dependent Firestore queries
    setState(() {});

    // Optional: Add a brief artificial delay to ensure the refresh indicator gives visual feedback
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  // Theme Colors
  static const Color brandBlue = Color(0xFF2563EB);
  static const Color bgCanvas = Color(0xFFEBF1FF);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _getUser() async {
    if (currentUser?.uid != null) {
      final data = await _getDocumentById(currentUser!.uid);
      if (mounted) {
        setState(() {
          userInfo = data;
        });
      }
    }
  }

  Future<Map<String, dynamic>?> _getDocumentById(String docId) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('organizer')
          .doc(docId)
          .get();

      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
    } catch (e) {
      debugPrint("Error fetching document: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCanvas,
      body: Stack(
        children: [
          // Decorative Soft Background Blobs
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
            child: RefreshIndicator(
              color: brandBlue,
              backgroundColor: surfaceWhite,
              onRefresh: _handleRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. TOP HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "GOOD EVENING",
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
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('organizer')
                              .doc(currentUser?.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            String? imageUrl;
                            if (snapshot.hasData && snapshot.data!.exists) {
                              final data =
                              snapshot.data!.data() as Map<String, dynamic>?;
                              imageUrl = data?['image_url'];
                            }
                            return Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: brandBlue.withOpacity(0.15),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: GestureDetector(
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                          Org_Navigationbar(
                                              currentIndex: 3),
                                        ),
                                      );
                                      _getUser(); // Re-fetch local snapshot when returning
                                    },
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: brandBlue,
                                      backgroundImage:
                                      imageUrl != null && imageUrl.isNotEmpty
                                          ? NetworkImage(imageUrl)
                                          : null,
                                      child: imageUrl == null || imageUrl.isEmpty
                                          ? const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      )
                                          : null,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 2,
                                  bottom: 2,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF10B981),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 2. GREETING CARD
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('organizer')
                          .where('o_email', isEqualTo: currentUser?.email)
                          .snapshots(),
                      builder: (context, snapshot) {
                        String name = "Organizer";
                        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                          final data =
                          snapshot.data!.docs.first.data()
                          as Map<String, dynamic>?;
                          name = data?['o_name'] ?? "Organizer";
                        }

                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 24,
                          ),
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
                                    "Welcome back",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    currentUser?.email ?? "",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.75),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.20),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.25),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.menu_book_rounded,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // 3. STATS CARDS
                    Row(
                      children: [
                        // Total Battles Card (Redirects to History Tab)
                        _buildReferenceCard(
                          title: "Total Battles",
                          icon: Icons.quiz_rounded,
                          accentColor: const Color(0xFF4A7CFF),
                          badgeBgColor: const Color(0xFFDCE7FF),
                          gradientColors: [
                            const Color(0xFFF5F8FF),
                            const Color(0xFFE8F1FF),
                          ],
                          borderColor: const Color(0xFFD0E1FF),
                          badgeText: "Battles",
                          watermarkIcon: Icons.quiz_rounded,
                          stream: FirebaseFirestore.instance
                              .collection('Battle_Room_Details')
                              .where('o_email', isEqualTo: currentUser?.email)
                              .snapshots(),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Org_Navigationbar(
                                  currentIndex: 2,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 14),

                        // Active Rooms Card
                        _buildReferenceCard(
                          title: "Active Rooms",
                          icon: Icons.bolt_rounded,
                          accentColor: const Color(0xFFFF8A00),
                          badgeBgColor: const Color(0xFFFFEAD8),
                          gradientColors: [
                            const Color(0xFFFFF9F3),
                            const Color(0xFFFFF1E6),
                          ],
                          borderColor: const Color(0xFFFFE0C8),
                          badgeText: "Live Now",
                          watermarkIcon: Icons.bolt_rounded,
                          stream: FirebaseFirestore.instance
                              .collection('Battle_Room_Details')
                              .where('o_email', isEqualTo: currentUser?.email)
                              .snapshots(),
                          filterActiveOnly: true,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // 4. ACTIVE BATTLES SECTION
                    const Text(
                      "Active Battles",
                      style: TextStyle(
                        color: textDark,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Battle_Room_Details')
                          .where('o_email', isEqualTo: currentUser?.email)
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

                        final now = DateTime.now();

                        // Filter client-side to only keep active rooms based on start/end timestamps or is_active flag
                        final activeDocs = (snapshot.data?.docs ?? []).where((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final Timestamp? start = data['start_time'];
                          final Timestamp? end = data['end_time'];

                          if (start != null) {
                            final startTime = start.toDate();
                            if (end != null) {
                              final endTime = end.toDate();
                              return now.isAfter(startTime) && now.isBefore(endTime);
                            }
                            return now.isAfter(startTime);
                          }
                          return data['is_active'] == true;
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
                              "No active battles live right now.",
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
                            var activeBattle =
                            activeDocs[index].data() as Map<String, dynamic>;
                            String battlename =
                                activeBattle['room_name'] ?? 'Quiz Battle';
                            String roomCode = activeBattle['room_code'] ?? 'N/A';
                            int totalQuestion = activeBattle['questions'] ?? 0;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: surfaceWhite,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: borderColor,
                                    width: 1.2,
                                  ),
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
                                          color: const Color(0xFFFFE0C8),
                                        ),
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
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            battlename,
                                            style: const TextStyle(
                                              color: textDark,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "Code: $roomCode • $totalQuestion Questions",
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
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
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
          ),
        ],
      ),
    );
  }

  // Soft Metric Card Helper
  Widget _buildReferenceCard({
    required String title,
    required IconData icon,
    required Color accentColor,
    required Color badgeBgColor,
    required List<Color> gradientColors,
    required Color borderColor,
    required String badgeText,
    required IconData watermarkIcon,
    required Stream<QuerySnapshot> stream,
    bool filterActiveOnly = false,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 135,
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
                // Background Watermark Graphic
                Positioned(
                  right: -10,
                  bottom: -10,
                  child: Icon(
                    watermarkIcon,
                    size: 75,
                    color: accentColor.withOpacity(0.08),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: surfaceWhite,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(icon, color: accentColor, size: 18),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: badgeBgColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              badgeText,
                              style: TextStyle(
                                color: accentColor,
                                fontSize: 10,
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
                              int count = 0;
                              if (snapshot.hasData) {
                                if (filterActiveOnly) {
                                  final now = DateTime.now();
                                  count = snapshot.data!.docs.where((doc) {
                                    final data =
                                    doc.data() as Map<String, dynamic>;

                                    final Timestamp? start = data['start_time'];
                                    final Timestamp? end = data['end_time'];

                                    if (start != null) {
                                      final startTime = start.toDate();
                                      if (end != null) {
                                        final endTime = end.toDate();
                                        return now.isAfter(startTime) &&
                                            now.isBefore(endTime);
                                      }
                                      return now.isAfter(startTime);
                                    }

                                    return data['is_active'] == true;
                                  }).length;
                                } else {
                                  count = snapshot.data!.docs.length;
                                }
                              }
                              return Text(
                                "$count",
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  color: textDark,
                                  letterSpacing: -0.5,
                                  height: 1.0,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 4),
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: textGrey,
                              fontSize: 12,
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
    );
  }
}