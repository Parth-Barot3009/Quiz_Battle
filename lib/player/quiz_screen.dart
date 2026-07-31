import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiz_battle/player/after_quiz.dart';

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
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
//================ COLORS =================//

  static const Color brandBlue = Color(0xFF306AE7);
  static const Color lightBackground = Color(0xFFF4F8FF);
  static const Color darkText = Color(0xFF1E293B);

//================ VARIABLES =================//

  int currentQuestion = 0;
  int selectedOption = -1;
  int score = 0;
  int totalQuestions = 5;

  bool optionSelected = false;
  bool showAnswer = false;

  int timeLeft = 10;

  Timer? timer;

  final List<String> optionLetters = [
    "A",
    "B",
    "C",
    "D",
  ];

//================ QUESTIONS =================//

  final List<Question> questions = [
    Question(
      question: "What is Flutter?",
      options: [
        "Database",
        "UI Toolkit",
        "Programming Language",
        "Operating System",
      ],
      correctAnswer: 1,
    ),
    Question(
      question: "Who developed Flutter?",
      options: [
        "Apple",
        "Google",
        "Microsoft",
        "Meta",
      ],
      correctAnswer: 1,
    ),
    Question(
      question: "Which language is used in Flutter?",
      options: [
        "Java",
        "Kotlin",
        "Dart",
        "Python",
      ],
      correctAnswer: 2,
    ),
    Question(
      question: "Firebase is mainly used for?",
      options: [
        "Database",
        "Animation",
        "Video Editing",
        "Operating System",
      ],
      correctAnswer: 0,
    ),
    Question(
      question: "Flutter is used to build?",
      options: [
        "Mobile Apps",
        "Web Apps",
        "Desktop Apps",
        "All of the Above",
      ],
      correctAnswer: 3,
    ),
  ];

//================ INIT =================//

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

//================ TIMER =================//

  void startTimer() {
    timer?.cancel();

    timeLeft = 10;

    timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (timeLeft > 0) {
          setState(() {
            timeLeft--;
          });
        } else {
          timer.cancel();

          setState(() {
            showAnswer = true;
            selectedOption = -1;
          });

          Future.delayed(
            const Duration(seconds: 1),
            nextQuestion,
          );
        }
      },
    );
  }

//================ NEXT QUESTION =================//

  void nextQuestion() {
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedOption = -1;
        optionSelected = false;
        showAnswer = false;
      });

      startTimer();
    } else {
      timer?.cancel();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            myScore: score,
            opponentScore: 3,
            totalQuestions: totalQuestions,
          ),
        ),
      );
    }
  }

//================ OPTION COLOR =================//

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

//================ OPTION ICON =================//

  Widget optionIcon(int index) {
    if (!showAnswer) return const SizedBox();

    if (index == questions[currentQuestion].correctAnswer) {
      return const Icon(
        Icons.check_circle,
        color: Colors.green,
      );
    }

    if (index == selectedOption) {
      return const Icon(
        Icons.cancel,
        color: Colors.red,
      );
    }

    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: lightBackground,

      body: Stack(
        children: [

// Background Decoration
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

//========================
// HEADER
//========================

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
                          onPressed: () {
                            Navigator.pop(context);
                          },
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

//========================
// ROOM CARD
//========================

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
                              colors: [
                                Color(0xFF4A7CFF),
                                Color(0xFF306AE7),
                              ],
                            ),

                            borderRadius:
                            BorderRadius.circular(16),
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
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [

                              const Text(
                                "Room Code",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),

                              const SizedBox(height: 5),

                              const Text(
                                "#AB1234",
                                style: TextStyle(
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
                            borderRadius:
                            BorderRadius.circular(15),
                          ),

                          child: Text(
                            "${currentQuestion + 1}/${questions.length}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

//========================
// QUESTION CARD
//========================

                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(24),

                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF4A7CFF),
                          Color(0xFF306AE7),
                        ],
                      ),

                      borderRadius:
                      BorderRadius.circular(24),

                      boxShadow: [
                        BoxShadow(
                          color:
                          brandBlue.withOpacity(.30),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        const Text(
                          "Question",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          questions[currentQuestion]
                              .question,

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
//========================
// OPTIONS
//========================

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

                            setState(() {
                              optionSelected = true;
                              selectedOption = index;
                              showAnswer = true;

                              if (index ==
                                  questions[currentQuestion]
                                      .correctAnswer) {
                                score++;
                              }
                            });

                            Future.delayed(
                              const Duration(seconds: 1),
                              nextQuestion,
                            );
                          },

                          child: AnimatedContainer(
                            duration:
                            const Duration(milliseconds: 300),

                            padding: const EdgeInsets.all(18),

                            decoration: BoxDecoration(
                              color: optionColor(index),

                              borderRadius:
                              BorderRadius.circular(20),

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
                                    questions[currentQuestion]
                                        .options[index],

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

//========================
// TIMER
//========================

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
                          mainAxisAlignment:
                          MainAxisAlignment.center,

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

//========================
// PROGRESS
//========================

                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),

                    child: LinearProgressIndicator(
                      value: (currentQuestion + 1) /
                          questions.length,

                      minHeight: 12,

                      backgroundColor: Colors.grey.shade300,

                      valueColor:
                      const AlwaysStoppedAnimation(
                        brandBlue,
                      ),
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