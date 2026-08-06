import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
          // 1. GRADIENT TOP HEADER BANNER
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF4A7CFF), Color(0xFF306AE7)],
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
                    Positioned(
                      right: 10,
                      top: -10,
                      child: Icon(
                        Icons.sports_esports_rounded,
                        size: 90,
                        color: Colors.white.withAlpha(25),
                      ),
                    ),
                    Positioned(
                      right: 70,
                      bottom: -20,
                      child: Icon(
                        Icons.star_rounded,
                        size: 60,
                        color: Colors.white.withAlpha(20),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
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

          const SizedBox(height: 12),

          // 2. QUERY ALL 'Players' SUBCOLLECTIONS WHERE player_id MATCHES CURRENT USER
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
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.videogame_asset_off_rounded,
                          size: 48,
                          color: textGrey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "You haven't played any battles yet!",
                          style: TextStyle(color: textGrey, fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }

                var playerDocs = playerSnapshot.data!.docs;

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: playerDocs.length,
                  itemBuilder: (context, index) {
                    var playerDoc = playerDocs[index];
                    Map<String, dynamic> playerData =
                    playerDoc.data() as Map<String, dynamic>;

                    // Parent room reference points to Battle_Room_Details/{roomCode}
                    DocumentReference? parentRoomRef = playerDoc.reference.parent.parent;

                    if (parentRoomRef == null) return const SizedBox.shrink();

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

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: surfaceWhite,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: borderColor, width: 1.2),
                            boxShadow: [
                              BoxShadow(
                                color: textDark.withAlpha(6),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 5,
                                    color: const Color(0xFF306AE7),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: Column(
                                    children: [
                                      // Room Title Row
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF306AE7),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.emoji_events_rounded,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              roomName,
                                              style: const TextStyle(
                                                color: textDark,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 14),

                                      // Date & Time Box
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF8FAFC),
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.calendar_today_rounded,
                                              size: 16,
                                              color: brandBlue,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              formattedDate,
                                              style: const TextStyle(
                                                color: textDark,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              height: 14,
                                              width: 1,
                                              color: borderColor,
                                            ),
                                            const Spacer(),
                                            const Icon(
                                              Icons.access_time_rounded,
                                              size: 16,
                                              color: brandBlue,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              startTime,
                                              style: const TextStyle(
                                                color: textDark,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 8),
                                        child: Divider(
                                          color: Color(0xFFF1F5F9),
                                          height: 1,
                                        ),
                                      ),

                                      // Score Row
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFEFF6FF),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.military_tech_rounded,
                                              size: 16,
                                              color: brandBlue,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          const Text(
                                            "My Score",
                                            style: TextStyle(
                                              color: textDark,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            "$myScore pts",
                                            style: const TextStyle(
                                              color: brandBlue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 8),
                                        child: Divider(
                                          color: Color(0xFFF1F5F9),
                                          height: 1,
                                        ),
                                      ),

                                      // Room Code Row
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFEFF6FF),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.pin_rounded,
                                              size: 16,
                                              color: brandBlue,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          const Text(
                                            "Room Code",
                                            style: TextStyle(
                                              color: textDark,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            roomCode,
                                            style: const TextStyle(
                                              color: brandBlue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
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
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}