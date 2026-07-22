import 'package:flutter/material.dart';
import 'package:quiz_battle/admin/GeneralSettingScreen.dart';
import 'package:quiz_battle/admin/about_app_setting.dart';
import 'package:quiz_battle/admin/privacy_policy.dart';
import 'package:quiz_battle/auth/Choose_Role_Screen.dart';
import 'package:quiz_battle/auth/Splash_Screen.dart';

class Admin_setting extends StatefulWidget {
  const Admin_setting({super.key});

  @override
  State<Admin_setting> createState() => _Admin_settingState();
}

class _Admin_settingState extends State<Admin_setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: Text("System Setting",
        style: TextStyle(color: Colors.white,
          fontWeight:FontWeight.bold
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsGeometry.all(25),
              child: Container(
                child: Column(
                    children: [
                      Container(    
                      height: 60,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => GeneralSettingScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              "General Setting",
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20,),
                    Container(    
                      height: 60,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const AboutAppSetting()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              "About App",
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    Container(    
                      height: 60,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => SplashScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              "Delete Account",
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    Container(    
                      height: 60,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context) =>PrivacyPolicyScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              "Privacy Policy",
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(padding: EdgeInsetsDirectional.only(top: 30)),
                    SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => SplashScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout,size:40,color: Colors.blue,),
                            SizedBox(width: 10),
                            Text(
                              "Logout",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]
                )
              ),
            ),
          ]
        )
      )
    );
  }
}