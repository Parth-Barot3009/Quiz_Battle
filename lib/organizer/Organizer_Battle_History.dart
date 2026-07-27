import 'package:flutter/material.dart';
import 'package:quiz_battle/organizer/ProfileInfo_Organizer.dart';

class OrganizerBattleHistory extends StatefulWidget {
  const OrganizerBattleHistory({super.key});

  @override
  State<OrganizerBattleHistory> createState() => _OrganizerBattleHistoryState();
}

class _OrganizerBattleHistoryState extends State<OrganizerBattleHistory> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Battle History",
          style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              // fontWeight: FontWeight.bold
            ),
        ),
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF306AE7),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
                Padding(
                padding:EdgeInsetsGeometry.all(20), 
                child: Container(
                  width: screenWidth,
                  height: screenHeight*0.35,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),

                    boxShadow:[
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,  
                        spreadRadius: 2,
                        offset: Offset(0, 10),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(padding: EdgeInsetsGeometry.only(top: 70,left: 15)),
                          Container(
                            width: 45,
                            height: 45,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.emoji_events_outlined,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Quiz Challenge',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      Container(
                        child: Column(
                          children: [
                            Padding(padding: EdgeInsetsGeometry.only(left: 18,),
                              child:Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    size: 24,
                                    color: Colors.blueAccent,
                                  ),
                                  Padding(padding: EdgeInsetsGeometry.only(left: 10,)),
                                  Text("25 Jul 2026",//date of play quiz
                                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                  
                                  Padding(padding: EdgeInsetsGeometry.only(left: 25)),
                                  Text("|",style: TextStyle(fontSize: 20),),
                                  Padding(padding: EdgeInsetsGeometry.only(left: 25)),
                                  Icon(
                                    Icons.access_time,
                                    size: 24,
                                    color: Colors.blueAccent,
                                  ),
                                  Padding(padding: EdgeInsetsGeometry.only(left: 10,)),
                                  Text("25 Jul 2026",
                                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                ],
                              ),
                            ),

                            Text("----------------------------------------------------------------------------------"),
                          ],
                        ),
                      ),

                      Container(
                        child: Column(
                          children: [
                              Padding(padding: EdgeInsetsGeometry.only(left: 18),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.people_outline,
                                      size: 25,
                                      color: Colors.blueAccent,
                                    ),

                                    Padding(padding: EdgeInsetsGeometry.only(left: 10,)),
                                      Text("Participants :  ",
                                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),

                                      Text("number of the paticipans",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),// number of participans
                                  ],
                                ),
                              ),
                            
                              Padding(padding: EdgeInsetsGeometry.only(left: 18,top: 5),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.emoji_events_outlined,
                                      size: 25,
                                      color: Colors.blueAccent,
                                    ),

                                    Padding(padding: EdgeInsetsGeometry.only(left: 10,)),
                                      Text("Winner :  ",
                                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),

                                      Text("winner name",
                                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.blueAccent),
                                      ),// number of participans
                                  ],
                                ),
                              ),

                              Padding(padding: EdgeInsetsGeometry.only(left: 18,top: 5),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.flag_outlined,
                                    size: 25,
                                    color: Colors.blueAccent,
                                  ),

                                  Padding(padding: EdgeInsetsGeometry.only(left: 10,)),
                                  Text("Startus :  ",
                                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),

                                  Text("number of the paticipans",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color:Colors.green)),// number of participans
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ),
              ),

              Padding(
                padding:EdgeInsetsGeometry.all(20), 
                child: Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    // border: Border.all(color: Colors.black),
                    boxShadow:[
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,  
                        spreadRadius: 2,
                        offset: Offset(0, 10),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(padding: EdgeInsetsGeometry.only(top: 70,left: 15)),
                          Container(
                            width: 45,
                            height: 45,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.emoji_events_outlined,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Quiz Challenge',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      Container(
                        child: Column(
                          children: [
                            Padding(padding: EdgeInsetsGeometry.only(left: 18,),
                              child:Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    size: 24,
                                    color: Colors.blueAccent,
                                  ),
                                  Padding(padding: EdgeInsetsGeometry.only(left: 10,)),
                                  Text("25 Jul 2026",//date of play quiz
                                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                  
                                  Padding(padding: EdgeInsetsGeometry.only(left: 25)),
                                  Text("|",style: TextStyle(fontSize: 20),),
                                  Padding(padding: EdgeInsetsGeometry.only(left: 25)),
                                  Icon(
                                    Icons.access_time,
                                    size: 24,
                                    color: Colors.blueAccent,
                                  ),
                                  Padding(padding: EdgeInsetsGeometry.only(left: 10,)),
                                  Text("25 Jul 2026",
                                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                ],
                              ),
                            ),

                            Text("----------------------------------------------------------------------------------"),
                          ],
                        ),
                      ),

                      Container(
                        child: Column(
                          children: [
                              Padding(padding: EdgeInsetsGeometry.only(left: 18),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.people_outline,
                                      size: 25,
                                      color: Colors.blueAccent,
                                    ),

                                    Padding(padding: EdgeInsetsGeometry.only(left: 10,)),
                                      Text("Participants :  ",
                                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),

                                      Text("number of the paticipans",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),// number of participans
                                  ],
                                ),
                              ),
                            
                              Padding(padding: EdgeInsetsGeometry.only(left: 18,top: 5),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.emoji_events_outlined,
                                      size: 25,
                                      color: Colors.blueAccent,
                                    ),

                                    Padding(padding: EdgeInsetsGeometry.only(left: 10,)),
                                      Text("Winner :  ",
                                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),

                                      Text("winner name",
                                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.blueAccent),
                                      ),// number of participans
                                  ],
                                ),
                              ),

                              Padding(padding: EdgeInsetsGeometry.only(left: 18,top: 5),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.flag_outlined,
                                    size: 25,
                                    color: Colors.blueAccent,
                                  ),

                                  Padding(padding: EdgeInsetsGeometry.only(left: 10,)),
                                  Text("Startus :  ",
                                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),

                                  Text("number of the paticipans",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color:Colors.green)),// number of participans
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ),
              ),

              Padding(
                padding:EdgeInsetsGeometry.all(20), 
                child: Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    // border: Border.all(color: Colors.black),
                    boxShadow:[
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,  
                        spreadRadius: 2,
                        offset: Offset(0, 10),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(padding: EdgeInsetsGeometry.only(top: 70,left: 15)),
                          Container(
                            width: 45,
                            height: 45,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.emoji_events_outlined,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Quiz Challenge',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      Container(
                        child: Column(
                          children: [
                            Padding(padding: EdgeInsetsGeometry.only(left: 18,),
                              child:Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    size: 24,
                                    color: Colors.blueAccent,
                                  ),
                                  Padding(padding: EdgeInsetsGeometry.only(left: 10,)),
                                  Text("25 Jul 2026",//date of play quiz
                                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                  
                                  Padding(padding: EdgeInsetsGeometry.only(left: 25)),
                                  Text("|",style: TextStyle(fontSize: 20),),
                                  Padding(padding: EdgeInsetsGeometry.only(left: 25)),
                                  Icon(
                                    Icons.access_time,
                                    size: 24,
                                    color: Colors.blueAccent,
                                  ),
                                  Padding(padding: EdgeInsetsGeometry.only(left: 10,)),
                                  Text("25 Jul 2026",
                                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                ],
                              ),
                            ),

                            Text("----------------------------------------------------------------------------------"),
                          ],
                        ),
                      ),

                      Container(
                        child: Column(
                          children: [
                              Padding(padding: EdgeInsetsGeometry.only(left: 18),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.people_outline,
                                      size: 25,
                                      color: Colors.blueAccent,
                                    ),

                                    Padding(padding: EdgeInsetsGeometry.only(left: 10,)),
                                      Text("Participants :  ",
                                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),

                                      Text("number of the paticipans",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),// number of participans
                                  ],
                                ),
                              ),
                            
                              Padding(padding: EdgeInsetsGeometry.only(left: 18,top: 5),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.emoji_events_outlined,
                                      size: 25,
                                      color: Colors.blueAccent,
                                    ),

                                    Padding(padding: EdgeInsetsGeometry.only(left: 10,)),
                                      Text("Winner :  ",
                                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),

                                      Text("winner name",
                                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.blueAccent),
                                      ),// number of participans
                                  ],
                                ),
                              ),

                              Padding(padding: EdgeInsetsGeometry.only(left: 18,top: 5),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.flag_outlined,
                                    size: 25,
                                    color: Colors.blueAccent,
                                  ),

                                  Padding(padding: EdgeInsetsGeometry.only(left: 10,)),
                                  Text("Startus :  ",
                                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),

                                  Text("number of the paticipans",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color:Colors.green)),// number of participans
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ),
              ),//quize challeng card end 
            ],
          ),
        ),
      ),
    );
  }
}