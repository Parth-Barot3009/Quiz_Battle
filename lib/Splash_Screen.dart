import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiz_battle/Choose_Role_Screen.dart';

class SplahScreen extends StatefulWidget {
  const SplahScreen({super.key});

  @override
  State<SplahScreen> createState() => _SplahScreenState();
}

class _SplahScreenState extends State<SplahScreen> {

  @override

  void initState(){
    super.initState();
    Timer(Duration(seconds: 3),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Choose_Role_Screen()));
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
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF7209B7),
                  Color(0xFF320451),
                ]
            )
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Image.asset("assets/images/Logo.png", width: 384,height: 384,),
          ),
        )
      ),
    );
  }
}

