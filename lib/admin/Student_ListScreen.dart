import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Stu_List extends StatefulWidget {
  const Stu_List({super.key});

  @override
  State<Stu_List> createState() => _Stu_ListState();
}

class _Stu_ListState extends State<Stu_List> {

  final search_organizer = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFF4A7CFF),
      appBar: AppBar(
        title: Text("Students",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF4A7CFF),
        toolbarHeight: 80,
      ),

      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF4A7CFF), Color(0xFF306AE7)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

                child: TextFormField(
                  controller: search_organizer,
                  decoration: InputDecoration(
                    hintText: "Search Student",
                    hintStyle: TextStyle(color: Colors.grey[200], fontSize: 20),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(top: 8.0,bottom: 8.0,left: 8.0),
                      child: Icon(Icons.search_rounded, color: Colors.white,size: 30,),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),

            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('player').snapshots(),
                  builder: (context,snapshot){
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Something went wrong"),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text("No Player Found"),
                      );
                    }

                    var playerList = snapshot.data!.docs;

                    return ListView.builder(
                        itemCount: playerList.length,
                        itemBuilder:(context,index){
                          var player = playerList[index];

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: screenHeight*0.09,
                              width: screenWidth,
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
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Color(0xFF4A7CFF),
                                  radius:30,
                                  child: Icon(
                                    Icons.person_rounded,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(player['player_name']),
                                subtitle: Text(player['player_email']),
                              ),
                            ),
                          );
                        }
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
