import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quiz_battle/player/after_quiz.dart';
import 'package:quiz_battle/player/user_dashboard.dart';

class Question {
  String question;
  List<String> options;
  int correctAnswer;
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

  int selectedOption = -1;
  int currentQuestion = 0;
  int totalQuestions = 5;
  int timeLeft = 10;
  int score = 0;
  bool optionSelected = false;
  bool showAnswer = false;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  Color containerColor(int index) {

    if (!showAnswer) {
      return Colors.white;
    }

    if (index == questions[currentQuestion].correctAnswer) {
      return Colors.green.shade100;
    }

    if (index == selectedOption) {
      return Colors.red.shade100;
    }

    return Colors.white;
  }

  Widget optionIcon(int index) {

    if (!showAnswer) {
      return const SizedBox();
    }

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
        }
        else
        {
          timer.cancel();

          setState(() {
            showAnswer = true;
            selectedOption = -1; // User didn't answer
          });

          Future.delayed(const Duration(seconds: 1), () {
            nextQuestion();
          });
        }
      },
    );
  }

  void nextQuestion() {

    if (currentQuestion < questions.length - 1) {

      setState(() {
        currentQuestion++;
        selectedOption = -1;
        showAnswer = false;
        optionSelected = false;
      });

      startTimer();

    } else {

      timer?.cancel();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(myScore: score, opponentScore: 3, totalQuestions: totalQuestions),
        ),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  List<String> optionLetters = [
    "A",
    "B",
    "C",
    "D",
  ];

  List<Question> questions = [
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF5F7FF),

      appBar: AppBar(
        backgroundColor: const Color(0xFF4A6CF7),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Question",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              // Room Information Card

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: Container(

                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),

                    boxShadow: [

                      BoxShadow(
                        color: Colors.grey.withOpacity(.15),
                        blurRadius: 12,
                        offset: const Offset(0,5),
                      )

                    ],

                  ),

                  child: Row(

                    children: [

                      Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9ECFF),
                          borderRadius: BorderRadius.circular(14),

                        ),

                        child: const Icon(
                          Icons.meeting_room_rounded,
                          color: Color(0xFF4A6CF7),

                        ),

                      ),

                      const SizedBox(width: 15),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Room Code",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,


                              ),
                            ),

                            SizedBox(height: 4),

                            Text(
                              "#AB1234",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                          ],

                        ),

                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                        ),

                        decoration: BoxDecoration(
                          color: const Color(0xFF4A6CF7),
                          borderRadius: BorderRadius.circular(14),
                        ),

                        child: Text(
                          "${currentQuestion + 1} / ${questions.length}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ),
                    ],

                  ),
                ),
              ),

      const SizedBox(height: 25),


      //2. Question Card


      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF4A6CF7),
                Color(0xFF306AE7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "Question",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              SizedBox(height: 12),

              Text(
                questions[currentQuestion].question,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,

                ),
              ),

            ],
          ),
        ),
      ),

      const SizedBox(height: 25),

      // Options

      ListView.builder(
        itemCount: questions[currentQuestion].options.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemBuilder: (context, index) {

          bool selected = selectedOption == index;

          return GestureDetector(
              onTap: () async {

                if (optionSelected) return;

                optionSelected = true;
                showAnswer = true;

                timer?.cancel();

                setState(() {
                  selectedOption = index;
                });

                if (index == questions[currentQuestion].correctAnswer) {
                  score++;
                }

                await Future.delayed(const Duration(seconds: 1));

                nextQuestion();
              },

            child: AnimatedContainer(


              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(bottom: 18),
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(

                color: containerColor(index),

                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: !showAnswer
                      ? Colors.grey.shade300
                      : index == questions[currentQuestion].correctAnswer
                      ? Colors.green
                      : index == selectedOption
                      ? Colors.red
                      : Colors.grey.shade300,
                  width: 2,
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.12),
                    blurRadius: 10,
                    offset: const Offset(0,4),
                  ),
                ],
              ),

              child: Row(
                children: [

                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: !showAnswer
                          ? const Color(0xFFE9ECFF)
                          : index == questions[currentQuestion].correctAnswer
                          ? Colors.green
                          : index == selectedOption
                          ? Colors.red
                          : const Color(0xFFE9ECFF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        optionLetters[index],
                        style: const TextStyle(
                          color: Color(0xFF306AE7),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,

                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 18),

                  Expanded(

                      child: Text(
                        questions[currentQuestion].options[index],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? const Color(0xFF4A6CF7)
                              : Colors.black,

                        ),
                      )
                  ),

                  optionIcon(index),
                ],

              ),
            ),
          );
        },
      ),

          const SizedBox(height: 25),

          //timer card

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.12),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [

                    const Text(
                      "Remaining Time",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,

                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      height: 130,
                      width: 130,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 130,
                            width: 130,
                            child: CircularProgressIndicator(
                              value: timeLeft / 10,
                              strokeWidth: 10,
                              backgroundColor: Colors.grey.shade300,
                              valueColor:
                              const AlwaysStoppedAnimation<Color>(
                                Color(0xFF4A6CF7),
                              ),
                            ),
                          ),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "$timeLeft",
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4A6CF7),

                                ),
                              ),

                              const Text(
                                "Seconds",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,

                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 35),

            ],
          ),
        ),
      ) ,
    );
  }
}