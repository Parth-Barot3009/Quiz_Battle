import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class org_dashboard extends StatefulWidget {
  const org_dashboard({super.key});

  @override
  State<org_dashboard> createState() => _org_dashboardState();
}

class _org_dashboardState extends State<org_dashboard> {
  final currentUser = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userInfo;
  void initState() {
    // TODO: implement initState
    getUser();
    super.initState();
  }
  void getUser() async{
    userInfo = await getDocumentById(FirebaseAuth.instance.currentUser!.uid.toString());
    setState(() {});
  }

  Future<Map<String, dynamic>?> getDocumentById(String docId) async {
    try {
      print(docId);
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('player')
          .doc(docId)
          .get();

      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>;
      } else {
        print("Document does not exist");
        return null;
      }
    } catch (e) {
      print("Error fetching document: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      //title
      appBar: AppBar(
        toolbarHeight: 80,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.45],
              colors: [Color(0xFF4A7CFF), Color(0xFF306AE7)],
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        title: Text(
          "Dashboard",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            width: 80,
            height: 80,
            child: userInfo != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(100.0), // Adjust radius size here
              child: Image.network(
                userInfo!["image_url"],
                fit: BoxFit.cover, // Ensures the image fills the bounds cleanly
              ),
            ) : const Icon(
              Icons.add_a_photo,
              size: 40,
              color: Colors.white,
            ),
          ),
        ],
      ),

      //nav menu

      //body
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFF306AE7),
          child: Container(
            width: screenWidth,
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF4A7CFF), Color(0xFF306AE7)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: screenWidth,
                    height: screenHeight * 0.20,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('organizer')
                          .where(
                            'o_email',
                            isEqualTo: FirebaseAuth.instance.currentUser!.email,
                          )
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Text("Organizer not found");
                        }
                        var data = snapshot.data!.docs.first.data();
                        return Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 30),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Welcome Back !",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            Text(
                                              data['o_name'],
                                              style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              FirebaseAuth
                                                      .instance
                                                      .currentUser
                                                      ?.email ??
                                                  "",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // ),
                                Spacer(),
                                Opacity(
                                  opacity: 0.5,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: Icon(
                                      Icons.menu_book_sharp,
                                      size: 90,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                //students , battle , quizzes
                Padding(
                  padding: const EdgeInsets.all(9),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: BoxBorder.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('player')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData ||
                                      snapshot.data!.docs.isEmpty) {
                                    return const Text("Player Data found");
                                  }

                                  var totalPlyer = snapshot.data!.docs.length;
                                  return Text(
                                    "$totalPlyer",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                              Text(
                                "Students",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(width: 10),

                      Expanded(
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: BoxBorder.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('Battle_Room_Details').where('o_email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                    return const Text(
                                      "0",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }

                                  var totalBattleRoom =
                                      snapshot.data!.docs.length;
                                  return Text(
                                    "$totalBattleRoom",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                              Text(
                                "Battles",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(width: 10),

                      Expanded(
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: BoxBorder.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "15",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Quizzes",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //upload quiz
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "MY QUIZZES",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: "BaiJamjuree",
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          // Navigate to upload page
                        },
                        child: TextButton.icon(
                          onPressed: () {
                            // upload action
                          },
                          icon: Icon(Icons.add),
                          label: Text("Upload Quiz"),
                        ),
                      ),
                    ],
                  ),
                ),

                //quizzes list
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: screenWidth,
                    height: screenHeight * 0.10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF4A7CFF), Color(0xFF306AE7)],
                      ),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          // Left icon
                          Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Colors.white.withValues(alpha: 0.18),
                              // Low opacity white box
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.15),
                                width: 1,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.quiz_rounded,
                                // or Icons.menu_book_rounded
                                color: Colors.white,
                                size: 34,
                              ),
                            ),
                          ),

                          SizedBox(width: 15),

                          // Middle text section
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Flutter Battle 2026",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),

                                SizedBox(height: 5),

                                Text(
                                  "10 Questions • Technology",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Right button
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                            ),
                            child: Text("Active"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
