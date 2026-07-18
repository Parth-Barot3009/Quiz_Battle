import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_battle/login_admin_organiser.dart';
// import 'package:image_picker/image_picker.dart';


class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _Register();
}

class _Register extends State<Register>
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
    }on FirebaseAuthException catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message != null ?"Incorrect email or password":"Login failed try again"))
      );
    }
  }

  // final ImagePicker picker = ImagePicker();

// Future<void> pickImage() async {
//   final XFile? image = await picker.pickImage(
//     source: ImageSource.gallery,
//   );

//   if (image != null) {
//     print(image.path);
//   }
// }

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
                        print("Profile Image Clicked");
                      },
                      child: const CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.blue,
                          child: Icon(
                              Icons.add_a_photo,
                              size: 40,
                              color: Colors.white
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
                                decoration:InputDecoration(
                                    border:
                                    OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                        borderSide: BorderSide(color:Color(0xFF4E3F3F))
                                    ),
                                    hintText: "Name",

                                    filled: true ,
                                    fillColor:Colors.white,
                                    prefixIcon: Icon(
                                      Icons.person_outline,
                                      color: Color(0xFF5E90E6),
                                      size: 30,
                                    )
                                ),
                              ),


                              SizedBox(height: 10,),
                              TextFormField(
                                  controller: emailcontroller,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                          Icons.email_outlined,color: Color(0xFF5E90E6)
                                      ),
                                      hintText: "Email",
                                      filled: true ,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)
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
                                      filled: true ,
                                      fillColor:Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
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

                                ElevatedButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(role: "player")));

                                  if (formkey.currentState!.validate()){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("registretion Successful"),
                                      ),
                                    );
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