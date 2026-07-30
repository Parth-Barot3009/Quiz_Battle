import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

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

  static const String cloudName = "bjcbyn5j";
  static const String uploadPreset = "quizx-app";
  static final Uri _uploadUrl = Uri.parse(
    "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
  );

  File? selectedImage;

  bool passwordvisible = true;

  Future<void> pickImage() async {
    final picker = ImagePicker();

    XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      setState(() {});
    }
  }

  static Future<String> uploadImage(File imageFile) async {
    try {
      final request = http.MultipartRequest("POST", _uploadUrl);
      request.fields["upload_preset"] = uploadPreset;
      request.files.add(
        await http.MultipartFile.fromPath("file", imageFile.path),
      );
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(responseBody);
        return data["secure_url"] as String;
      }
      throw Exception(
        "Cloudinary Upload Failed (${response.statusCode})\n$responseBody",
      );
    } catch (e) {
      throw Exception("Image upload failed: $e");
    }
  }


  Future createOrg() async{
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailcontroller.text.trim(), password: passwordcontroller.text.trim());

  }


  Future<void> addOrganizerDetail(String? role, String imageUrl) async {

    await FirebaseFirestore.instance
        .collection('organizer')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'o_name':namecon.text.trim(),
      'o_email':emailcontroller.text.trim(),
      'role': role,
      'image_url': imageUrl,
    });
  }

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
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                  Container(
                    child: GestureDetector(
                      onTap: () async {
                        print("Hello");
                        await pickImage();
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.blue,
                        ),
                        child: selectedImage != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          // Adjust radius size here
                          child: Image.file(
                            selectedImage!,
                            width: 100,
                            height: 100,
                            fit: BoxFit
                                .cover, // Ensures the image fills the bounds cleanly
                          ),
                        )
                            : const Icon(
                          Icons.add_a_photo,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

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
                                label: Text("Name",style: TextStyle(fontWeight: FontWeight.bold,),),
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
                                onPressed: () async {
                                  try {
                                    if (!formKey.currentState!.validate()) return;

                                    if (selectedImage == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Please Select Image"),
                                        ),
                                      );
                                      return;
                                    }

                                    String imageUrl = await uploadImage(selectedImage!);
                                    print("Image Uploaded");

                                    await createOrg();
                                    print("Auth Created");

                                    await addOrganizerDetail("organizer", imageUrl);
                                    print("Firestore Added");

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Add Organiser Successful"),
                                      ),
                                    );

                                    Navigator.pop(context);
                                  } catch (e) {
                                    print("ERROR: $e");

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(e.toString()),
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