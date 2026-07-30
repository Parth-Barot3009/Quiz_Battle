import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_battle/admin/addorganiser.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Org_List extends StatefulWidget {
  const Org_List({super.key});

  @override
  State<Org_List> createState() => _Org_ListState();
}

class _Org_ListState extends State<Org_List> {
  final search_organizer = TextEditingController();


  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFF4A7CFF),
      appBar: AppBar(
        title: Text("Organizer",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF4A7CFF),
        toolbarHeight: 80,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Addorganiser()));
                  },
                  icon: Icon(Icons.add),
                ),
              ),
            ),
          ),
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
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
                    hintText: "Search Organizer",
                    hintStyle: TextStyle(color: Colors.grey[200], fontSize: 16),
                    prefixIcon: Icon(Icons.search_rounded, color: Colors.white),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),
        
            // Container of Organiser's list
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('organizer').snapshots(),
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
                        child: Text("No Organizer Found"),
                      );
                    }

                    var organizerList = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: organizerList.length,
                      itemBuilder:(context,index){
                        var organizer = organizerList[index];

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
                              title: Text(organizer['o_name']),
                              subtitle: Text(organizer['o_email']),
                              trailing: IconButton(onPressed: () async{
                                print("Document ID: ${organizer.id}");
                                await FirebaseFirestore.instance.collection('organizer').doc(organizer.id).delete();
                              }, icon: Icon(Icons.delete)),
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