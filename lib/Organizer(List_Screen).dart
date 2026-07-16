import 'package:flutter/material.dart';

class Org_List extends StatefulWidget {
  const Org_List({super.key});

  @override
  State<Org_List> createState() => _Org_ListState();
}

class _Org_ListState extends State<Org_List> {
  @override
  final search_organizer = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Organizer"),
        toolbarHeight: 100,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  onPressed: () {
                    print("Button Pressed");
                    // Navigate to add organizeer
                  },
                  icon: Icon(Icons.add),
                ),
              ),
            ),
          ),
        ],
      ),

      body: Column(
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
                  hintText: "Search Organizer",
                  hintStyle: TextStyle(color: Colors.grey[200], fontSize: 16),
                  prefixIcon: Icon(Icons.search_rounded, color: Colors.white),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
