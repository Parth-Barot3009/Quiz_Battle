import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WaitingRoom extends StatefulWidget {
  const WaitingRoom({super.key});

  @override
  State<WaitingRoom> createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<WaitingRoom> with SingleTickerProviderStateMixin{

  late AnimationController controller;
  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.15,
    ).animate(controller);

    fadeAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(controller);

    controller.repeat(reverse: true);
  }

  @override
  void dispose()
  {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Waiting Room",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF4A7CFF),
        toolbarHeight: 80,
      ),

      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
            // Room Code Display
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: screenHeight*0.18,
                    width: screenWidth*0.95,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF4A7CFF),
                            Color(0xFF306AE7),
                          ]
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Room Code",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("ABCDEF",
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text("Share this code with players",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        
        
              // Matching Player Details
              SizedBox(height: 10,),
              Container(
                  height: screenHeight * 0.28,
                  width: screenWidth * 0.95,
                  decoration: BoxDecoration(
                    color: Colors.white60,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 12,
                        spreadRadius: 5,
                        color: Color(0x14000000),
                      )
                    ],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Color(0xFF306AE7),
                              child: Icon(
                                Icons.people_rounded,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
        
                            SizedBox(width: 10,),
                            Text("Players",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
        
                      // Students Name
                      Container(
                        width: screenWidth * 0.90,
                        height: screenHeight * 0.08,
                        decoration: BoxDecoration(
                          color: Color(0xFFDDEBFF),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Color(0xFF306AE7),
                                child: Icon(
                                  Icons.person_rounded,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10,),
                              Text("Student 1",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              Text("Joined",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: screenWidth * 0.90,
                        height: screenHeight * 0.08,
                        decoration: BoxDecoration(
                          color: Color(0xFFDDEBFF),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Color(0xFF306AE7),
                                child: Icon(
                                  Icons.person_rounded,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10,),
                              Text("Student 2",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              Text("Waiting",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
              ),
        
            //   Battle Starting Animation Sactions
            SizedBox(height: 30,),
        
              Center(
                child: Column(
                  children: [
                    ScaleTransition(
                      scale: scaleAnimation,
                      child: Icon(
                        Icons.bolt_rounded,
                        size: 90,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
        
        
              FadeTransition(
                opacity: fadeAnimation,
                child: Text(
                  "BATTLE STARTING!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF306AE7),
                    letterSpacing: 2,
                  ),
                ),
              ),
        
              AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  TypewriterAnimatedText(
                    "Get ready to compete...",
                    speed: Duration(milliseconds: 80),
                    textStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
        
            ],
          ),
        ),
      ),
    );
  }
}
