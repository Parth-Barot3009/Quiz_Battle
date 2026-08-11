import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_battle/player/player_navigationbar.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  // Theme Palette
  static const Color brandBlue = Color(0xFF2563EB);
  static const Color bgCanvas = Color(0xFFEBF1FF);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

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
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x1F2563EB),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x142563EB),
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
                  // 1. TOP HEADER BAR WITH REAL-TIME PROFILE AVATAR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "PLAYER",
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

                      // Real-time Profile Avatar Stream
                      StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: currentUserId != null
                            ? FirebaseFirestore.instance
                            .collection('player')
                            .doc(currentUserId)
                            .snapshots()
                            : null,
                        builder: (context, snapshot) {
                          String? imageUrl;
                          if (snapshot.hasData && snapshot.data!.exists) {
                            var data = snapshot.data!.data();
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
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x262563EB),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => player_navigationbar(
                                          currentIndex: 3,
                                        ),
                                      ),
                                    );
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

                  // 2. PROFILE & GREETING BANNER CARD
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('player')
                        .where(
                      'player_email',
                      isEqualTo: FirebaseAuth.instance.currentUser?.email,
                    )
                        .snapshots(),
                    builder: (context, snapshot) {
                      String playerName = "Player";
                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        var data = snapshot.data!.docs.first.data();
                        playerName = data['player_name'] ?? 'Player';
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
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x591D4ED8),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Hello,",
                                  style: TextStyle(
                                    color: Color(0xD9FFFFFF),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  playerName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 58,
                              height: 58,
                              decoration: BoxDecoration(
                                color: const Color(0x33FFFFFF),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: const Color(0x40FFFFFF),
                                ),
                              ),
                              child: const Icon(
                                Icons.emoji_events,
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

                  // 3. STATS GRID (Row: Battles & Wins)
                  Row(
                    children: [
                      // Battles Card (Redirects to Battle History - Index 2)
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => player_navigationbar(
                                  currentIndex: 2,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFFF5F8FF), Color(0xFFE8F1FF)],
                              ),
                              border: Border.all(
                                color: const Color(0xFFD0E1FF),
                                width: 1.2,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x144A7CFF),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Stack(
                                children: [
                                  const Positioned(
                                    right: -10,
                                    bottom: -10,
                                    child: Icon(
                                      Icons.sports_esports,
                                      size: 75,
                                      color: Color(0x144A7CFF),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(7),
                                              decoration: BoxDecoration(
                                                color: surfaceWhite,
                                                borderRadius:
                                                BorderRadius.circular(10),
                                              ),
                                              child: const Icon(
                                                Icons.sports_esports,
                                                color: Color(0xFF4A7CFF),
                                                size: 18,
                                              ),
                                            ),
                                            Container(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFDCE7FF),
                                                borderRadius:
                                                BorderRadius.circular(8),
                                              ),
                                              child: const Text(
                                                "Played Battles",
                                                style: TextStyle(
                                                  color: Color(0xFF4A7CFF),
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('player')
                                              .where(
                                            'player_email',
                                            isEqualTo: FirebaseAuth
                                                .instance
                                                .currentUser
                                                ?.email,
                                          )
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            int totalBattle = 0;

                                            if (snapshot.hasData &&
                                                snapshot
                                                    .data!.docs.isNotEmpty) {
                                              var data = snapshot
                                                  .data!.docs.first
                                                  .data();
                                              totalBattle =
                                                  data['played_battle'] ?? 0;
                                            }

                                            return Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "$totalBattle",
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w900,
                                                    color: textDark,
                                                    letterSpacing: -0.5,
                                                    height: 1.0,
                                                  ),
                                                ),
                                                const SizedBox(height: 3),
                                                const Text(
                                                  "Battles",
                                                  style: TextStyle(
                                                    color: textGrey,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Wins Card
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
                            border: Border.all(
                              color: const Color(0xFFFFE0C8),
                              width: 1.2,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x14FF8A00),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Stack(
                              children: [
                                const Positioned(
                                  right: -10,
                                  bottom: -10,
                                  child: Icon(
                                    Icons.emoji_events,
                                    size: 75,
                                    color: Color(0x14FF8A00),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(7),
                                            decoration: BoxDecoration(
                                              color: surfaceWhite,
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                            child: const Icon(
                                              Icons.emoji_events,
                                              color: Color(0xFFFF8A00),
                                              size: 18,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFFEAD8),
                                              borderRadius:
                                              BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              "Victories",
                                              style: TextStyle(
                                                color: Color(0xFFFF8A00),
                                                fontSize: 9,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('player')
                                            .where(
                                          'player_email',
                                          isEqualTo: FirebaseAuth
                                              .instance
                                              .currentUser
                                              ?.email,
                                        )
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          int totalWins = 0;

                                          if (snapshot.hasData &&
                                              snapshot.data!.docs.isNotEmpty) {
                                            var data = snapshot.data!.docs.first
                                                .data();
                                            totalWins = data['player_win'] ?? 0;
                                          }

                                          return Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "$totalWins",
                                                style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w900,
                                                  color: textDark,
                                                  letterSpacing: -0.5,
                                                  height: 1.0,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              const Text(
                                                "Wins",
                                                style: TextStyle(
                                                  color: textGrey,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
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

                  // 4. UPCOMING BATTLES SECTION
                  const Text(
                    "Upcoming Battles",
                    style: TextStyle(
                      color: textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Battle_Room_Details')
                        .where('start_time', isGreaterThan: Timestamp.now())
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
                          "Error loading battles: ${snapshot.error}",
                          style: const TextStyle(color: textGrey, fontSize: 13),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: surfaceWhite,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: borderColor, width: 1.2),
                          ),
                          child: const Text(
                            "No upcoming battles scheduled.",
                            style: TextStyle(color: textGrey, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      var data = snapshot.data!.docs;

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          var battle = data[index].data();

                          String roomName =
                              battle['room_name'] ?? 'Unnamed Battle';
                          int totalQuestions = battle['questions'] ?? 0;
                          String code = battle['room_code'] ?? 'No code';

                          Timestamp? startTimeStamp =
                          battle['start_time'] as Timestamp?;
                          DateTime? battleDateTime = startTimeStamp?.toDate();

                          String dateString = "TBD";
                          String timeString = "TBD";

                          if (battleDateTime != null) {
                            dateString =
                            "${battleDateTime.day.toString().padLeft(2, '0')}/${battleDateTime.month.toString().padLeft(2, '0')}/${battleDateTime.year}";

                            TimeOfDay timeOfDay = TimeOfDay.fromDateTime(
                              battleDateTime,
                            );
                            timeString = timeOfDay.format(context);
                          }

                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: surfaceWhite,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: borderColor,
                                  width: 1.2,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x051E293B),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: bgCanvas,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(color: borderColor),
                                    ),
                                    child: const Icon(
                                      Icons.sports_esports,
                                      color: textGrey,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
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
                                          "Question: $totalQuestions\n"
                                              "Date: $dateString\n"
                                              "Time: $timeString\n"
                                              "Room Code: $code",
                                          style: const TextStyle(
                                            color: textGrey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
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
}