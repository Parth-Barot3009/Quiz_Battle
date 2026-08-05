import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_battle/organizer/organizer_navigationbar.dart';
import 'package:quiz_battle/player/user_dashboard.dart';

// Internal Model for Leaderboard Items
class PlayerPerformance {
  final String id;
  final String name;
  final String email;
  final int score;
  final int correctAnswers;
  final bool isCurrentUser;

  PlayerPerformance({
    required this.id,
    required this.name,
    this.email = '',
    required this.score,
    required this.correctAnswers,
    this.isCurrentUser = false,
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
  // --- Theme Colors ---
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color darkBlue = Color(0xFF1D4ED8);
  static const Color lightThemeBg = Color(0xFFEFF6FF);
  static const Color cardBg = Colors.white;
  static const Color goldAccent = Color(0xFFFFD700);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);

  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    int wrongAnswers = widget.totalQuestions - widget.myScore;

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
              return const Center(
                child: CircularProgressIndicator(color: primaryBlue),
              );
            }

            // Parse Firebase player data
            List<PlayerPerformance> playersList = [];

            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              for (var doc in snapshot.data!.docs) {
                var data = doc.data() as Map<String, dynamic>;
                String uid = doc.id;
                int playerScore = data["player_score"] ?? 0;
                String playerName = data["player_name"] ?? "Player";
                String playerEmail = data["player_email"] ?? "";

                playersList.add(
                  PlayerPerformance(
                    id: uid,
                    name: playerName,
                    email: playerEmail,
                    score: playerScore,
                    correctAnswers: playerScore, // 1 point per correct answer
                    isCurrentUser: uid == currentUserId,
                  ),
                );
              }
            } else {
              // Fallback if players collection isn't fully ready
              playersList.add(
                PlayerPerformance(
                  id: currentUserId ?? "me",
                  name: FirebaseAuth.instance.currentUser?.displayName ?? "You",
                  email: FirebaseAuth.instance.currentUser?.email ?? "",
                  score: widget.myScore,
                  correctAnswers: widget.myScore,
                  isCurrentUser: true,
                ),
              );
            }

            // Sort players by highest score descending
            playersList.sort((a, b) => b.score.compareTo(a.score));

            // Determine user position and victory status
            int userIndex = playersList.indexWhere((p) => p.isCurrentUser);
            int userRank = (userIndex != -1) ? userIndex + 1 : 1;

            String resultText;
            IconData resultIcon;
            Color resultColor;
            String resultSubtitle;

            if (userRank == 1) {
              resultText = "VICTORY!";
              resultIcon = Icons.emoji_events_rounded;
              resultColor = goldAccent;
              resultSubtitle = "Congratulations! You are the Champion!";
            } else if (userRank == 2) {
              resultText = "2ND PLACE!";
              resultIcon = Icons.workspace_premium_rounded;
              resultColor = const Color(0xFF94A3B8); // Silver Accent
              resultSubtitle = "Great effort! So close to victory.";
            } else if (userRank == 3) {
              resultText = "3RD PLACE!";
              resultIcon = Icons.workspace_premium_rounded;
              resultColor = const Color(0xFFD97706); // Bronze Accent
              resultSubtitle = "Well played! You made the podium.";
            } else {
              resultText = "#$userRank PLACE";
              resultIcon = Icons.sentiment_dissatisfied_rounded;
              resultColor = const Color(0xFFEF4444); // Red Accent
              resultSubtitle = "Better luck next time!";
            }

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- HERO HEADER SECTION ---
                        _buildHeroHeader(
                          resultText: resultText,
                          resultSubtitle: resultSubtitle,
                          resultIcon: resultIcon,
                          resultColor: resultColor,
                          userRank: userRank,
                          myScore: widget.myScore,
                        ),

                        const SizedBox(height: 20),

                        // --- STATS SUMMARY SECTION ---
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            'Your Battle Stats',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        _buildStatisticsCards(
                          correctCount: widget.myScore,
                          wrongCount: wrongAnswers,
                          totalQuestions: widget.totalQuestions,
                        ),

                        const SizedBox(height: 24),

                        // --- LEADERBOARD HEADER ---
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Match Leaderboard',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textDark,
                                ),
                              ),
                              Text(
                                '${playersList.length} Players',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // --- LEADERBOARD LIST ---
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: playersList.length,
                            separatorBuilder: (_, __) =>
                            const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              return _buildLeaderboardTile(
                                player: playersList[index],
                                rank: index + 1,
                                totalQuestions: widget.totalQuestions,
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // --- BOTTOM ACTION BUTTON ---
                _buildBottomActionBar(context),
              ],
            );
          },
        ),
      ),
    );
  }

  // --- HERO HEADER WIDGET ---
  Widget _buildHeroHeader({
    required String resultText,
    required String resultSubtitle,
    required IconData resultIcon,
    required Color resultColor,
    required int userRank,
    required int myScore,
  }) {
    return Stack(
      children: [
        Positioned(
          top: -40,
          left: -40,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [primaryBlue, darkBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: primaryBlue.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Badge
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.groups_rounded, color: Colors.white, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'MULTIPLAYER BATTLE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Avatar Spotlight Frame
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: resultColor, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: resultColor.withOpacity(0.4),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundColor: const Color(0xFFDBEAFE),
                      child: Icon(resultIcon, size: 50, color: resultColor),
                    ),
                  ),
                  if (userRank == 1)
                    const Positioned(
                      top: -14,
                      child: Icon(Icons.workspace_premium_rounded,
                          color: goldAccent, size: 30),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Result Status Title
              Text(
                resultText,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4),

              // Subtitle
              Text(
                resultSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.85),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 18),

              // Total PTS Score Pill
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.stars_rounded,
                        color: primaryBlue, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '$myScore PTS',
                      style: const TextStyle(
                        color: darkBlue,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- STATISTICS CARDS WIDGET ---
  Widget _buildStatisticsCards({
    required int correctCount,
    required int wrongCount,
    required int totalQuestions,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          // Total Correct Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF10B981),
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$correctCount/$totalQuestions',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Correct Answers",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Total Wrong Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.cancel_rounded,
                    color: Color(0xFFEF4444),
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    wrongCount.toString(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Wrong Answers",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- LEADERBOARD TILE WIDGET ---
  Widget _buildLeaderboardTile({
    required PlayerPerformance player,
    required int rank,
    required int totalQuestions,
  }) {
    final double accuracy =
    totalQuestions > 0 ? player.correctAnswers / totalQuestions : 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: player.isCurrentUser
            ? Border.all(color: primaryBlue, width: 2)
            : Border.all(color: Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildRankBadge(rank),
              const SizedBox(width: 12),
              const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFFEFF6FF),
                child: Icon(Icons.person, color: Color(0xFF64748B), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.isCurrentUser
                          ? '${player.name} (You)'
                          : player.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: player.isCurrentUser
                            ? FontWeight.bold
                            : FontWeight.w600,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${player.correctAnswers}/$totalQuestions Correct',
                      style: const TextStyle(
                        fontSize: 12,
                        color: textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${player.score} pts',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: player.isCurrentUser ? primaryBlue : textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: accuracy,
              minHeight: 5,
              backgroundColor: const Color(0xFFEFF6FF),
              valueColor: AlwaysStoppedAnimation<Color>(
                rank == 1 ? const Color(0xFF10B981) : primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- RANK BADGE HELPER ---
  Widget _buildRankBadge(int rank) {
    Color color;
    switch (rank) {
      case 1:
        color = goldAccent;
        break;
      case 2:
        color = const Color(0xFF94A3B8);
        break;
      case 3:
        color = const Color(0xFFD97706);
        break;
      default:
        color = textMuted;
    }

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '#$rank',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w900,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // --- BOTTOM ACTION BAR ---
  Widget _buildBottomActionBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: cardBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: primaryBlue, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const Org_Navigationbar(),
              ),
                  (route) => false,
            );
          },
          child: const Text(
            "Back to Dashboard",
            style: TextStyle(
              color: primaryBlue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}