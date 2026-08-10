import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quiz_battle/organizer/organizer_dashboard.dart';
import 'package:quiz_battle/organizer/organizer_navigationbar.dart';
import 'package:quiz_battle/player/player_navigationbar.dart';

class PlayerBattleHistory extends StatefulWidget {
  const PlayerBattleHistory({super.key});

  @override
  State<PlayerBattleHistory> createState() => _PlayerBattleHistoryState();
}

class _PlayerBattleHistoryState extends State<PlayerBattleHistory> {
  // Theme Palette
  static const Color brandBlue = Color(0xFF2563EB);
  static const Color bgCanvas = Color(0xFFF4F7FF);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);

  // Dynamic Card Left Edge Accent Colors
  static const List<Color> accentColors = [
    Color(0xFF2563EB), // Royal Blue
    Color(0xFF8B5CF6), // Purple
    Color(0xFF10B981), // Emerald Green
    Color(0xFFF59E0B), // Amber / Gold
  ];

  // Helper method to format time safely into "05:05 AM"
  String formatTimeString(dynamic rawTime, DateTime fallbackDate) {
    if (rawTime == null) {
      return DateFormat("hh:mm a").format(fallbackDate);
    }

    if (rawTime is Timestamp) {
      return DateFormat("hh:mm a").format(rawTime.toDate());
    }

    String timeStr = rawTime.toString().trim();
    if (timeStr.isEmpty || timeStr == "N/A") {
      return DateFormat("hh:mm a").format(fallbackDate);
    }

    try {
      DateTime parsed = DateFormat("HH:mm").parse(timeStr);
      return DateFormat("hh:mm a").format(parsed);
    } catch (_) {
      try {
        DateTime parsed = DateFormat("h:mm a").parse(timeStr);
        return DateFormat("hh:mm a").format(parsed);
      } catch (_) {
        return timeStr;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    // Safety check if user is not logged in
    if (currentUser == null) {
      return Scaffold(
        backgroundColor: bgCanvas,
        body: const Center(
          child: Text(
            "Please log in to view your battle history.",
            style: TextStyle(color: textDark, fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgCanvas,
      body: Column(
        children: [
          // 1. TOP HEADER BANNER
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4A7CFF),
                  Color(0xFF306AE7),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 24, 28),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Background Watermark Icons
                    Positioned(
                      right: 40,
                      top: -10,
                      child: Icon(
                        Icons.sports_esports_outlined,
                        size: 90,
                        color: Colors.white.withAlpha(25),
                      ),
                    ),
                    Positioned(
                      right: -10,
                      bottom: -20,
                      child: Icon(
                        Icons.emoji_events_outlined,
                        size: 70,
                        color: Colors.white.withAlpha(20),
                      ),
                    ),

                    // Navigation Back & Header Text
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          child: InkWell(
                            onTap: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => player_navigationbar(),
                              ),
                            ),
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Color(0xFF306AE7),
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "My Played Battles",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "View your participation history",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 2. FIRESTORE COLLECTIONGROUP STREAM LIST
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collectionGroup('Players')
                  .where('player_id', isEqualTo: currentUser.uid)
                  .snapshots(),
              builder: (context, playerSnapshot) {
                if (playerSnapshot.hasError) {
                  debugPrint("Firestore CollectionGroup Error: ${playerSnapshot.error}");
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "Error loading battles.\n\n${playerSnapshot.error}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  );
                }

                if (playerSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: brandBlue),
                  );
                }

                if (!playerSnapshot.hasData || playerSnapshot.data!.docs.isEmpty) {
                  return _buildEmptyState();
                }

                var playerDocs = playerSnapshot.data!.docs;

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  itemCount: playerDocs.length,
                  itemBuilder: (context, index) {
                    var playerDoc = playerDocs[index];
                    Map<String, dynamic> playerData =
                    playerDoc.data() as Map<String, dynamic>;

                    // Parent room reference points to Battle_Room_Details/{roomCode}
                    DocumentReference? parentRoomRef = playerDoc.reference.parent.parent;

                    if (parentRoomRef == null) return const SizedBox.shrink();

                    final Color cardAccentColor = accentColors[index % accentColors.length];

                    return StreamBuilder<DocumentSnapshot>(
                      stream: parentRoomRef.snapshots(),
                      builder: (context, roomSnapshot) {
                        if (!roomSnapshot.hasData || !roomSnapshot.data!.exists) {
                          return const SizedBox.shrink();
                        }

                        Map<String, dynamic> roomData =
                        roomSnapshot.data!.data() as Map<String, dynamic>;

                        // Date Parsing
                        Timestamp? timestamp = roomData['battle_date'];
                        DateTime date = timestamp?.toDate() ?? DateTime.now();
                        String formattedDate = DateFormat("dd/MM/yyyy").format(date);

                        // Time Parsing
                        String startTime = formatTimeString(roomData['start_time'], date);

                        // Room details mapped directly from your schema
                        String roomName = roomData['room_name'] ?? 'Battle Room';
                        String roomCode = roomData['room_code'] ?? parentRoomRef.id;

                        // Player Score mapped directly from your schema
                        int myScore = playerData['player_score'] ?? 0;

                        return _buildBattleCard(
                          roomName: roomName,
                          formattedDate: formattedDate,
                          startTime: startTime,
                          roomCode: roomCode,
                          myScore: myScore,
                          cardAccentColor: cardAccentColor,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),

          // 3. BOTTOM FOOTER COUNTER BADGE
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collectionGroup('Players')
                .where('player_id', isEqualTo: currentUser.uid)
                .snapshots(),
            builder: (context, snapshot) {
              final total = snapshot.hasData ? snapshot.data!.docs.length : 0;
              return Container(
                padding: const EdgeInsets.only(bottom: 16, top: 8),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: surfaceWhite,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: brandBlue.withAlpha(20),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.emoji_events_rounded,
                        color: Color(0xFF306AE7),
                        size: 26,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "All Set!",
                      style: TextStyle(
                        color: Color(0xFF306AE7),
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "There are $total total battles recorded",
                      style: const TextStyle(
                        color: textGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // --- BATTLE ITEM CARD WIDGET ---
  Widget _buildBattleCard({
    required String roomName,
    required String formattedDate,
    required String startTime,
    required String roomCode,
    required int myScore,
    required Color cardAccentColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: textDark.withAlpha(6),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Left Side Dynamic Accent Bar
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 5,
                color: cardAccentColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row with Trophy Icon & Title
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cardAccentColor.withAlpha(25),
                        ),
                        child: Icon(
                          Icons.emoji_events_rounded,
                          color: cardAccentColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          roomName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Date & Time Banner Box
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: bgCanvas,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 14,
                              color: cardAccentColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: textDark,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 14,
                              color: cardAccentColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              startTime,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: textDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Room Code Row
                  _buildDataRow(
                    icon: Icons.vpn_key_outlined,
                    title: "Room Code",
                    valueWidget: Text(
                      roomCode,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: cardAccentColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // My Score Row
                  _buildDataRow(
                    icon: Icons.military_tech_outlined,
                    title: "My Score",
                    valueWidget: Text(
                      "$myScore pts",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: cardAccentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER DATA ROW ---
  Widget _buildDataRow({
    required IconData icon,
    required String title,
    required Widget valueWidget,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: textGrey),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color: textGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        valueWidget,
      ],
    );
  }

  // --- EMPTY STATE WIDGET ---
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.videogame_asset_off_rounded,
            size: 60,
            color: textGrey,
          ),
          SizedBox(height: 12),
          Text(
            "No Battles Found",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "You haven't played any battles yet!",
            style: TextStyle(
              fontSize: 12,
              color: textGrey,
            ),
          ),
        ],
      ),
    );
  }
}