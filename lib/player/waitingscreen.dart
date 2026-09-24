import 'dart:async';
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

  // Guards against re-entering the generator while an attempt is in flight.
  // Every player reaches this screen at once, and the writes below retrigger
  // the snapshot listener, so without this the build loop fires it repeatedly.
  bool _generating = false;

  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color background = Color(0xFFF5F9FF);

  static const List<int> _bonusTable = [
    150, 130, 120, 100, 80, 60, 50, 40, 30, 20,
  ];

  /// How long to wait for stragglers before ranking without them. A player who
  /// closes the app used to strand everyone else here indefinitely.
  static const Duration _stragglerGrace = Duration(seconds: 90);

  Timer? _graceTimer;
  bool _deadlinePassed = false;

  // Hoisted so rebuilds reuse the same subscriptions instead of resetting
  // them and flashing a spinner.
  late final Stream<DocumentSnapshot<Map<String, dynamic>>> _battleStream =
      FirebaseFirestore.instance
          .collection("Battle_Room_Details")
          .doc(widget.battleId)
          .snapshots();

  late final Stream<QuerySnapshot<Map<String, dynamic>>> _playersStream =
      FirebaseFirestore.instance
          .collection("Battle_Room_Details")
          .doc(widget.battleId)
          .collection("Players")
          .snapshots();

  @override
  void initState() {
    super.initState();
    _graceTimer = Timer(_stragglerGrace, () {
      if (!mounted) return;
      setState(() => _deadlinePassed = true);
      _generateLeaderboard();
    });
  }

  @override
  void dispose() {
    _graceTimer?.cancel();
    super.dispose();
  }

  /// Ranks every player and stamps the result on the battle document.
  ///
  /// The `leaderboardGenerated` flag is claimed inside a transaction so that
  /// only one player's device does the ranking, however many finish at once.
  Future<void> _generateLeaderboard() async {
    if (_generating) return;
    _generating = true;

    final firestore = FirebaseFirestore.instance;
    final battleRef =
        firestore.collection("Battle_Room_Details").doc(widget.battleId);

    try {
      // Claim the job. If another device already claimed it, stop here.
      final bool claimed = await firestore.runTransaction<bool>((tx) async {
        final snapshot = await tx.get(battleRef);
        final data = snapshot.data();

        if (!snapshot.exists || data == null) return false;
        if (data["leaderboardGenerated"] == true) return false;

        tx.update(battleRef, {"leaderboardGenerated": true});
        return true;
      });

      if (!claimed) return;

      final playersSnapshot = await battleRef.collection("Players").get();
      final players = playersSnapshot.docs;

      if (players.isEmpty) {
        // Nothing to rank; release the claim so a later attempt can retry.
        await battleRef.update({"leaderboardGenerated": false});
        return;
      }

      // Most correct answers wins; ties broken by the faster total time.
      players.sort((a, b) {
        final dataA = a.data();
        final dataB = b.data();

        final int correctA = (dataA["correct"] as num?)?.toInt() ?? 0;
        final int correctB = (dataB["correct"] as num?)?.toInt() ?? 0;
        if (correctA != correctB) return correctB.compareTo(correctA);

        final num timeA = (dataA["totalTime"] as num?) ?? 0;
        final num timeB = (dataB["totalTime"] as num?) ?? 0;
        return timeA.compareTo(timeB);
      });

      final batch = firestore.batch();

      for (int i = 0; i < players.length; i++) {
        final data = players[i].data();
        final int bonus = i < _bonusTable.length ? _bonusTable[i] : 10;
        final int points = (data["points"] as num?)?.toInt() ?? 0;

        batch.update(players[i].reference, {
          "rank": i + 1,
          "bonusPoints": bonus,
          "finalPoints": points + bonus,
          "player_score": points + bonus,
        });
      }

      final winnerName =
          (players.first.data()["player_name"] ?? "Player").toString();
      batch.update(battleRef, {
        "winner_name": winnerName,
        "status": "completed",
      });

      await batch.commit();
    } catch (e) {
      debugPrint("Error generating leaderboard: $e");
      // Let another device pick the job up rather than stranding the room.
      try {
        await battleRef.update({"leaderboardGenerated": false});
      } catch (_) {}
      _generating = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _battleStream,
          builder: (context, battleSnapshot) {
            if (!battleSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final Map<String, dynamic>? battleData = battleSnapshot.data?.data();

            final bool leaderboardGenerated =
                battleData?["leaderboardGenerated"] == true;

            return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _playersStream,
              builder: (context, playerSnapshot) {
                if (!playerSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final players = playerSnapshot.data!.docs;

                final int totalPlayers = players.length;

                final int finishedPlayers = players
                    .where((doc) => doc.data()["isFinished"] == true)
                    .length;

                final bool everyoneDone =
                    totalPlayers > 0 && finishedPlayers == totalPlayers;

                //-------------------------------------------------------
                // Everyone finished (or the grace period expired)
                //-------------------------------------------------------
                // Side effects are deferred out of the build phase; firing
                // them inline retriggered this very listener in a loop.
                if (everyoneDone && !leaderboardGenerated) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) _generateLeaderboard();
                  });
                }

                if (leaderboardGenerated && !navigated) {
                  navigated = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return;
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
                          remaining == 0 || _deadlinePassed
                              ? "Preparing leaderboard..."
                              : "Waiting for $remaining player${remaining > 1 ? "s" : ""}...",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 60),

                        Text(
                          _deadlinePassed
                              ? "Finishing up without the remaining players."
                              : "Please don't close the app.\nResults appear automatically, and at most "
                                  "${_stragglerGrace.inSeconds ~/ 60} minute "
                                  "${_stragglerGrace.inSeconds % 60}s after you finish.",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
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