import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_battle/player/after_quiz.dart';
import 'package:quiz_battle/waitingscreen.dart';

class Question {
  final String question;
  final List<String> options;
  final int correctAnswer;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}

class QuizScreen extends StatefulWidget {
  final String battleId;
  final String roomCode;

  const QuizScreen({super.key, required this.battleId, required this.roomCode});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // Colors
  static const Color brandBlue = Color(0xFF306AE7);
  static const Color lightBackground = Color(0xFFF4F8FF);
  static const Color darkText = Color(0xFF1E293B);

  // Variables
  int currentQuestion = 0;
  int selectedOption = -1;
  int score = 0; // Total correct count

  int correctAnswers = 0;
  int wrongAnswers = 0;

  double totalResponseTime = 0;

  DateTime? questionStartTime;

  int totalQuestions = 0;

  bool optionSelected = false;
  bool showAnswer = false;
  bool isLoading = true;

  int timeLeft = 10;
  Timer? timer;

  final List<String> optionLetters = ["A", "B", "C", "D"];
  List<Question> questions = [];

  @override
  void initState() {
    addBattleInPlayer();
    super.initState();
    fetchQuestions();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> addBattleInPlayer() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null || currentUser.email == null) return;

      QuerySnapshot playerQuery = await FirebaseFirestore.instance
          .collection("player")
          .where("player_email", isEqualTo: currentUser.email)
          .limit(1)
          .get();

      if (playerQuery.docs.isNotEmpty) {
        String playerDocId = playerQuery.docs.first.id;

        await FirebaseFirestore.instance
            .collection("player")
            .doc(playerDocId)
            .set({
          "played_battle": FieldValue.increment(1),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint("Error updating played_battle count: $e");
    }
  }

  Future<void> fetchQuestions() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("Battle_Room_Details")
          .doc(widget.battleId)
          .collection("Questions")
          .orderBy("questionIndex")
          .get();

      List<QueryDocumentSnapshot> docs = snapshot.docs;
      docs.shuffle();

      DocumentSnapshot battleDoc = await FirebaseFirestore.instance
          .collection("Battle_Room_Details")
          .doc(widget.battleId)
          .get();

      int questionLimit = battleDoc["questions"] ?? docs.length;
      docs = docs.take(questionLimit).toList();

      List<Question> loadedQuestions = [];

      for (var doc in docs) {
        var data = doc.data() as Map<String, dynamic>;

        List<String> options = [
          data["optionA"] ?? "",
          data["optionB"] ?? "",
          data["optionC"] ?? "",
          data["optionD"] ?? "",
        ];

        int correctIndex = 0;
        var rawAnswer = data["correctAnswer"];

        if (rawAnswer is int) {
          correctIndex = rawAnswer;
        } else if (rawAnswer is String) {
          switch (rawAnswer.trim().toUpperCase()) {
            case "A":
            case "OPTIONA":
              correctIndex = 0;
              break;
            case "B":
            case "OPTIONB":
              correctIndex = 1;
              break;
            case "C":
            case "OPTIONC":
              correctIndex = 2;
              break;
            case "D":
            case "OPTIOND":
              correctIndex = 3;
              break;
            default:
              correctIndex = int.tryParse(rawAnswer) ?? 0;
          }
        }

        loadedQuestions.add(
          Question(
            question: data["question"] ?? "No Question Text",
            options: options,
            correctAnswer: correctIndex,
          ),
        );
      }

      if (mounted) {
        setState(() {
          questions = loadedQuestions;
          totalQuestions = loadedQuestions.length;
          isLoading = false;
        });

        if (questions.isNotEmpty) {
          startTimer();
        }
      }
    } catch (e) {
      debugPrint("Error loading questions: $e");
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void startTimer() {
    timer?.cancel();
    setState(() => timeLeft = 10);
    questionStartTime = DateTime.now();

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timeLeft > 0) {
        setState(() => timeLeft--);
      } else {
        t.cancel();
        setState(() {
          showAnswer = true;
          selectedOption = -1;
        });
        wrongAnswers++;
        totalResponseTime += 10;

        updatePlayerPerformance(
          isCorrect: false,
          responseTime: 10,
        );

        Future.delayed(const Duration(seconds: 1), nextQuestion);
      }
    });
  }

  void nextQuestion() async {
    DocumentSnapshot data = await FirebaseFirestore.instance
        .collection('Battle_Room_Details')
        .doc(widget.battleId)
        .get();

    int question = data['questions'] ?? questions.length;

    if (!mounted) return;

    if (currentQuestion < question - 1) {
      setState(() {
        currentQuestion++;
        selectedOption = -1;
        optionSelected = false;
        showAnswer = false;
      });
      startTimer();
    } else {
      saveScoreAndNavigate();
    }
  }

  // ✅ FIXED: Updated player_score and points simultaneously in Firestore
  Future<void> updatePlayerPerformance({
    required bool isCorrect,
    required double responseTime,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    int pointsToAdd = isCorrect ? 10 : 0;

    await FirebaseFirestore.instance
        .collection("Battle_Room_Details")
        .doc(widget.battleId)
        .collection("Players")
        .doc(user.uid)
        .set({
      "correct": FieldValue.increment(isCorrect ? 1 : 0),
      "wrong": FieldValue.increment(isCorrect ? 0 : 1),
      "points": FieldValue.increment(pointsToAdd),
      "player_score": FieldValue.increment(pointsToAdd), // ✅ Updated player_score
      "totalTime": FieldValue.increment(responseTime),
    }, SetOptions(merge: true));
  }

  Future<void> saveScoreAndNavigate() async {
    timer?.cancel();
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        String nameToSave = "Player";
        if (user.displayName != null && user.displayName!.trim().isNotEmpty) {
          nameToSave = user.displayName!.trim();
        } else if (user.email != null && user.email!.contains('@')) {
          nameToSave = user.email!.split('@').first;
        }

        await FirebaseFirestore.instance
            .collection("Battle_Room_Details")
            .doc(widget.battleId)
            .collection("Players")
            .doc(user.uid)
            .set({
          "player_name": nameToSave,
          "player_email": user.email ?? "",
          "completed_at": FieldValue.serverTimestamp(),
          "isFinished": true,
        }, SetOptions(merge: true));

        QuerySnapshot allPlayers = await FirebaseFirestore.instance
            .collection("Battle_Room_Details")
            .doc(widget.battleId)
            .collection("Players")
            .get();

        bool allFinished = allPlayers.docs.every((doc) {
          var data = doc.data() as Map<String, dynamic>;
          return data["isFinished"] == true;
        });

        if (allFinished) {
          await calculateLeaderboard();
        }
      } catch (e) {
        debugPrint("Error saving final score: $e");
      }
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => WaitingScreen(
            battleId: widget.battleId,
            myScore: correctAnswers, // ✅ Passed correctAnswers count
            totalQuestions: totalQuestions,
          ),
        ),
      );
    }
  }

  // ✅ FIXED: Null-safe leaderboard point evaluation
  Future<void> calculateLeaderboard() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Battle_Room_Details")
        .doc(widget.battleId)
        .collection("Players")
        .get();

    List<QueryDocumentSnapshot> players = snapshot.docs;

    players.sort((a, b) {
      Map<String, dynamic> playerA = a.data() as Map<String, dynamic>;
      Map<String, dynamic> playerB = b.data() as Map<String, dynamic>;

      int correctA = playerA["correct"] ?? 0;
      int correctB = playerB["correct"] ?? 0;

      if (correctB != correctA) {
        return correctB.compareTo(correctA);
      }

      num timeA = playerA["totalTime"] ?? 0;
      num timeB = playerB["totalTime"] ?? 0;

      return timeA.compareTo(timeB);
    });

    WriteBatch batch = FirebaseFirestore.instance.batch();
    List<int> bonusPoints = [150, 130, 120, 100, 80, 60, 50, 40, 30, 20];

    for (int i = 0; i < players.length; i++) {
      Map<String, dynamic> data = players[i].data() as Map<String, dynamic>;

      int bonus = i < bonusPoints.length ? bonusPoints[i] : 10;
      int currentPoints = (data["points"] as num?)?.toInt() ?? 0;

      batch.update(players[i].reference, {
        "rank": i + 1,
        "bonusPoints": bonus,
        "finalPoints": currentPoints + bonus,
        "player_score": currentPoints + bonus,
      });
    }

    await batch.commit();
  }

  Color optionColor(int index) {
    if (!showAnswer) return Colors.white;
    if (index == questions[currentQuestion].correctAnswer) {
      return Colors.green.shade50;
    }
    if (index == selectedOption) {
      return Colors.red.shade50;
    }
    return Colors.white;
  }

  Widget optionIcon(int index) {
    if (!showAnswer) return const SizedBox();
    if (index == questions[currentQuestion].correctAnswer) {
      return const Icon(Icons.check_circle, color: Colors.green);
    }
    if (index == selectedOption) {
      return const Icon(Icons.cancel, color: Colors.red);
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: lightBackground,
        body: Center(child: CircularProgressIndicator(color: brandBlue)),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        backgroundColor: lightBackground,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "No questions available for this room.",
                style: TextStyle(fontSize: 16, color: darkText),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Go Back"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: lightBackground,
      body: Stack(
        children: [
          Positioned(
            top: -90,
            left: -70,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: brandBlue.withOpacity(.08),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: brandBlue.withOpacity(.05),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: darkText,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 18),
                      const Text(
                        "Quiz Battle",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: darkText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.08),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4A7CFF), Color(0xFF306AE7)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.meeting_room_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Room Code",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "#${widget.roomCode}",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: brandBlue,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Battle_Room_Details')
                                .doc(widget.battleId)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData || !snapshot.data!.exists) {
                                return Text(
                                  "${currentQuestion + 1}/...",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                );
                              }

                              var data = snapshot.data!.data() as Map<String, dynamic>?;
                              int totalCount = data?['questions'] ?? questions.length;

                              return Text(
                                "${currentQuestion + 1}/$totalCount",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4A7CFF), Color(0xFF306AE7)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: brandBlue.withOpacity(.30),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Question",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          questions[currentQuestion].question,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: questions[currentQuestion].options.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: optionSelected
                              ? null
                              : () {
                            timer?.cancel();

                            double responseTime =
                                DateTime.now()
                                    .difference(questionStartTime!)
                                    .inMilliseconds / 1000;

                            totalResponseTime += responseTime;

                            bool isCorrect =
                                index == questions[currentQuestion].correctAnswer;

                            setState(() {
                              optionSelected = true;
                              selectedOption = index;
                              showAnswer = true;

                              if (isCorrect) {
                                score += 10;
                                correctAnswers++;
                              } else {
                                wrongAnswers++;
                              }
                            });

                            updatePlayerPerformance(
                              isCorrect: isCorrect,
                              responseTime: responseTime,
                            );

                            Future.delayed(
                              const Duration(seconds: 1),
                              nextQuestion,
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: optionColor(index),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selectedOption == index
                                    ? brandBlue
                                    : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: brandBlue,
                                  child: Text(
                                    optionLetters[index],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    questions[currentQuestion].options[index],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                optionIcon(index),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.08),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$timeLeft",
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: brandBlue,
                              ),
                            ),
                            const Text(
                              "Seconds",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: (currentQuestion + 1) / questions.length,
                      minHeight: 12,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation(brandBlue),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}