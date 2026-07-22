import 'package:flutter/material.dart';
import 'package:quiz_battle/admin/addmin_setting.dart';
import 'package:quiz_battle/auth/Splash_Screen.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context) => SplashScreen()));
          },
        ),
        title: const Text(
          "Privacy Policy",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        toolbarHeight: 80,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Quiz Battle Privacy Policy",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "At Quiz Battle, we value your privacy and are committed to protecting your personal information. This Privacy Policy explains how we collect, use, and safeguard your data while you use our application.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Information We Collect",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "• Name and email address during registration.\n"
              "• Login credentials for secure authentication.\n"
              "• Quiz scores and participation history.\n"
              "• Basic device information to improve application performance.",
              style: TextStyle(
                fontSize: 16,
                height: 1.8,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "How We Use Your Information",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Your information is used to create and manage your account, allow you to participate in quiz competitions, display quiz results, improve the application, and provide customer support whenever required.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Data Security",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "We implement appropriate security measures to protect your personal information from unauthorized access, misuse, or disclosure. Your data is stored securely and is accessible only to authorized personnel.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Information Sharing",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Quiz Battle does not sell, rent, or share your personal information with third parties except when required by law or when necessary to provide essential application services.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "User Responsibilities",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Users are responsible for maintaining the confidentiality of their login credentials. Please do not share your password with anyone.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Your Rights",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "You may update your profile information at any time. You may also request deletion of your account and associated data through the application's account management features.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Changes to This Policy",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "This Privacy Policy may be updated periodically to reflect improvements or legal requirements. Users are encouraged to review this page regularly for any updates.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Contact Us",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "If you have any questions regarding this Privacy Policy, please contact the Quiz Battle Team.\n\n"
              "Email: support@quizbattle.com\n"
              "Version: 1.0.0\n\n"
              "Last Updated: July 2026",
              style: TextStyle(
                fontSize: 16,
                height: 1.8,
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}