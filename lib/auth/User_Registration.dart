import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_battle/auth/login_admin_organiser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';


class user_Register extends StatefulWidget {
  const user_Register({super.key});

  @override
  State<user_Register> createState() => _user_RegisterState();
}

class _user_RegisterState extends State<user_Register>
{
  final formkey = GlobalKey<FormState>();
  final namecon = TextEditingController();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  void dispose() {
    namecon.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }


  Future sighUp() async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailcontroller.text.trim(),
      password: passwordcontroller.text.trim(),
      );

      addPlayerDetail("player");
    }on FirebaseAuthException catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message != null ?"Incorrect email or password":"Login failed try again"))
      );
    }
  }

    Future<void> addPlayerDetail(String? role) async{
      await FirebaseFirestore.instance.collection('player').add({
        'player_name':namecon.text.trim(),
        'player_email':emailcontroller.text.trim(),
        'role':role
      });
    }


  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      print(image.path);
    }
  }

  bool passwordvisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF4A7CFF),
                Color(0xFF306AE7),
              ]
          ),
        ),
        child: Center(
            child: Container(
              width: 300,
              height: 460,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20.00)),
              ),

              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        pickImage();
                      },
                      child: const CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.blue,
                          child: Icon(
                              Icons.add_a_photo,
                              size: 40,
                              color: Colors.white,
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text("Add Profile Image",style: TextStyle(fontSize: 11,color: Colors.blue),),
                  Text("Register",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.blue),),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child:
                    Form(
                        key: formkey,
                        child: Column(
                            children: [
                              TextFormField(
                                cursorColor: Colors.blue,
                                controller: namecon,
                                decoration:InputDecoration(
                                    border:
                                    OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                        borderSide: BorderSide(color:Colors.black)
                                    ),
                                    hintText: "Name",
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(color: Color(0xFF5E90E6))
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person_outline,
                                      color: Color(0xFF5E90E6),
                                      size: 30,
                                    )
                                ),
                              ),


                              SizedBox(height: 10,),
                              TextFormField(
                                cursorColor: Color(0xFF5E90E6),
                                  controller: emailcontroller,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                          Icons.email_outlined,color: Color(0xFF5E90E6)
                                      ),
                                      hintText: "Email",
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(color: Color(0xFF5E90E6))
                                      ),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)
                                      )
                                  ),
                                  validator: (value){
                                    if (value == null || value.isEmpty){
                                      return "Please Enter Your Email";
                                    }

                                    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)){
                                      return "Enter a valide Email";
                                    }
                                    return null;
                                  }
                              ),
                              SizedBox(height: 10,),
                              TextFormField(

                                  controller: passwordcontroller,
                                  obscureText: passwordvisible,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.lock_outline,
                                        color: Color(0xFF5E90E6),
                                        size: 30,
                                      ),

                                      hintText: "Password",
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(color: Color(0xFF5E90E6))
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      ),


                                      suffixIcon: IconButton(onPressed: (){
                                        setState(() {
                                          passwordvisible = !passwordvisible;
                                        });
                                      },
                                          icon:
                                          Icon(passwordvisible? Icons.visibility:Icons.visibility_off,))
                                  ),
                                  validator: (value){
                                    if (value == null || value.isEmpty){
                                      return "Please Enter Your password";
                                    }

                                    if (!RegExp(r'^.{8,}$').hasMatch(value)){
                                      return "Enter a valide password";
                                    }
                                    return null;
                                  }
                              ),

                              SizedBox(height: 20,),
                              Container(
                                width: 228,
                                child:

                                ElevatedButton(onPressed: ()async{
                                  if (formkey.currentState!.validate()){
                                    await sighUp();
                                  }
                                  if(await sighUp()){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("registretion Successful"),
                                      ),
                                    );
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen(role: "player")));
                                  }
                                },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF5E90E6),
                                  ),
                                  child: const Text("Sign Up",  textAlign: TextAlign.center,  style: TextStyle  (fontSize: 20,    color: Colors.white,),
                                  ),
                                ),
                              )
                            ]
                        )
                    ),
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
}