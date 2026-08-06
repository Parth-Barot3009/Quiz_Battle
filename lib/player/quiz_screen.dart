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
  int score = 0;

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

  // Add Battle in player details
  // Add Battle in player details
  Future<void> addBattleInPlayer() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null || currentUser.email == null) return;

      // 1. Query the player collection by email to locate the user's document ID
      QuerySnapshot playerQuery = await FirebaseFirestore.instance
          .collection("player")
          .where("player_email", isEqualTo: currentUser.email)
          .limit(1)
          .get();

      if (playerQuery.docs.isNotEmpty) {
        String playerDocId = playerQuery.docs.first.id;

        // 2. Increment played_battle count using set with merge: true
        // (This handles cases where played_battle field might not exist yet)
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

  // Fetch Questions dynamically from Firestore
  Future<void> fetchQuestions() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("Battle_Room_Details")
          .doc(widget.battleId)
          .collection("Questions")
          .orderBy("questionIndex")
          .get();

      List<QueryDocumentSnapshot> docs = snapshot.docs;

// Randomize all questions
      docs.shuffle();

// Get total questions selected by organizer
      DocumentSnapshot battleDoc = await FirebaseFirestore.instance
          .collection("Battle_Room_Details")
          .doc(widget.battleId)
          .get();

      int questionLimit = battleDoc["questions"] ?? docs.length;

// Keep only required number
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
        print("Questions Loaded = ${loadedQuestions.length}");
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
      print("Error loading questions: $e");
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // Timer Control
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

  // Next Question or Finish Quiz
  void nextQuestion() async {
    DocumentSnapshot data = await FirebaseFirestore.instance
        .collection('Battle_Room_Details')
        .doc(widget.battleId)
        .get();

    int question = data['questions'] ?? 0;

    if (!mounted) return;

    // Check if there are more questions remaining
    if (currentQuestion < question - 1) {
      setState(() {
        currentQuestion++;
        selectedOption = -1;
        optionSelected = false;
        showAnswer = false;
      });
      startTimer();
    } else {
      // End of quiz reached
      saveScoreAndNavigate();
    }
  }

  Future<void> updatePlayerPerformance({
    required bool isCorrect,
    required double responseTime,
  }) async {

    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("Battle_Room_Details")
        .doc(widget.battleId)
        .collection("Players")
        .doc(user.uid)
        .update({

      "correct": isCorrect
          ? FieldValue.increment(1)
          : FieldValue.increment(0),

      "wrong": isCorrect
          ? FieldValue.increment(0)
          : FieldValue.increment(1),

      "points": isCorrect
          ? FieldValue.increment(10)
          : FieldValue.increment(0),

      "totalTime": FieldValue.increment(responseTime),

    });

  }

  // Save Final Score and Navigate
  // Save Final Score and Navigate
  Future<void> saveScoreAndNavigate() async {
    timer?.cancel();
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection("Battle_Room_Details")
            .doc(widget.battleId)
            .collection("Players")
            .doc(user.uid)
            .set({
          "player_name":
          user.displayName ?? user.email?.split('@').first ?? "Player",
          "player_email": user.email ?? "",
          //
          "completed_at": FieldValue.serverTimestamp(),
          "isFinished": true,
        }, SetOptions(merge: true));
        //
        QuerySnapshot allPlayers = await FirebaseFirestore.instance
            .collection("Battle_Room_Details")
            .doc(widget.battleId)
            .collection("Players")
            .get();

        bool allFinished = allPlayers.docs.every((doc) {
          return doc["isFinished"] == true;
        });
        //
        if (allFinished) {
          await calculateLeaderboard();
        }

      } catch (e) {
        debugPrint("Error saving final score: $e");
      }

    }
    //



    if (mounted) {
      print("Quiz totalQuestions = $totalQuestions");
      print("questions.length = ${questions.length}");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => WaitingScreen(
            battleId: widget.battleId, // <-- Pass the battle document ID
            myScore: score,
            totalQuestions: totalQuestions,
          ),
        ),
      );
    }
  }

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

      // First compare correct answers
      if (playerB["correct"] != playerA["correct"]) {
        return playerB["correct"].compareTo(playerA["correct"]);
      }

      // If correct answers are equal,
      // compare total response time
      return (playerA["totalTime"] as num)
          .compareTo(playerB["totalTime"] as num);
    });

    WriteBatch batch = FirebaseFirestore.instance.batch();

    List<int> bonusPoints = [
      150,
      130,
      120,
      100,
      80,
      60,
      50,
      40,
      30,
      20
    ];

    for (int i = 0; i < players.length; i++) {
      Map<String, dynamic> data =
      players[i].data() as Map<String, dynamic>;

      int bonus =
      i < bonusPoints.length ? bonusPoints[i] : 10;

      batch.update(players[i].reference, {
        "rank": i + 1,
        "bonusPoints": bonus,
        "finalPoints": data["points"] + bonus,
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
                  // Header
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

                  // Room Code Display Card
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
                                .doc(widget.battleId) // Use battleId to fetch document
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

                  // Question Card
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

                  // Options List
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
                                score++;
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

                  // Timer Display
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

                  // Progress Bar
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