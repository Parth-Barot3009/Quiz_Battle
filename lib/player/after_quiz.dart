import 'package:flutter/material.dart';
import 'package:quiz_battle/player/user_dashboard.dart';

class ResultScreen extends StatefulWidget {
  final int myScore;
  final int opponentScore;
  final int totalQuestions;

  const ResultScreen({
    super.key,
    required this.myScore,
    required this.opponentScore,
    required this.totalQuestions,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

  late int wrongAnswers;
  late String resultText;
  late IconData resultIcon;
  late Color resultColor;

  @override
  void initState() {
    super.initState();

    wrongAnswers = widget.totalQuestions - widget.myScore;

    if (widget.myScore > widget.opponentScore)
    {
      resultText = "YOU WIN!";
      resultIcon = Icons.emoji_events_rounded;
      resultColor = Colors.amber;
    }
    else if (widget.myScore < widget.opponentScore)
    {
      resultText = "YOU LOSE!";
      resultIcon = Icons.sentiment_dissatisfied_rounded;
      resultColor = Colors.red;
    }
    else
    {
      resultText = "DRAW";
      resultIcon = Icons.handshake_rounded;
      resultColor = Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: const Color(0xFFF5F7FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              // Header

              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 35,
                  left: 20,
                  right: 20,
                  bottom: 45,
                ),

                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF4A6CF7),
                      Color(0xFF306AE7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),

                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                ),

                child: Column(
                  children: [
                    const Text(
                      "BATTLE COMPLETED",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        fontFamily: "BaiJamjuree",
                      ),
                    ),
                    const SizedBox(height: 30),

                    //2.
                    // Trophy Circle

                    Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(.15),
                        border: Border.all(
                          color: Colors.white24,
                          width: 2,
                        ),
                      ),

                      child: Icon(
                        resultIcon,
                        color: resultColor,
                        size: 75,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Result Banner

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                          color: Colors.black.withOpacity(.15),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Text(
                        resultText,
                        style: const TextStyle(
                          color: Color(0xFF306AE7),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: "BaiJamjuree",
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      widget.myScore > widget.opponentScore
                      ? "Congratulations! You won the battle."
                      : widget.myScore < widget.opponentScore
                      ? "Better luck next time."
                      : "The battle ended in a draw.",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 17,
                        fontFamily: "BaiJamjuree",
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Score Card

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 28,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.15),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              "YOU",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4A6CF7),
                                fontFamily: "BaiJamjuree",
                              ),
                            ),

                            const SizedBox(height: 15),

                            Text(
                              widget.myScore.toString(),
                              style: const TextStyle(
                                fontSize: 58,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF306AE7),
                                fontFamily: "BaiJamjuree",
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              "Correct Answers",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                                fontFamily: "BaiJamjuree",
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "VS",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A6CF7),
                            fontFamily: "BaiJamjuree",
                          ),
                        ),
                      ),

                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              "OPPONENT",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4A6CF7),
                                fontFamily: "BaiJamjuree",
                              ),
                            ),

                            const SizedBox(height: 15),

                            Text(
                              widget.opponentScore.toString(),
                              style: const TextStyle(
                                fontSize: 58,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF306AE7),
                                fontFamily: "BaiJamjuree",
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              "Correct Answers",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                                fontFamily: "BaiJamjuree",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              //3
              // Statistics Cards

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(.15),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.quiz_rounded,
                              color: Color(0xFF4A6CF7),
                              size: 38,
                            ),

                            const SizedBox(height: 12),

                            Text(
                              widget.totalQuestions.toString(),
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                fontFamily: "BaiJamjuree",
                              ),
                            ),

                            const SizedBox(height: 6),

                            const Text(
                              "Total Questions",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: "BaiJamjuree",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 18),

                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(.15),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Icon(
                            Icons.cancel_rounded,
                            color: Colors.red,
                            size: 38,
                            ),

                            const SizedBox(height: 12),

                            Text(
                              wrongAnswers.toString(),
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                fontFamily: "BaiJamjuree",
                              ),
                            ),

                            const SizedBox(height: 6),

                            const Text(
                              "Wrong Answers",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: "BaiJamjuree",
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 35),

              // Back to Dashboard Button

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFF4A6CF7),
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const u_dashboard(),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      "Back to Dashboard",
                      style: TextStyle(
                        color: Color(0xFF4A6CF7),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "BaiJamjuree",
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 35),

            ],
          ),
        ),
      ),
    );
  }
}