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
  final search_battle = TextEditingController();
  String _searchQuery = "";

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

  @override
  void dispose() {
    search_battle.dispose();
    super.dispose();
  }

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

    if (currentUser == null) {
      return Container(
        color: bgCanvas,
        child: const Center(
          child: Text(
            "Please log in to view your battle history.",
            style: TextStyle(color: textDark, fontSize: 16),
          ),
        ),
      );
    }

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

                    // Header Text
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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

          // 3. FIRESTORE COLLECTIONGROUP STREAM LIST WITH IN-LINE "ALL SET" FOOTER
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

                // FutureBuilder to resolve and filter parent Battle details before list rendering
                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: Future.wait(
                    playerDocs.map((playerDoc) async {
                      Map<String, dynamic> playerData =
                      playerDoc.data() as Map<String, dynamic>;
                      DocumentReference? parentRoomRef = playerDoc.reference.parent.parent;

                      if (parentRoomRef == null) return <String, dynamic>{};

                      DocumentSnapshot roomSnapshot = await parentRoomRef.get();
                      if (!roomSnapshot.exists) return <String, dynamic>{};

                      Map<String, dynamic> roomData =
                      roomSnapshot.data() as Map<String, dynamic>;

                      return {
                        'playerData': playerData,
                        'roomData': roomData,
                        'roomCode': roomData['room_code'] ?? parentRoomRef.id,
                        'roomName': roomData['room_name'] ?? 'Battle Room',
                        'winnerName': roomData['winner_name'] ?? 'Pending',
                      };
                    }),
                  ),
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: brandBlue),
                      );
                    }

                    final allMatches = (asyncSnapshot.data ?? [])
                        .where((item) => item.isNotEmpty)
                        .toList();

                    final filteredBattles = allMatches.where((item) {
                      final roomName = item['roomName'].toString().toLowerCase();
                      final roomCode = item['roomCode'].toString().toLowerCase();
                      final winner = item['winnerName'].toString().toLowerCase();

                      return roomName.contains(_searchQuery) ||
                          roomCode.contains(_searchQuery) ||
                          winner.contains(_searchQuery);
                    }).toList();

                    if (filteredBattles.isEmpty) {
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
                      itemCount: showFooter ? filteredBattles.length + 1 : filteredBattles.length,
                      itemBuilder: (context, index) {
                        // Render "All Set!" badge smoothly at the bottom of the scroll list
                        if (showFooter && index == filteredBattles.length) {
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
                                  "There are ${filteredBattles.length} total battles recorded",
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

                        final battleItem = filteredBattles[index];
                        final Map<String, dynamic> roomData = battleItem['roomData'];
                        final Map<String, dynamic> playerData = battleItem['playerData'];

                        Timestamp? timestamp = roomData['battle_date'];
                        DateTime date = timestamp?.toDate() ?? DateTime.now();
                        String formattedDate = DateFormat("dd/MM/yyyy").format(date);
                        String startTime = formatTimeString(roomData['start_time'], date);
                        String roomName = battleItem['roomName'];
                        String roomCode = battleItem['roomCode'];
                        int myScore = playerData['player_score'] ?? 0;

                        final Color cardAccentColor = accentColors[index % accentColors.length];

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