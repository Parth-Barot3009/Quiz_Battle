import 'package:flutter/material.dart';

class Org_BattleRoom extends StatefulWidget {
  const Org_BattleRoom({super.key});

  @override
  State<Org_BattleRoom> createState() => _Org_BattleRoomState();
}

class _Org_BattleRoomState extends State<Org_BattleRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Battle Room",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        toolbarHeight: 100,
      ),

      body: Column(
        children: [

          // Container of Room Code
          Container(
            height: 150,
            width: 410,
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
                Text("Room Code"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("ABCD"),
                    Icon(
                      Icons.copy_outlined,
                    ),
                  ],
                ),
                Text("Share this code with players"),
              ],
            ),
          ),

          // Container of Quiz Details
          Container(
            height: 409,
            width: 261,
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
              children: [
                Text("Quiz Details",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    border: BorderDirectional(bottom: BorderSide(color: Colors.black)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Quiz"),
                      Text("Flutter"),
                    ],
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    border: BorderDirectional(bottom: BorderSide(color: Colors.black)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Questions"),
                      Text("10"),
                    ],
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    border: BorderDirectional(bottom: BorderSide(color: Colors.black)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Time/Duration"),
                      Text("10"),
                    ],
                  ),
                ),

              ],
            ),
          ),

        //  Saction of Player who is playing
  
          Container(
              child: Column(
                children: [
                  Text("Players"),
                  Container(
                    decoration: BoxDecoration(
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          child: Icon(
                            Icons.person_outline,
                            size: 30,
                            color: Colors.blueAccent,
                          ),
                        ),
                        Text("Student 1"),
                      ],
                    ),
                  ),
                ],
              )
          ),

          
        ],
      ),
    );
  }
}
