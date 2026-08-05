import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_battle/player/after_quiz.dart';

class WaitingScreen extends StatefulWidget {
  final String battleId;
  final int myScore;
  final int totalQuestions;

  const WaitingScreen({
    super.key,
    required this.battleId,
    required this.myScore,
    required this.totalQuestions,
  });

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  bool navigated = false;

  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color darkBlue = Color(0xFF1D4ED8);
  static const Color background = Color(0xFFF5F9FF);

  Future<void> calculateLeaderboard() async {

    DocumentReference battleRef = FirebaseFirestore.instance
        .collection("Battle_Room_Details")
        .doc(widget.battleId);

    DocumentSnapshot battleSnapshot =
    await battleRef.get();

    Map<String, dynamic> battleData =
    battleSnapshot.data() as Map<String, dynamic>;

    if (battleData["leaderboardGenerated"] == true) {
      return;
    }

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Battle_Room_Details")
        .doc(widget.battleId)
        .collection("Players")
        .get();

    List<QueryDocumentSnapshot> players = snapshot.docs;

    players.sort((a, b) {
      Map<String, dynamic> playerA = a.data() as Map<String, dynamic>;

      Map<String, dynamic> playerB = b.data() as Map<String, dynamic>;

      if (playerB["correct"] != playerA["correct"]) {
        return playerB["correct"].compareTo(playerA["correct"]);
      }

      return (playerA["totalTime"] as num).compareTo(
        playerB["totalTime"] as num,
      );
    });

    WriteBatch batch = FirebaseFirestore.instance.batch();

    List<int> bonus = [150, 130, 120, 100, 80, 60, 50, 40, 30, 20];

    for (int i = 0; i < players.length; i++) {
      Map<String, dynamic> data = players[i].data() as Map<String, dynamic>;

      int bonusPoint = i < bonus.length ? bonus[i] : 10;

      batch.update(players[i].reference, {
        "rank": i + 1,
        "bonusPoints": bonusPoint,
        "finalPoints": (data["points"] ?? 0) + bonusPoint,
      });
    }

    await batch.commit();

    Map<String, dynamic> winner =
    players.first.data() as Map<String, dynamic>;

    await FirebaseFirestore.instance
        .collection("Battle_Room_Details")
        .doc(widget.battleId)
        .update({

      "winner_name": winner["player_name"],

    });

    await FirebaseFirestore.instance
        .collection("Battle_Room_Details")
        .doc(widget.battleId)
        .update({
      "leaderboardGenerated": true,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Battle_Room_Details")
              .doc(widget.battleId)
              .snapshots(),
          builder: (context, battleSnapshot) {
            if (!battleSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            // ✅ SAFE: Safely extracts data as a Map first
            Map<String, dynamic>? battleData =
            battleSnapshot.data?.data() as Map<String, dynamic>?;

            bool leaderboardGenerated = battleData?["leaderboardGenerated"] ?? false;

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Battle_Room_Details")
                  .doc(widget.battleId)
                  .collection("Players")
                  .snapshots(),
              builder: (context, playerSnapshot) {
                if (!playerSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<QueryDocumentSnapshot> players = playerSnapshot.data!.docs;

                int totalPlayers = players.length;

                int finishedPlayers = players.where((doc) {
                  Map<String, dynamic> data =
                  doc.data() as Map<String, dynamic>;

                  return data["isFinished"] == true;
                }).length;


                //-------------------------------------------------------
                // Everyone Finished
                //-------------------------------------------------------

                if (finishedPlayers == totalPlayers && totalPlayers > 0) {
                  if (!leaderboardGenerated) {
                    calculateLeaderboard();
                  }

                  if (leaderboardGenerated && !navigated) {
                    navigated = true;

                    Future.microtask(() {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ResultScreen(
                            battleId: widget.battleId,
                            myScore: widget.myScore,
                            totalQuestions: widget.totalQuestions,
                          ),
                        ),
                      );
                    });
                  }
                }

                //-------------------------------------------------------
                // Waiting UI
                //-------------------------------------------------------

                int remaining = totalPlayers - finishedPlayers;

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          color: primaryBlue,
                          strokeWidth: 5,
                        ),

                        const SizedBox(height: 40),

                        const Icon(
                          Icons.groups_rounded,
                          size: 80,
                          color: primaryBlue,
                        ),

                        const SizedBox(height: 25),

                        const Text(
                          "Waiting for Players",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          "$finishedPlayers / $totalPlayers Players Finished",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 25),

                        LinearProgressIndicator(
                          value: totalPlayers == 0
                              ? 0
                              : finishedPlayers / totalPlayers,
                          minHeight: 10,
                          color: primaryBlue,
                          backgroundColor: Colors.grey.shade300,
                        ),

                        const SizedBox(height: 30),

                        Text(
                          remaining == 0
                              ? "Preparing leaderboard..."
                              : "Waiting for $remaining player${remaining > 1 ? "s" : ""}...",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 60),

                        const Text(
                          "Please don't close the app.\nThe result will appear automatically.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}