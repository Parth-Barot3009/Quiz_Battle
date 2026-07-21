import 'package:flutter/material.dart';

class Org_BattleRoom extends StatefulWidget {
  const Org_BattleRoom({super.key});

  @override
  State<Org_BattleRoom> createState() => _Org_BattleRoomState();
}

class _Org_BattleRoomState extends State<Org_BattleRoom> {

  @override


  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFF4A7CFF),
      appBar: AppBar(
        title: Text("Battle Room",
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
          height: screenHeight,
          width: screenWidth,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                // Container of Room Code
                Container(
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
                            IconButton(onPressed: (){},
                                icon: Icon(
                                  Icons.copy_outlined,
                                  size: 35,
                                  color: Colors.white,
                                )
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
        
                SizedBox(height: 10,),
                // Container of Quiz Details
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:Container(
                      height: screenHeight*0.38,
                      width: screenWidth*0.95,
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0,top: 8.0),
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xFF4A7CFF),
                                    child: Icon(
                                        Icons.description_outlined,
                                        size: 28,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0,top: 10.0),
                                  child: Text("Quiz Details",
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
        
                            SizedBox(height: 10,),
                            // Quiz
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: screenWidth*0.95,
                                decoration: BoxDecoration(
                                  border: BorderDirectional(bottom: BorderSide(color: Colors.black)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            height:35,
                                            width: 35,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: Color(0xFFDCEAFF),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child:Icon(
                                                  Icons.help,
                                                  size: 25,
                                              color: Color(0xFF306AE7),
                                              ),
                                          ),
                                          SizedBox(width: 10,),
                                          Text("Quiz",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text("Flutter",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF306AE7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
        
                            // Questions
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: screenWidth*0.95,
                                decoration: BoxDecoration(
                                  border: BorderDirectional(bottom: BorderSide(color: Colors.black)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            height:35,
                                            width: 35,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: Color(0xFFDCEAFF),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child:Icon(
                                              Icons.list,
                                              size: 25,
                                              color: Color(0xFF306AE7),
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Text("Questions",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text("10",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF306AE7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
        
                            // Time/Duration
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: screenWidth*0.95,
                                decoration: BoxDecoration(
                                  border: BorderDirectional(bottom: BorderSide(color: Colors.black)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            height:35,
                                            width: 35,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: Color(0xFFDCEAFF),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child:Icon(
                                              Icons.history,
                                              size: 25,
                                              color: Color(0xFF306AE7),
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Text("Time/Duration",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text("10",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFF306AE7),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
        
                            // Status
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: screenWidth*0.95,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            height:35,
                                            width: 35,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: Color(0xFFDCEAFF),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child:Icon(
                                              Icons.emoji_events,
                                              size: 25,
                                              color: Color(0xFF306AE7),
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Text("Status",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text("Waiting For Player",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF306AE7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ),
        
              //  Saction of Player who is playing
                SizedBox(height: 10,),
                Container(
                    height: screenHeight * 0.30,
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
                              )
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
                                Text("Student 1",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
        
                      ],
                    )
                ),
        
        
              ],
            ),
          ),
        ),
      ),
    );
  }
}
