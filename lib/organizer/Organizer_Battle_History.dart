import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
        title: Text(
          "Battle History",
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Battle_Room_Details')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Something went wrong"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Battle Room Data Found"));
          }

          var RoomDetails = snapshot.data!.docs;

          return ListView.builder(
            itemCount: RoomDetails.length,
            itemBuilder: (context, index) {
              var RoomDetailsList = RoomDetails[index];

              Timestamp timestamp = RoomDetailsList['battle_date'];
              DateTime date = timestamp.toDate();
              return Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  width: screenWidth * 0.95,
                  height: screenHeight * 0.35,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
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
                            SizedBox(width: 12),
                            Text(
                              RoomDetailsList['room_name'],
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
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month_outlined,
                                      size: 24,
                                      color: Colors.blueAccent,
                                    ),
                                    Padding(
                                      padding: EdgeInsetsGeometry.only(left: 10),
                                    ),
                                    Text(
                                      "${date.day}/${date.month}/${date.year}", //date of play quiz
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsetsGeometry.only(left: 25),
                                    ),
                                    Text("|", style: TextStyle(fontSize: 20)),
                                    Padding(
                                      padding: EdgeInsetsGeometry.only(left: 25),
                                    ),
                                    Icon(
                                      Icons.access_time,
                                      size: 24,
                                      color: Colors.blueAccent,
                                    ),
                                    Padding(
                                      padding: EdgeInsetsGeometry.only(left: 10),
                                    ),
                                    Text(
                                      RoomDetailsList['start_time']?.toString() ??
                                          "N/A",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsetsGeometry.all(10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.people_outline,
                                      size: 25,
                                      color: Colors.blueAccent,
                                    ),

                                    Padding(
                                      padding: EdgeInsetsGeometry.only(left: 10),
                                    ),
                                    Text(
                                      "Participants :  ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),

                                    Text(
                                      "2",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    // number of participans
                                  ],
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.emoji_events_outlined,
                                      size: 25,
                                      color: Colors.blueAccent,
                                    ),

                                    Padding(
                                      padding: EdgeInsetsGeometry.only(left: 10),
                                    ),
                                    Text(
                                      "Winner :  ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),

                                    Text(
                                      "winner name",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blueAccent,
                                      ),
                                    ), // number of participans
                                  ],
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.flag_outlined,
                                      size: 25,
                                      color: Colors.blueAccent,
                                    ),
                                    Padding(
                                      padding: EdgeInsetsGeometry.only(left: 10),
                                    ),
                                    Text(
                                      "Startus :  ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "number of the paticipans",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),

      //quize challeng card end
    );
  }
}
