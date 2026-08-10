import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Org_BattleRoom extends StatefulWidget {
  final String roomCode;

  const Org_BattleRoom({super.key, required this.roomCode});

  @override
  State<Org_BattleRoom> createState() => _Org_BattleRoomState();
}

class _Org_BattleRoomState extends State<Org_BattleRoom> {
  // Helper method to format ONLY duration in Hours and Minutes
  String _formatTimeAllocation(Timestamp? startTimestamp, Timestamp? endTimestamp) {
    if (startTimestamp == null || endTimestamp == null) {
      return "N/A";
    }

    final DateTime start = startTimestamp.toDate();
    final DateTime end = endTimestamp.toDate();

    final Duration diff = end.difference(start);

    // Safety fallback for negative or equal time ranges
    if (diff.isNegative || diff.inSeconds == 0) {
      return "0 min";
    }

    final int hours = diff.inHours;
    final int minutes = diff.inMinutes % 60;

    // Return pure hours and minutes string
    if (hours > 0 && minutes > 0) {
      return "$hours hr $minutes min";
    } else if (hours > 0) {
      return "$hours hr";
    } else {
      return "$minutes min";
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    // Responsive Spacing & Scaling Factors
    final horizontalPadding = (screenWidth * 0.05).clamp(16.0, 32.0);
    final isTabletOrDesktop = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Battle Room Dashboard",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF3B82F6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            // Caps max width for wide tablet/desktop viewports
            constraints: const BoxConstraints(maxWidth: 700),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(horizontalPadding),
                child: Column(
                  children: [
                    // 1. Live Room Code Banner
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: isTabletOrDesktop ? 32 : 24,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A3B82F6),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Live Room Code",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 8),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              widget.roomCode,
                              style: TextStyle(
                                fontSize: (screenWidth * 0.1).clamp(32.0, 48.0),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Share this code with participants to begin",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 2. Configuration Overview Card
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('Battle_Room_Details')
                          .doc(widget.roomCode)
                          .snapshots(),
                      builder: (context, snapshot) {
                        Map<String, dynamic>? data = snapshot.data?.data();

                        String battleName = data?['room_name'] ?? 'N/A';
                        int totalQuestion = data?['questions'] ?? 0;

                        Timestamp? startTimestamp =
                        data?['start_time'] as Timestamp?;
                        Timestamp? endTimestamp =
                        data?['end_time'] as Timestamp?;

                        // Execute formatting logic (hours & minutes only)
                        String durationText =
                        _formatTimeAllocation(startTimestamp, endTimestamp);

                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x05000000),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Header Row
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEFF6FF),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.bar_chart_rounded,
                                      size: 20,
                                      color: Color(0xFF3B82F6),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Text(
                                      "Configuration Overview",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Divider(height: 1, color: Color(0xFFF1F5F9)),
                              ),

                              // Dynamic Responsive Config Rows
                              _buildConfigRow(
                                icon: Icons.quiz_outlined,
                                label: "Name Of Battle",
                                value: battleName,
                              ),

                              const SizedBox(height: 16),

                              _buildConfigRow(
                                icon: Icons.format_list_bulleted,
                                label: "Total Questions",
                                value: "$totalQuestion Questions",
                              ),

                              const SizedBox(height: 16),

                              _buildConfigRow(
                                icon: Icons.timer_outlined,
                                label: "Time Allocation",
                                value: durationText,
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // 3. Connected Participants Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x05000000),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Card Title Bar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEFF6FF),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.group_outlined,
                                        size: 20,
                                        color: Color(0xFF3B82F6),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Flexible(
                                      child: Text(
                                        "Connected Participants",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E293B),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 8),

                              // Dynamic Counter Badge
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('Battle_Room_Details')
                                    .doc(widget.roomCode)
                                    .collection('Players')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  int playerCount = snapshot.hasData
                                      ? snapshot.data!.docs.length
                                      : 0;
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEFF6FF),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "$playerCount Active",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF3B82F6),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Dynamic Player List
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Battle_Room_Details')
                                .doc(widget.roomCode)
                                .collection('Players')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Text(
                                    "Waiting for participants to join...",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                );
                              }

                              var data = snapshot.data!.docs;
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  var player =
                                  data[index].data() as Map<String, dynamic>;
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8FAFC),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              const CircleAvatar(
                                                radius: 18,
                                                backgroundColor: Color(0xFF3B82F6),
                                                child: Icon(
                                                  Icons.person,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      player['player_name'] ??
                                                          'Player',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: Color(0xFF1E293B),
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      "Online • Ready to start",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color:
                                                        Colors.grey.shade500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.check_circle,
                                          color: Color(0xFF22C55E),
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  );
                                },
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
      ),
    );
  }

  // Helper row builder to ensure clean text-overflow handling
  Widget _buildConfigRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: Colors.grey.shade500,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2563EB),
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}