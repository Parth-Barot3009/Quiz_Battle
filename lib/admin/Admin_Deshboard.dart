import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_battle/admin/addorganiser.dart';
import 'package:quiz_battle/auth/Choose_Role_Screen.dart';


class AdminDeshboard extends StatefulWidget {
  const AdminDeshboard({super.key});

  @override
  State<AdminDeshboard> createState() => _AdminDeshboardState();
}

class _AdminDeshboardState extends State<AdminDeshboard> {

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Text("Admin Deshboard\nManage your quiz platform",style: TextStyle(color: Colors.white),),

    return Scaffold(
      appBar: AppBar(
        title: Text("ADMIN DASHBOARD",
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,

          ),
        ),
        // automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF306AE7),
        toolbarHeight: 80,
      ),

      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFF306AE7),
          child: Padding(
            padding: const EdgeInsets.only(),
            child: Container(
              height: screenHeight,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: screenWidth,
                      height: screenHeight*0.18,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF4A7CFF),
                                Color(0xFF306AE7),
                              ]
                          )
                      ),

                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 25),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15,top: 20),
                                        child: Text("Welcome,",style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                        ),),
                                      ),
                                      Text("Admin",style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                              Opacity(
                                opacity: 0.5,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Icon(
                                    Icons.shield_outlined,
                                    size: 120,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 1st Section
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        //Organizer Card
                        SizedBox(
                          child: Container(
                            width: screenWidth*0.45,
                            height: screenHeight*0.15,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.red,
                                width: 3,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius:25,
                                    backgroundColor: Colors.red[100],
                                    child: Icon(
                                      Icons.group_outlined,
                                      size: 30,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  SizedBox(width: 6,),

                                  // View Oranizer number and add number of organizer number from database.
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("36",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text("Organizer",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        // Student Card

                        SizedBox(
                          child: Container(
                            width: screenWidth*0.45,
                            height: screenHeight*0.15,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.green,
                                width: 3,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius:25,
                                    backgroundColor: Colors.lightGreenAccent[100],
                                    child: Icon(
                                      Icons.person,
                                      size: 30,
                                      color: Colors.green,
                                    ),
                                  ),
                                  SizedBox(width: 9,),
                                  // View Oranizer number and add number of organizer number from database.
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("36",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text("Student",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  // 2nd Section

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        //Active Battle Card
                        SizedBox(
                          child: Container(
                            width: screenWidth*0.45,
                            height: screenHeight*0.15,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.red,
                                width: 3,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius:25,
                                    backgroundColor: Colors.deepOrange[100],
                                    child: Icon(
                                      Icons.crop_square,
                                      size: 30,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  SizedBox(width: 6,),

                                  // View Oranizer number and add number of organizer number from database.
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("36",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text("Active Battles",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        // Student Card

                        SizedBox(
                          child: Container(
                            width: screenWidth*0.45,
                            height: screenHeight*0.15,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue,
                                width: 3,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius:25,
                                    backgroundColor: Colors.lightBlueAccent[100],
                                    child: Icon(
                                      Icons.book_outlined,
                                      size: 30,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  SizedBox(width: 9,),
                                  // View Oranizer number and add number of organizer number from database.
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("36",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text("Total Battles",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),


                  // Quick Actions Text
                  Padding(
                    padding: const EdgeInsets.only(left: 15,top: 25),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text("QUICK ACTIONS",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  // Add organizer Button
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Addorganiser()));
                      },
                      child: Container(
                        width: screenWidth*70,
                        height: screenHeight*0.09,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF4A7CFF),
                              Color(0xFF306AE7),
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10,left: 12),
                              child:Icon(
                                  Icons.person_add_alt_1,
                                  size: 45,
                                  color: Colors.white,
                                ),

                            ),
                            SizedBox(width: 10,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Add Organizer",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text("Create new organizer account",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Choose_Role_Screen(),
                        ),
                            (route) => false,
                      );
                    },
                    child: const Text("Sign Out"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}