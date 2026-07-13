import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    // Simulate API Call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Login Successful"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            ClipPath(
              clipper: HeaderClipper(),
              child: Container(
                height: 340,
                width: double.infinity,
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
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 55),

                      const Icon(
                        Icons.emoji_events_outlined,
                        size: 75,
                        color: Colors.white,
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "QUIZ BATTLE",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 34,
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        "Challenge. Learn. Win.",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 150),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF306AE7),
                          ),
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Sign in to your registered account",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ),

                      const SizedBox(height: 35),

                      buildTextField(
                        controller: emailController,
                        hint: "Email",
                        icon: Icons.person_outline,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 25),

                      buildTextField(
                        controller: passwordController,
                        hint: "Enter your password",
                        icon: Icons.lock_outline,
                        isPassword: true,
                      ),

                      const SizedBox(height: 18),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Forgot password?",
                          style: TextStyle(
                            color: Color(0xFF306AE7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const SizedBox(height: 35),

                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF306AE7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 8,
                          ),
                          onPressed: isLoading ? null : login,
                          child: isLoading
                              ? const SizedBox(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white,
                            ),
                          )
                              : const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword ? !isPasswordVisible : false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Please enter $hint";
        }

        if (!isPassword &&
            !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
          return "Enter a valid email";
        }

        if (isPassword && value.length < 6) {
          return "Password must be at least 6 characters";
        }

        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF306AE7),
        ),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            isPasswordVisible
                ? Icons.visibility
                : Icons.visibility_off,
            color: const Color(0xFF306AE7),
          ),
          onPressed: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
        )
            : null,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFF306AE7),
            width: 2,
          ),
        ),
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height - 90);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}