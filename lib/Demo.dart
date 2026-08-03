import 'package:flutter/material.dart';

class QuizPlayer {
  final String name;
  final String email;
  final int score;
  final int correctAnswers;
  final int totalQuestions;
  final String avatarUrl;
  final bool isCurrentUser;

  QuizPlayer({
    required this.name,
    required this.email,
    required this.score,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.avatarUrl,
    this.isCurrentUser = false,
  });

  double get accuracy => (correctAnswers / totalQuestions);
}

class HeroScoreScreen extends StatelessWidget {
  // Your App Theme Colors
  static const Color primaryBlue = Color(0xFF3B72ED);
  static const Color lightBg = Color(0xFFF3F5FC);
  static const Color cardBg = Colors.white;
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);

  final List<QuizPlayer> players = [
    QuizPlayer(
      name: "vishwa (You)",
      email: "vishwa@gmail.com",
      score: 1850,
      correctAnswers: 9,
      totalQuestions: 10,
      avatarUrl: "https://i.pravatar.cc/150?img=32",
      isCurrentUser: true,
    ),
    QuizPlayer(
      name: "abc",
      email: "a3@gmail.com",
      score: 1420,
      correctAnswers: 7,
      totalQuestions: 10,
      avatarUrl: "https://i.pravatar.cc/150?img=11",
    ),
    QuizPlayer(
      name: "sdfsd",
      email: "as@gmail.com",
      score: 1100,
      correctAnswers: 6,
      totalQuestions: 10,
      avatarUrl: "https://i.pravatar.cc/150?img=33",
    ),
    QuizPlayer(
      name: "parth",
      email: "parth00@gmail.com",
      score: 820,
      correctAnswers: 4,
      totalQuestions: 10,
      avatarUrl: "https://i.pravatar.cc/150?img=12",
    ),
  ];

  HeroScoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sort highest score first
    players.sort((a, b) => b.score.compareTo(a.score));
    final winner = players.first;

    return Scaffold(
      backgroundColor: lightBg,
      body: SafeArea(
        child: Column(
          children: [
            // 🌟 1. HERO WINNER CARD
            _buildHeroWinnerCard(winner),

            const SizedBox(height: 12),

            // 📊 2. PLAYER STATS SECTION HEADER
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Player Performance",
                    style: TextStyle(
                      color: textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Accuracy",
                    style: TextStyle(
                      color: textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // 📋 3. STATS LIST
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: players.length,
                itemBuilder: (context, index) {
                  return _buildPlayerStatCard(players[index], index + 1);
                },
              ),
            ),

            // 🔘 4. BOTTOM ACTION BUTTONS
            _buildBottomButtons(context),
          ],
        ),
      ),
    );
  }

  // --- Hero Winner Spotlight Card ---
  Widget _buildHeroWinnerCard(QuizPlayer winner) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryBlue,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Winner Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emoji_events, color: Colors.amber, size: 18),
                SizedBox(width: 6),
                Text(
                  "MATCH CHAMPION",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Winner Avatar with Crown Glow
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.amber, width: 3),
                ),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(winner.avatarUrl),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Winner Name & Email
          Text(
            winner.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            winner.email,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),

          // Winner Quick Stats Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.stars_rounded, color: primaryBlue, size: 20),
                const SizedBox(width: 8),
                Text(
                  "${winner.score} PTS",
                  style: const TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Individual Performance Card ---
  Widget _buildPlayerStatCard(QuizPlayer player, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: player.isCurrentUser
            ? Border.all(color: primaryBlue, width: 2)
            : null,
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Rank Text
              Text(
                "#$rank",
                style: TextStyle(
                  color: rank == 1 ? Colors.amber : textMuted,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 12),

              // Avatar
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(player.avatarUrl),
              ),
              const SizedBox(width: 12),

              // Player Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.name,
                      style: TextStyle(
                        color: textDark,
                        fontWeight: player.isCurrentUser
                            ? FontWeight.bold
                            : FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      "${player.correctAnswers}/${player.totalQuestions} Correct",
                      style: const TextStyle(
                        color: textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Score Text
              Text(
                "${player.score} pts",
                style: const TextStyle(
                  color: textDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Accuracy Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: player.accuracy,
              minHeight: 6,
              backgroundColor: lightBg,
              valueColor: AlwaysStoppedAnimation<Color>(
                player.accuracy >= 0.8
                    ? const Color(0xFF10B981) // Green for high accuracy
                    : player.accuracy >= 0.5
                    ? primaryBlue
                    : const Color(0xFFF59E0B), // Orange for lower
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Bottom Action Area ---
  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: primaryBlue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Home",
                style: TextStyle(
                    color: primaryBlue, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Play Again",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}