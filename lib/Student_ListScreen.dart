import 'package:flutter/material.dart';

class Stu_List extends StatefulWidget {
  const Stu_List({super.key});

  @override
  State<Stu_List> createState() => _Stu_ListState();
}

class _Stu_ListState extends State<Stu_List> {
  @override
  final search_organizer = TextEditingController();

  Widget build(BuildContext context) {
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
        backgroundColor: Color(0xFF4A7CFF),
        toolbarHeight: 100,
      ),

      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
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
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

                child: TextFormField(
                  controller: search_organizer,
                  decoration: InputDecoration(
                    hintText: "Search Student",
                    hintStyle: TextStyle(color: Colors.grey[200], fontSize: 16),
                    prefixIcon: Icon(Icons.search_rounded, color: Colors.white),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),

            // Container of Student's list
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                child: Column(
                  children: [
                    // Student Image
                    Container(
                      height: 90,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 8,
                              offset: Offset(0, 5)
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: CircleAvatar(
                              backgroundColor: Color(0xFF4A7CFF),
                              radius:30,
                              child: Icon(
                                Icons.person_rounded,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 25,),


                          // Student Name,total battles and win
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Student 1",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Text("25 battles , 5 wins",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20,),
                    //   2nd Student
                    Container(
                      height: 90,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 8,
                              offset: Offset(0, 5)
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: CircleAvatar(
                              backgroundColor: Color(0xFF4A7CFF),
                              radius:30,
                              child: Icon(
                                Icons.person_rounded,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 25,),


                          // Student Name,total battles and win
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Student 2",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Text("25 battles , 5 wins",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
