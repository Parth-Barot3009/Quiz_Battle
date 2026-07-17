import 'package:flutter/material.dart';
import 'package:quiz_battle/Admin_Deshboard.dart';
import 'package:quiz_battle/login_admin_organiser_user.dart';
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
                Color(0xFF4A7CFF),
                Color(0xFF306AE7), // Bottom Blue
              ],
            ),
          ),

          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text("Select Your Role",style: TextStyle(color: Colors.white,fontSize:30)),
                ),

                // Admin Button
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(role: "admin"),));
                    //Navigate to Admin Login Page
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 120,
                      width: 390,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Container(
                              height: 59,
                              width: 59,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color(0xFF4A7CFF),
                                  Color(0xFF306AE7),
                                ]),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Icon(
                                Icons.admin_panel_settings,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("ADMIN",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily:'Bevan',
                                  color: Color(0xFF306AE7),
                                ),
                              ),

                              Text("Manage the entire room ",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily:'Bevan',
                                  color: Color(0xFF306AE7),
                                ),
                              ),

                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Icon(
                              Icons.chevron_right,
                              size: 40,
                              color: Color(0xFF306AE7),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),


                // Organizer Button

                GestureDetector(
                  onTap: (){
                    //Navigate to Organizer Login Page
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 120,
                      width: 390,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Container(
                              height: 59,
                              width: 59,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color(0xFF4A7CFF),
                                  Color(0xFF306AE7),
                                ]),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Icon(
                                Icons.menu_book_outlined,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("ORGANIZER",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily:'Bevan',
                                  color: Color(0xFF306AE7),
                                ),
                              ),

                              Text("Create & host quiz battle ",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily:'Bevan',
                                  color: Color(0xFF306AE7),
                                ),
                              ),

                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Icon(
                              Icons.chevron_right,
                              size: 40,
                              color: Color(0xFF306AE7),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                // Player Button

                GestureDetector(
                  onTap: (){
                    //Navigate to Player Login Page
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 120,
                      width: 390,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Container(
                              height: 59,
                              width: 59,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color(0xFF4A7CFF),
                                  Color(0xFF306AE7),
                                ]),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Icon(
                                Icons.person_rounded ,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("PLAYER",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily:'Bevan',
                                  color: Color(0xFF306AE7),
                                ),
                              ),

                              Text("join battles & compete",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily:'Bevan',
                                  color: Color(0xFF306AE7),
                                ),
                              ),

                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Icon(
                              Icons.chevron_right,
                              size: 40,
                              color: Color(0xFF306AE7),
                            ),
                          )
                        ],
                      ),
                    ),
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