import 'package:flutter/material.dart';
import 'package:quiz_battle/Admin_Deshboard.dart';
import 'package:quiz_battle/login(admin-organiser).dart';
import 'package:quiz_battle/organiser(dashboard).dart';


class Choose_Role_Screen extends StatefulWidget {
  const Choose_Role_Screen({super.key});

  @override
  State<Choose_Role_Screen> createState() => _Choose_Role_ScreenState();
}

class _Choose_Role_ScreenState extends State<Choose_Role_Screen> {

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                // Color(0xFF023E8A),
                Color(0xFF1565C0),
                Color(0xFF42A5F5),
                Color(0xFF90CAF9),
                Color(0xFFE3F2FD),
              ],
            ),
          ),

          child: Container(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Select Your Role",style: TextStyle(color: Colors.white,fontSize:30)),
                ),

                // Player Button

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(350, 100),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: (){

                      }, child: Row(
                        children: [
                          Icon(
                            Icons.person_rounded ,
                              size: 60,
                            color: Color(0xFF4CC6FF),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text("Player",
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily:'Bevan',
                                color: Color(0xFF4CC6FF),
                              ),
                            ),
                          ),
                      Spacer(),
                      Icon(
                        Icons.chevron_right,
                        size: 30,
                        color: Color(0xFF4CC6FF),
                      )
                        ],
                      )
                  ),
                ),

                // Organizer Button

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(350, 100),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: (){
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const o_dashboard()),
                        );
                      }, child:  Row(
                    children: [
                      Icon(
                        Icons.menu_book_sharp ,
                        size: 60,
                        color: Color(0xFF4CC6FF),
                      ),

                       Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text("Organiser",
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'Bevan',
                              color: Color(0xFF4CC6FF),
                            ),
                          ),
                        ),
                      Spacer(),

                      Icon(
                        Icons.chevron_right,
                        size: 30,
                        color: Color(0xFF4CC6FF),
                      )
                    ],
                  )),
                ),

                // Admin Button
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(350, 100),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: (){
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login(role: "admin",)),
                        );
                      }, child:  Row(
                    children: [
                      Icon(
                        Icons.admin_panel_settings,
                        size: 60,
                        color: Color(0xFF4CC6FF),
                      ),

                       Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text("Admin",
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'Bevan',
                              color: Color(0xFF4CC6FF),
                            ),
                          ),
                        ),
                      Spacer(),
                      Icon(
                        Icons.chevron_right,
                        size: 30,
                        color: Color(0xFF4CC6FF),
                      )
                    ]
                    )
                  ),
                ),
                const SizedBox(width: 100,height: 100,)
              ],
            ),
          ),
        ),
      );
  }
}