import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GlobalBattleHistoryScreen extends StatefulWidget {
  const GlobalBattleHistoryScreen({super.key});

  @override
  State<GlobalBattleHistoryScreen> createState() =>
      _GlobalBattleHistoryScreenState();
}

class _GlobalBattleHistoryScreenState
    extends State<GlobalBattleHistoryScreen> {
  final search_battle = TextEditingController();
  String _searchQuery = "";

  // Color System
  static const Color brandBlue = Color(0xFF2563EB);
  static const Color bgCanvas = Color(0xFFF4F7FF);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);

  // Soft Accent Colors for Card Left Edge
  static const List<Color> accentColors = [
    Color(0xFF2563EB), // Royal Blue
    Color(0xFF8B5CF6), // Purple
    Color(0xFF10B981), // Emerald Green
    Color(0xFFF59E0B), // Amber / Gold
  ];

  @override
  void dispose() {
    search_battle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgCanvas,
      child: Column(
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
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
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

                    // Header Text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Battle History",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "View and track all created battles",
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
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 2. SEARCH BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: surfaceWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: textDark.withAlpha(8),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: search_battle,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase().trim();
                  });
                },
                style: const TextStyle(color: textDark, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: "Search Battle",
                  hintStyle: TextStyle(color: textGrey, fontSize: 13),
                  prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF306AE7), size: 22),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 3. BATTLE HISTORY STREAM LIST WITH IN-LINE "ALL SET" FOOTER
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Battle_Room_Details")
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

                final battleDocs = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final roomName = (data['room_name'] ?? data['battle_name'] ?? '').toString().toLowerCase();
                  final roomCode = (data['room_code'] ?? '').toString().toLowerCase();
                  final winner = (data['winner_name'] ?? '').toString().toLowerCase();

                  return roomName.contains(_searchQuery) ||
                      roomCode.contains(_searchQuery) ||
                      winner.contains(_searchQuery);
                }).toList();

                if (battleDocs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Battles Found",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textGrey,
                      ),
                    ),
                  );
                }

                final bool showFooter = _searchQuery.isEmpty;

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
                  itemCount: showFooter ? battleDocs.length + 1 : battleDocs.length,
                  itemBuilder: (context, index) {
                    // Render "All Set!" badge smoothly at the bottom of the scroll list
                    if (showFooter && index == battleDocs.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 20),
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
                              "There are ${battleDocs.length} total battles recorded",
                              style: const TextStyle(
                                color: textGrey,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    var data = battleDocs[index].data() as Map<String, dynamic>;
                    return _buildBattleCard(data, battleDocs[index].id, index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- BATTLE ITEM CARD WIDGET ---
  Widget _buildBattleCard(Map<String, dynamic> data, String docId, int index) {
    String topTitle = data["room_name"] ?? data["battle_name"] ?? "Quiz Battle";
    String roomCode = data["room_code"] ?? "N/A";

    String formatFirestoreDate(dynamic rawValue) {
      if (rawValue == null) return "N/A";
      if (rawValue is Timestamp) {
        DateTime dt = rawValue.toDate();
        return "${dt.day}/${dt.month}/${dt.year}";
      }
      return rawValue.toString();
    }

    String formatFirestoreTime(dynamic rawValue) {
      if (rawValue == null) return "N/A";
      if (rawValue is Timestamp) {
        DateTime dt = rawValue.toDate();
        int hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
        String minute = dt.minute.toString().padLeft(2, '0');
        String period = dt.hour >= 12 ? "PM" : "AM";
        return "$hour:$minute $period";
      }
      return rawValue.toString();
    }

    String dateStr = formatFirestoreDate(data["battle_date"]);
    String timeStr = formatFirestoreTime(data["start_time"] ?? data["created_at"]);
    String winnerName = data["winner_name"] ?? "Not Declared";

    final Color cardAccentColor = accentColors[index % accentColors.length];

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
                          topTitle,
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
                            Icon(Icons.calendar_today_rounded, size: 14, color: cardAccentColor),
                            const SizedBox(width: 6),
                            Text(
                              dateStr,
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
                            Icon(Icons.access_time_rounded, size: 14, color: cardAccentColor),
                            const SizedBox(width: 6),
                            Text(
                              timeStr,
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
                          .collection("Battle_Room_Details")
                          .doc(docId)
                          .collection("Players")
                          .snapshots(),
                      builder: (context, snapshot) {
                        int participantCount = snapshot.hasData ? snapshot.data!.docs.length : 0;
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