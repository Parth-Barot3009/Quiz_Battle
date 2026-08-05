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
  // Theme Colors
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color darkBlue = Color(0xFF1D4ED8);
  static const Color lightBg = Color(0xFFEFF6FF);
  static const Color cardBg = Colors.white;
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBg,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER BANNER ---
            _buildHeader(context),

            // --- BATTLE HISTORY LIST ---
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Battle_Room_Details")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: primaryBlue,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error loading battles: ${snapshot.error}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return _buildEmptyState();
                  }

                  final battleDocs = snapshot.data!.docs;

                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: battleDocs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      var data =
                      battleDocs[index].data() as Map<String, dynamic>;
                      return _buildBattleCard(data, battleDocs[index].id);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HEADER BANNER WIDGET ---
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryBlue, darkBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x332563EB),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Battle History",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "View all created battles",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(
                Icons.emoji_events_outlined,
                color: Colors.white24,
                size: 48,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- BATTLE ITEM CARD ---
  // --- BATTLE ITEM CARD ---
  Widget _buildBattleCard(Map<String, dynamic> data, String docId) {
    // 1. Display room_name near trophy icon (top title)
    String topTitle =
        data["room_name"] ?? data["battle_name"] ?? "Quiz Battle";

    // 2. Fetch room_code to display above participants
    String roomCode = data["room_code"] ?? "N/A";

    // Safe Timestamp conversion
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

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Left Blue Accent Bar
              Container(
                width: 6,
                color: primaryBlue,
              ),

              // Content Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- ROOM NAME & TROPHY BADGE ---
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: primaryBlue.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.emoji_events_rounded,
                              color: primaryBlue,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              topTitle, // Displays room_name here
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textDark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Date & Time Container
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: lightBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_today_rounded,
                                    size: 16, color: primaryBlue),
                                const SizedBox(width: 8),
                                Text(
                                  dateStr,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: textDark,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.access_time_rounded,
                                    size: 16, color: primaryBlue),
                                const SizedBox(width: 8),
                                Text(
                                  timeStr,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: textDark,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // --- ROOM CODE ROW (ADDED ABOVE PARTICIPANTS) ---
                      Row(
                        children: [
                          const Icon(Icons.vpn_key_outlined,
                              size: 18, color: textMuted),
                          const SizedBox(width: 8),
                          const Text(
                            "Room Code",
                            style: TextStyle(
                           fontSize: 14,
                              color: textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            roomCode,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: primaryBlue,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Participants Row
                      Row(
                        children: [
                          const Icon(Icons.group_outlined,
                              size: 18, color: textMuted),
                          const SizedBox(width: 8),
                          const Text(
                            "Participants",
                            style: TextStyle(
                              fontSize: 14,
                              color: textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("Battle_Room_Details")
                                .doc(docId)
                                .collection("Players")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Text(
                                  "...",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: primaryBlue,
                                  ),
                                );
                              }

                              int participantCount =
                                  snapshot.data!.docs.length;

                              return Text(
                                "$participantCount",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: primaryBlue,
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Winner Row
                      Row(
                        children: [
                          const Icon(Icons.workspace_premium_outlined,
                              size: 18, color: textMuted),
                          const SizedBox(width: 8),
                          const Text(
                            "Winner",
                            style: TextStyle(
                              fontSize: 14,
                              color: textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            winnerName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- EMPTY STATE WIDGET ---
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_toggle_off_rounded,
            size: 70,
            color: textMuted.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          const Text(
            "No Battles Found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "There are currently no battles created in the system.",
            style: TextStyle(
              fontSize: 14,
              color: textMuted,
            ),
          ),
        ],
      ),
    );
  }
}