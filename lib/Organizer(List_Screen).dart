import 'package:flutter/material.dart';
import 'package:quiz_battle/addorganiser.dart';

class Org_List extends StatefulWidget {
  const Org_List({super.key});

  @override
  State<Org_List> createState() => _Org_ListState();
}

class _Org_ListState extends State<Org_List> {
  final search_organizer = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                child: Column(
                  children: [
                    // Organiser Image
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
        
        
                          // Organiser Name and Email
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Organiser 1",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
        
                              Text("Organiser Email",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        SizedBox(width: 145,),
                        //   Delete Organiser
                          Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                )],
                              ),
                              child: Icon(
                                color: Color(0xFF4A7CFF),
                                Icons.delete_outline,
                                size: 30,
                              ),
                            ),
                        ],
                      ),
                    ),
        
                  SizedBox(height: 20,),
                  //   2nd Organiser
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
        
        
                          // Organiser Name and Email
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Organiser 1",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
        
                              Text("Organiser Email",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 145,),
                          //   Delete Organiser
                          Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(
                                color: Colors.grey,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              )],
                            ),
                            child: Icon(
                              color: Color(0xFF4A7CFF),
                              Icons.delete_outline,
                              size: 30,
                            ),
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
