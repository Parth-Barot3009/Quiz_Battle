import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_battle/organizer/organizer_navigationbar.dart';
import 'package:quiz_battle/player/player_navigationbar.dart';

class PlayerPerformance {
  final String id;
  final String name;
  final String email;

  final int correct;
  final int wrong;

  final int points;
  final int bonusPoints;
  final int finalPoints;

  final int rank;

  final double totalTime;

  final bool isCurrentUser;

  PlayerPerformance({
    required this.id,
    required this.name,
    required this.email,
    required this.correct,
    required this.wrong,
    required this.points,
    required this.bonusPoints,
    required this.finalPoints,
    required this.rank,
    required this.totalTime,
    required this.isCurrentUser,
  });
}

class ResultScreen extends StatefulWidget {
  final String battleId;
  final int myScore;
  final int totalQuestions;

  const ResultScreen({
    super.key,
    required this.battleId,
    required this.myScore,
    required this.totalQuestions,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color darkBlue = Color(0xFF1D4ED8);
  static const Color lightThemeBg = Color(0xFFEFF6FF);
  static const Color cardBg = Colors.white;
  static const Color goldAccent = Color(0xFFFFD700);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    // Update player's stats once when the screen loads
    _updatePlayerScore();
  }

  Future<void> _updatePlayerScore() async {
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) return;

    try {
      // 1. Fetch player document from the subcollection to check rank
      final doc = await FirebaseFirestore.instance
          .collection("Battle_Room_Details")
          .doc(widget.battleId)
          .collection("Players")
          .doc(currentUserId)
          .get();

      if (doc.exists) {
        final data = doc.data();
        final int rank = data?["rank"] ?? 999;

        // 2. Reference the main 'player' collection from your Firestore console
        final playerRef = FirebaseFirestore.instance
            .collection("player")
            .doc(currentUserId);

        // 3. Atomically increment stats
        Map<String, dynamic> updateData = {
          "played_battle": FieldValue.increment(1),
        };

        // If the user came in 1st place, increment 'player_win'
        if (rank == 1) {
          updateData["player_win"] = FieldValue.increment(1);
        }

        await playerRef.update(updateData);
      }
    } catch (e) {
      debugPrint("Error updating player score: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      backgroundColor: lightThemeBg,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Battle_Room_Details")
              .doc(widget.battleId)
              .collection("Players")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            List<PlayerPerformance> playersList = [];

            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              for (var doc in snapshot.data!.docs) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

                String rawName = (data["player_name"] ?? "").toString().trim();
                String email = (data["player_email"] ?? "").toString();

                String displayName = rawName.isNotEmpty
                    ? rawName
                    : (email.contains('@') ? email.split('@').first : "Player");

                playersList.add(
                  PlayerPerformance(
                    id: doc.id,
                    name: displayName,
                    email: email,
                    correct: data["correct"] ?? 0,
                    wrong: data["wrong"] ?? 0,
                    points: data["points"] ?? 0,
                    bonusPoints: data["bonusPoints"] ?? 0,
                    finalPoints: data["finalPoints"] ?? 0,
                    rank: data["rank"] ?? 999,
                    totalTime: (data["totalTime"] ?? 0).toDouble(),
                    isCurrentUser: doc.id == currentUserId,
                  ),
                );
              }
            }

            playersList.sort((a, b) => a.rank.compareTo(b.rank));

            PlayerPerformance me = playersList.firstWhere(
                  (e) => e.isCurrentUser,
              orElse: () => PlayerPerformance(
                id: "",
                name: "You",
                email: "",
                correct: widget.myScore,
                wrong: widget.totalQuestions - widget.myScore,
                points: widget.myScore * 10,
                bonusPoints: 0,
                finalPoints: widget.myScore * 10,
                rank: 1,
                totalTime: 0,
                isCurrentUser: true,
              ),
            );

            int userRank = me.rank;

            String resultText;
            String resultSubtitle;
            IconData resultIcon;
            Color resultColor;

            if (userRank == 1) {
              resultText = "VICTORY!";
              resultSubtitle = "Congratulations! You are the Champion!";
              resultIcon = Icons.emoji_events;
              resultColor = goldAccent;
            } else if (userRank == 2) {
              resultText = "2ND PLACE";
              resultSubtitle = "Excellent Performance!";
              resultIcon = Icons.workspace_premium;
              resultColor = Colors.grey;
            } else if (userRank == 3) {
              resultText = "3RD PLACE";
              resultSubtitle = "Great Job!";
              resultIcon = Icons.workspace_premium;
              resultColor = Colors.orange;
            } else {
              resultText = "#$userRank";
              resultSubtitle = "Better Luck Next Time";
              resultIcon = Icons.sentiment_neutral;
              resultColor = Colors.red;
            }

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildHeroHeader(
                          resultText: resultText,
                          resultSubtitle: resultSubtitle,
                          resultIcon: resultIcon,
                          resultColor: resultColor,
                          userRank: userRank,
                          player: me,
                        ),

                        const SizedBox(height: 20),

                        _buildStatisticsCards(
                          player: me,
                          totalQuestions: widget.totalQuestions,
                        ),

                        const SizedBox(height: 25),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Leaderboard",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text("${playersList.length} Players"),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: playersList.length,
                            separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              return _buildLeaderboardTile(
                                player: playersList[index],
                                totalQuestions: widget.totalQuestions,
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),

                _buildBottomActionBar(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeroHeader({
    required String resultText,
    required String resultSubtitle,
    required IconData resultIcon,
    required Color resultColor,
    required int userRank,
    required PlayerPerformance player,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(18),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [primaryBlue, darkBlue]),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.white,
            child: Icon(resultIcon, size: 45, color: resultColor),
          ),

          const SizedBox(height: 18),

          Text(
            resultText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            resultSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withOpacity(.9), fontSize: 15),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _heroItem("Rank", "#${player.rank}", Icons.workspace_premium),

              _heroItem("Final", "${player.finalPoints}", Icons.stars),

              _heroItem("Bonus", "+${player.bonusPoints}", Icons.card_giftcard),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),

        const SizedBox(height: 6),

        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),

        Text(title, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildStatisticsCards({
    required PlayerPerformance player,
    required int totalQuestions,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _statCard(
                  Icons.check_circle,
                  Colors.green,
                  "Correct",
                  "${player.correct}",
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _statCard(
                  Icons.cancel,
                  Colors.red,
                  "Wrong",
                  "${player.wrong}",
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _statCard(
                  Icons.timer,
                  Colors.orange,
                  "Time",
                  "${player.totalTime.toStringAsFixed(2)} s",
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _statCard(
                  Icons.star,
                  primaryBlue,
                  "Points",
                  "${player.points}",
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _statCard(
                  Icons.card_giftcard,
                  Colors.purple,
                  "Bonus",
                  "${player.bonusPoints}",
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _statCard(
                  Icons.emoji_events,
                  Colors.amber,
                  "Final",
                  "${player.finalPoints}",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard(IconData icon, Color color, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 8),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),

          const SizedBox(height: 10),

          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          Text(title),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTile({
    required PlayerPerformance player,
    required int totalQuestions,
  }) {
    double accuracy = totalQuestions == 0 ? 0 : player.correct / totalQuestions;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: player.isCurrentUser ? const Color(0xFFE8F1FF) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: player.isCurrentUser ? primaryBlue : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 8),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildRankBadge(player.rank),

              const SizedBox(width: 12),

              CircleAvatar(
                radius: 22,
                backgroundColor: primaryBlue.withOpacity(.1),
                child: const Icon(Icons.person, color: primaryBlue),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.isCurrentUser
                          ? "${player.name} (You)"
                          : player.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      "${player.correct}/$totalQuestions Correct",
                      style: const TextStyle(color: Colors.grey),
                    ),

                    Text(
                      "${player.totalTime.toStringAsFixed(2)} sec",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${player.finalPoints} pts",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),

                  Text(
                    "+${player.bonusPoints}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 15),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: accuracy,
              minHeight: 8,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                player.rank == 1 ? Colors.green : primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankBadge(int rank) {
    Color badgeColor;
    IconData icon;

    switch (rank) {
      case 1:
        badgeColor = Colors.amber;
        icon = Icons.emoji_events;
        break;

      case 2:
        badgeColor = Colors.grey;
        icon = Icons.workspace_premium;
        break;

      case 3:
        badgeColor = Colors.orange;
        icon = Icons.workspace_premium;
        break;

      default:
        badgeColor = primaryBlue;
        icon = Icons.military_tech;
    }

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(.15),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: rank <= 3
            ? Icon(icon, color: badgeColor, size: 22)
            : Text(
          "$rank",
          style: TextStyle(
            color: badgeColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: cardBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => player_navigationbar()),
                  (route) => false,
            );
          },
          child: const Text(
            "Back to Dashboard",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}