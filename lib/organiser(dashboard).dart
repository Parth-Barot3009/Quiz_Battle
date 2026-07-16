import 'package:flutter/material.dart';
import 'package:quiz_battle/Admin_Deshboard.dart';
import 'package:quiz_battle/Splash_Screen.dart';
class o_dashboard extends StatefulWidget {
  const o_dashboard({super.key});

  @override
  State<o_dashboard> createState() => _o_dashboardState();
}

class _o_dashboardState extends State<o_dashboard> {
  @override

  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(

      //title
      appBar: AppBar(
        title: Text("Organizer\nDashboard",style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [IconButton(onPressed: (){}, icon:Icon(Icons.account_circle_rounded),iconSize: 50,  ),
        ],
      ),

      //nav menu


      //body

      body: Container(
        child: Column(

          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: screenWidth,
                height: 160,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF7209B7),
                          Color(0xFF320451),
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
                            padding: const EdgeInsets.only(bottom: 25,left: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15,top: 30),
                                  child: Column(
                                    children: [
                                      Text("Welcome!",style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                      ),),
                                      Text("pro.xyz",style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                      Text("xyz@gmail.com",style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),),
                                    ],
                                  ),
                                ),
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
                              Icons.menu_book_sharp,
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

            //students , battle , quizzes

            Padding(
              padding: const EdgeInsets.all(9),
              child: Row(
                children: [

                  // Number Of Students and Battles and Quizes

                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF7209B7),
                            Color(0xFF320451),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          // There is adding data from Firebase
                          Text("36",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("Students",
                            style: TextStyle(
                              color: Colors.white,
                            ),
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
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF7209B7),
                            Color(0xFF320451),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("8",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("Battles",
                            style: TextStyle(
                              color: Colors.white,
                            ),
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
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF7209B7),
                            Color(0xFF320451),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("15",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("Quizzes",
                            style: TextStyle(
                              color: Colors.white,
                            ),
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
                    )
                  ),
                ],
              ),
            ),


            //quizzes list


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: screenWidth,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.grey.withValues(alpha: 0.5)
                ),

                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: Row(
                      children: [

                        // Left icon
                        Icon(
                          Icons.book_outlined,
                          size: 50,
                          color: Colors.purple,
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 5),

                              Text(
                                "10 Questions • Technology",
                                style: TextStyle(
                                  color: Colors.grey[700],
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
                        )
                      ],
                    ),
                  )
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: screenWidth,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey.withValues(alpha: 0.5)
                  ),

                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: Row(
                      children: [

                        // Left icon
                        Icon(
                          Icons.book_outlined,
                          size: 50,
                          color: Colors.purple,
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 5),

                              Text(
                                "10 Questions • Technology",
                                style: TextStyle(
                                  color: Colors.grey[700],
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
                        )
                      ],
                    ),
                  )
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: screenWidth,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey.withValues(alpha: 0.5)
                  ),

                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: Row(
                      children: [

                        // Left icon
                        Icon(
                          Icons.book_outlined,
                          size: 50,
                          color: Colors.purple,
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 5),

                              Text(
                                "10 Questions • Technology",
                                style: TextStyle(
                                  color: Colors.grey[700],
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
                        )
                      ],
                    ),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
