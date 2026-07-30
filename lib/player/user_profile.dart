import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_battle/auth/Choose_Role_Screen.dart';

class UserProfileInfo extends StatefulWidget {
  const UserProfileInfo({super.key});

  @override
  State<UserProfileInfo> createState() =>
      _UserProfileInfoState();
}

class _UserProfileInfoState extends State<UserProfileInfo> {
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic>? userInfo;

  Future<void> logout() async{
    await FirebaseAuth.instance.signOut();
  }

  @override
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

      appBar: AppBar(
        title: Text("Player Profile",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF4A7CFF),
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              // Organizer Profile Image Saction
              Container(
                width: screenWidth,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF4A7CFF),
                      Color(0xFF306AE7),
                    ],
                  ),
                ),
                child:Column(
                  children: [
                    const SizedBox(height: 40),

                    // const CircleAvatar(
                    //   radius: 58,
                    //   backgroundColor: Colors.white,
                    //   child: Icon(
                    //     Icons.person,
                    //     size: 58,
                    //     color: Colors.grey,
                    //   ),
                    // ),

                    Container(
                      width: 100,
                      height: 100,
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

                    const SizedBox(height: 10),

                    const Text(
                      "Player",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    Container(
                      width: screenWidth,
                      height: screenHeight,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 30,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('player')
                              .where('player_email', isEqualTo: FirebaseAuth.instance.currentUser!.email,)
                              .snapshots(),
                          builder: (context,snapshot){
                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return const Text("Player not found");
                            }
                            var data = snapshot.data!.docs.first.data();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Full Name *",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Container(
                                  width: screenWidth*0.95,
                                  height: screenHeight*0.06,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                        offset: Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                                    child: Text(
                                      data['player_name'],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w200
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                const Text(
                                  "Email Name *",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Container(
                                  width: screenWidth*0.95,
                                  height: screenHeight*0.06,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                        offset: Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                                    child: Text(
                                      data['player_email'],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w200
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 30),

                                SizedBox(
                                  width: screenWidth*0.95,
                                  height: screenHeight*0.08,
                                  child: ElevatedButton(
                                    onPressed: () async{
                                      await FirebaseAuth.instance.signOut();
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Choose_Role_Screen()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF306AE7),

                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.logout,size: 30,color: Colors.white,),
                                        SizedBox(width: 10),
                                        Text(
                                          "Logout",
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}