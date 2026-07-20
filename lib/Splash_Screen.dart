import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quiz_battle/Authantication.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override

  void initState(){
    super.initState();
    Timer(Duration(seconds: 3),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authantication()));
    });
  }

  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
            // gradient: LinearGradient(
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomCenter,
            //     colors: [
            //       Color(0xFF4A7CFF),
            //       Color(0xFF306AE7),
            //     ]
            // )
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/Logo.png", width: 384,height: 384,),
            CircularProgressIndicator(
              color: Colors.black,
            ),
          ],
        )
      ),
    );
  }
}

