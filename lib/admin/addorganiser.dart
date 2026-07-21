import 'package:flutter/material.dart';

class Addorganiser extends StatefulWidget {
  const Addorganiser({super.key});

  @override
  State<Addorganiser> createState() => _AddorganiserState();
}

class _AddorganiserState extends State<Addorganiser> {
  final formKey = GlobalKey<FormState>();
  final namecon = TextEditingController();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  bool passwordvisible = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(

      appBar: AppBar(
        title: Text("Add Organizer",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF4A7CFF),
        toolbarHeight: 80,
      ),

      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF4A7CFF),
                Color(0xFF306AE7),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Container(
              height: screenHeight,
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  const SizedBox(height: 20),

                  IconButton(
                    onPressed: (){},
                    icon: CircleAvatar(
                    radius: 60,
                    backgroundColor: Color(0xFF306AE7),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),),

                  SizedBox(height: 10),

                  const Text(
                    "Add Organizer Image",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Container(
                    child: Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: namecon,
                              decoration: InputDecoration(
                                label: Text("Email",style: TextStyle(fontWeight: FontWeight.bold,),),
                                hintText: "Enter Full Name",
                                hintStyle: TextStyle(fontWeight: FontWeight.bold,),
                                prefixIcon: const Icon(
                                  Icons.person_outline,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF5E90E6),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter Full Name";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 25),

                            TextFormField(
                              controller: emailcontroller,
                              decoration: InputDecoration(
                                label: Text("Email",style: TextStyle(fontWeight: FontWeight.bold,),),
                                hintText: "Enter Email",
                                hintStyle: TextStyle(fontWeight: FontWeight.bold,),
                                prefixIcon: const Icon(
                                  Icons.email_outlined,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF5E90E6),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter Your Email";
                                }

                                if (!RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                                ).hasMatch(value)) {
                                  return "Enter a valid Email";
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 25),

                            TextFormField(
                              controller: passwordcontroller,
                              obscureText: passwordvisible,
                              decoration: InputDecoration(
                                label: Text("Password",style: TextStyle(fontWeight: FontWeight.bold,),),
                                hintText: "Enter Password",
                                hintStyle: TextStyle(fontWeight: FontWeight.bold,),
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF5E90E6),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      passwordvisible = !passwordvisible;
                                    });
                                  },
                                  icon: Icon(
                                    passwordvisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter Your Password";
                                }

                                if (value.length < 8) {
                                  return "Password must be at least 8 characters";
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 35),

                            SizedBox(
                              width: screenWidth*0.70,
                              height: screenHeight*0.07,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Add Organiser Successful"),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF306AE7),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                child: const Text(
                                  "Add Organiser",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}