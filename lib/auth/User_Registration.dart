import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:quiz_battle/auth/login_admin_organiser.dart';

class user_Register extends StatefulWidget {
  const user_Register({super.key});

  @override
  State<user_Register> createState() => _user_RegisterState();
}

class _user_RegisterState extends State<user_Register> {
  final formkey = GlobalKey<FormState>();
  final namecon = TextEditingController();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final confirmPasswordController = TextEditingController();

  static const String cloudName = "bjcbyn5j";
  static const String uploadPreset = "quizx-app";
  static final Uri _uploadUrl = Uri.parse(
    "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
  );

  File? selectedImage;
  bool passwordvisible = false;
  bool confirmPasswordVisible = false;
  bool isLoading = false;

  @override
  void dispose() {
    namecon.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();

    XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
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

  Future sighUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailcontroller.text.trim(),
        password: passwordcontroller.text.trim(),
      );

      String imageURL = "";
      if (selectedImage != null) {
        imageURL = await uploadImage(selectedImage!);
      }

      await addPlayerDetail("player", imageURL);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 4,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 70),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFFECDD3), width: 1),
          ),
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: Color(0xFFEF4444),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  e.message ?? "Registration failed, please try again",
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      rethrow;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 4,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 70),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFFECDD3), width: 1),
          ),
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: Color(0xFFEF4444),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "An error occurred during registration.",
                  style: TextStyle(
                    color: Color(0xFF0F172A),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      rethrow;
    }
  }

  Future<void> addPlayerDetail(String? role, String imageUrl) async {
    await FirebaseFirestore.instance
        .collection('player')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'player_name': namecon.text.trim(),
      'player_email': emailcontroller.text.trim(),
      'role': role,
      'played_battle': 0,
      'player_win': 0,
      'image_url': imageUrl,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Base Gradient Background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFEBF2FF),
                  Color(0xFFF3F6FA),
                  Color(0xFFE8F0FE),
                ],
              ),
            ),
          ),

          // 2. Soft Glowing Background Orbs
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1D61E7).withOpacity(0.12),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF60A5FA).withOpacity(0.15),
              ),
            ),
          ),

          // 3. Main Form Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo Icon
                    const Icon(
                      Icons.emoji_events_outlined,
                      size: 64,
                      color: Color(0xFF1D61E7),
                    ),
                    const SizedBox(height: 12),

                    // App Title
                    const Text(
                      'QuizX',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Tagline
                    const Text(
                      'Challenge. Learn. Win.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Original Form Container
                    Container(
                      constraints: const BoxConstraints(maxWidth: 420),
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Form(
                        key: formkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Player Registration',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1D61E7),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Create your player profile to join battles',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Profile Image Picker Section
                            Center(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: pickImage,
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: 90,
                                          height: 90,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: const Color(0xFFEEF2FF),
                                            border: Border.all(
                                              color: const Color(0xFF1D61E7),
                                              width: 2,
                                            ),
                                          ),
                                          child: selectedImage != null
                                              ? ClipRRect(
                                            borderRadius: BorderRadius.circular(50),
                                            child: Image.file(
                                              selectedImage!,
                                              width: 90,
                                              height: 90,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                              : const Icon(
                                            Icons.add_a_photo_outlined,
                                            size: 36,
                                            color: Color(0xFF1D61E7),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF1D61E7),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.edit,
                                              size: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Add Profile Image",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1D61E7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Inline Name Field
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(14.0),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEEF2FF),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.person_outline, color: Color(0xFF1D61E7), size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Name',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0F172A),
                                          ),
                                        ),
                                        TextFormField(
                                          controller: namecon,
                                          keyboardType: TextInputType.text,
                                          validator: (value) {
                                            if (value == null || value.trim().isEmpty) {
                                              return "Please Enter Your Name";
                                            }
                                            return null;
                                          },
                                          style: const TextStyle(fontSize: 13, color: Color(0xFF334155)),
                                          decoration: const InputDecoration(
                                            hintText: 'Enter your name',
                                            hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                                            isDense: true,
                                            contentPadding: EdgeInsets.only(top: 2, bottom: 2),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Inline Email Field
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(14.0),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEEF2FF),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.email_outlined, color: Color(0xFF1D61E7), size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Email',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0F172A),
                                          ),
                                        ),
                                        TextFormField(
                                          controller: emailcontroller,
                                          keyboardType: TextInputType.emailAddress,
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
                                          style: const TextStyle(fontSize: 13, color: Color(0xFF334155)),
                                          decoration: const InputDecoration(
                                            hintText: 'Enter your email address',
                                            hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                                            isDense: true,
                                            contentPadding: EdgeInsets.only(top: 2, bottom: 2),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Inline Password Field
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(14.0),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEEF2FF),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.lock_outline, color: Color(0xFF1D61E7), size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Password',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0F172A),
                                          ),
                                        ),
                                        TextFormField(
                                          controller: passwordcontroller,
                                          obscureText: !passwordvisible,
                                          keyboardType: TextInputType.text,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return "Please Enter Your password";
                                            }
                                            if (!RegExp(r'^.{8,}$').hasMatch(value)) {
                                              return "Enter a valid password (min 8 chars)";
                                            }
                                            return null;
                                          },
                                          style: const TextStyle(fontSize: 13, color: Color(0xFF334155)),
                                          decoration: const InputDecoration(
                                            hintText: 'Enter your password',
                                            hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                                            isDense: true,
                                            contentPadding: EdgeInsets.only(top: 2, bottom: 2),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      passwordvisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                      color: const Color(0xFF94A3B8),
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        passwordvisible = !passwordvisible;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Inline Confirm Password Field
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(14.0),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEEF2FF),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.lock_reset_outlined, color: Color(0xFF1D61E7), size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Confirm Password',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0F172A),
                                          ),
                                        ),
                                        TextFormField(
                                          controller: confirmPasswordController,
                                          obscureText: !confirmPasswordVisible,
                                          keyboardType: TextInputType.text,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return "Please Confirm Your Password";
                                            }
                                            if (value != passwordcontroller.text) {
                                              return "Passwords do not match";
                                            }
                                            return null;
                                          },
                                          style: const TextStyle(fontSize: 13, color: Color(0xFF334155)),
                                          decoration: const InputDecoration(
                                            hintText: 'Re-enter your password',
                                            hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                                            isDense: true,
                                            contentPadding: EdgeInsets.only(top: 2, bottom: 2),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      confirmPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                      color: const Color(0xFF94A3B8),
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        confirmPasswordVisible = !confirmPasswordVisible;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Sign Up Button
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1D61E7),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: isLoading
                                    ? null
                                    : () async {
                                  if (formkey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    try {
                                      await sighUp();
                                      if (!mounted) return;

                                      // Success SnackBar
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          elevation: 4,
                                          behavior: SnackBarBehavior.floating,
                                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 70),
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                            side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
                                          ),
                                          content: Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF1D61E7).withOpacity(0.1),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.check_circle_outline_rounded,
                                                  color: Color(0xFF1D61E7),
                                                  size: 22,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              const Expanded(
                                                child: Text(
                                                  "Registration Successful!",
                                                  style: TextStyle(
                                                    color: Color(0xFF0F172A),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );

                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const LoginScreen(),
                                        ),
                                      );
                                    } catch (_) {
                                      // Errors handled in sighUp
                                    } finally {
                                      if (mounted) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    }
                                  }
                                },
                                child: isLoading
                                    ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                                    : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Redirect to Login
                            Center(
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                children: [
                                  const Text(
                                    'Already have an account? ',
                                    style: TextStyle(
                                      color: Color(0xFF64748B),
                                      fontSize: 13,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const LoginScreen(),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(4),
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                        color: Color(0xFF1D61E7),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
    );
  }
}