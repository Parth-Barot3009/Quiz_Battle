import 'package:flutter/material.dart';
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
                Color(0xff3C005E),
                Color(0xff5B138A),
                Color(0xff3C005E)
              ]
          ),
        ),
        child: Center(
            child: Container(
              width: 350,
              height: 500,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.20),
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
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.add_a_photo,
                            size: 40,
                            color: Colors.grey,
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text("Add Profile Image",style: TextStyle(fontSize: 11,color: Colors.white),),
                  Text("Register",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
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
                                    hintText: "Enter your name",
                                    labelText: "Name",
                                    filled: true ,
                                    fillColor:Colors.white,
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                      size: 30,
                                      fontWeight: FontWeight.bold,
                                    )
                                ),
                              ),


                              SizedBox(height: 10,),
                              TextFormField(
                                  controller: emailcontroller,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                          Icons.email,color: Colors.grey
                                      ),
                                      hintText: "Enter your email",
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
                                        Icons.lock,
                                        color: Colors.grey,
                                        size: 30,
                                        fontWeight: FontWeight.bold,
                                      ),

                                      hintText: "Enter your password",
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
                                width: 270,
                                child:

                                ElevatedButton(onPressed: (){
                                  if (formkey.currentState!.validate()){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("registretion Successful"),
                                      ),
                                    );
                                  }
                                },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                  ),
                                  child: const Text(  "Register",  textAlign: TextAlign.center,  style: TextStyle  (    fontSize: 25,    color: Color(0xFFFFF7F7),),
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