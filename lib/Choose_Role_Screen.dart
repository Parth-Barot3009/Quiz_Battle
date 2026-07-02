import 'package:flutter/material.dart';
import 'package:quiz_battle/Admin_Deshboard.dart';

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
                    Color(0xFF7209B7),
                    Color(0xFF320451),
                  ]
              )
          ),

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
                      backgroundColor: Color(280440),
                    ),
                    onPressed: (){}, child: Row(
                      children: [
                        Icon(
                            Icons.sports_esports ,
                            size: 60,
                          color: Colors.white,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text("Player",
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily:'Bevan',
                              color: Colors.white
                            ),
                          ),
                        ),
                    Spacer(),
                    Icon(
                      Icons.chevron_right,
                      size: 30,
                      color: Colors.white,
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
                      backgroundColor: Color(280440),
                    ),
                    onPressed: (){}, child:  Row(
                  children: [
                    Icon(
                      Icons.menu_book_sharp ,
                      size: 60,
                      color: Colors.white,
                    ),

                     Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text("Organiser",
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Bevan',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    Spacer(),

                    Icon(
                      Icons.chevron_right,
                      size: 30,
                      color: Colors.white,
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
                      backgroundColor: Color(280440),
                    ),
                    onPressed: (){
                      Navigator.push(context, 
                        MaterialPageRoute(builder: (context) => const AdminDeshboard()),
                      );
                    }, child:  Row(
                  children: [
                    Icon(
                      Icons.admin_panel_settings,
                      size: 60,
                      color: Colors.white,
                    ),

                     Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text("Admin",
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Bevan',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    Spacer(),

                    Icon(
                      Icons.chevron_right,
                      size: 30,
                      color: Colors.white,
                    )
                  ]
                  )
                ),
              ),
              const SizedBox(width: 100,height: 100,)
            ],
          ),
        ),
      );
  }
}