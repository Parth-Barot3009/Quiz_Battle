import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quiz_battle/organizer/organizer_navigationbar.dart';

class OrganizerBattleHistory extends StatefulWidget {
  const OrganizerBattleHistory({super.key});

  @override
  State<OrganizerBattleHistory> createState() => _OrganizerBattleHistoryState();
}

class _OrganizerBattleHistoryState extends State<OrganizerBattleHistory> {
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

  // Helper method to format time into "05:05 AM"
  String formatTimeString(String rawTime, DateTime fallbackDate) {
    if (rawTime.isEmpty || rawTime == "N/A") {
      return DateFormat("hh:mm a").format(fallbackDate);
    }

    try {
      // Handles "13:05" or "05:05" 24-hour format
      DateTime parsed = DateFormat("HH:mm").parse(rawTime);
      return DateFormat("hh:mm a").format(parsed);
    } catch (_) {
      try {
        // Handles "5:5 AM" or "1:34 AM" formats
        DateTime parsed = DateFormat("h:mm a").parse(rawTime);
        return DateFormat("hh:mm a").format(parsed);
      } catch (_) {
        return rawTime; // Fallback to raw string if parsing fails
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        Icons.emoji_events_outlined,
                        size: 90,
                        color: Colors.white.withAlpha(25),
                      ),
                    ),
                    Positioned(
                      right: -10,
                      bottom: -20,
                      child: Icon(
                        Icons.sports_esports_outlined,
                        size: 70,
                        color: Colors.white.withAlpha(20),
                      ),
                    ),

                    // Navigation Back & Header Text
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Battle History",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "View all your past battles",
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

          // 2. FIRESTORE STREAM LIST
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Battle_Room_Details')
                  .where(
                'o_email',
                isEqualTo: FirebaseAuth.instance.currentUser?.email,
              )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: brandBlue),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      "Something went wrong",
                      style: TextStyle(color: textGrey, fontSize: 14),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return _buildEmptyState();
                }

                var roomDetails = snapshot.data!.docs;

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  itemCount: roomDetails.length,
                  itemBuilder: (context, index) {
                    var roomDetailsList = roomDetails[index];

                    Timestamp timestamp = roomDetailsList['battle_date'];
                    DateTime date = timestamp.toDate();

                    // Formatted Date (e.g., "01/08/2026")
                    String formattedDate = DateFormat("dd/MM/yyyy").format(date);

                    // Formatted Time
                    dynamic rawStartTime = roomDetailsList['start_time'];
                    String startTime;

                    if (rawStartTime is Timestamp) {
                      startTime = DateFormat("hh:mm a").format(rawStartTime.toDate());
                    } else {
                      startTime = formatTimeString(
                        rawStartTime?.toString() ?? "",
                        date,
                      );
                    }

                    String roomName = roomDetailsList['room_name'] ?? 'Battle Room';
                    String roomCode = roomDetailsList['room_code'];
                    String winnerName = roomDetailsList['winner_name'] ?? 'Pending / TBD';

                    final Color cardAccentColor = accentColors[index % accentColors.length];

                    return _buildBattleCard(
                      roomName: roomName,
                      formattedDate: formattedDate,
                      startTime: startTime,
                      roomCode: roomCode,
                      winnerName: winnerName,
                      cardAccentColor: cardAccentColor,
                    );
                  },
                );
              },
            ),
          ),

          // 3. BOTTOM FOOTER COUNTER BADGE
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Battle_Room_Details')
                .where(
              'o_email',
              isEqualTo: FirebaseAuth.instance.currentUser?.email,
            )
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
    required String winnerName,
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

                  // Participants Row
                  _buildDataRow(
                    icon: Icons.group_outlined,
                    title: "Participants",
                    valueWidget: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Battle_Room_Details')
                          .doc(roomCode)
                          .collection('Players')
                          .snapshots(),
                      builder: (context, snapshot) {
                        int participantCount =
                        snapshot.hasData ? snapshot.data!.docs.length : 0;
                        return Text(
                          "$participantCount",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: cardAccentColor,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Winner Row
                  _buildDataRow(
                    icon: Icons.workspace_premium_outlined,
                    title: "Winner",
                    valueWidget: Text(
                      winnerName,
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
            Icons.history_toggle_off_rounded,
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
            "There are currently no battles created.",
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