import 'package:flutter/material.dart';

class AboutAppSetting extends StatelessWidget {
  const AboutAppSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title:
          Text(
            "About App",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Welcome
              const Text(
                "Welcome to Quiz Battle",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "Quiz Battle is a modern online quiz competition platform developed to make learning interactive, enjoyable, and competitive. The application provides a digital environment where organizers can easily create and manage quiz competitions, while participants can test their knowledge, improve their skills, and compete with others in real time.\n\nThe app is designed with a simple, user-friendly interface that allows users of all ages to navigate easily. Whether it is for schools, colleges, coaching institutes, training centers, or corporate events, Quiz Battle offers a reliable and efficient solution for conducting quizzes online.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 30),

              /// Purpose
              const Text(
                "Purpose",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "The primary goal of Quiz Battle is to encourage learning through healthy competition. By combining education with engaging quiz challenges, the application helps users improve their knowledge, strengthen problem-solving abilities, and build confidence.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                ),
              ),

               SizedBox(height: 30),

              /// Privacy
               Text(
                "Privacy and Security",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

               SizedBox(height: 12),

               Text(
                "Quiz Battle values user privacy and data security. User information is protected, and the application is designed to provide a secure and reliable experience for all participants and organizers.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                ),
              ),

               SizedBox(height: 30),

              /// Technologies
               Text(
                "Technologies Used",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

               SizedBox(height: 12),

               Text(
                "• Flutter\n"
                "• Dart\n"
                "• REST API\n"
                "• Firebase Database\n"
                "• Android Platform",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.8,
                ),
              ),

              const SizedBox(height: 30),

              /// Version
              const Text(
                "Version Information",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "Application Name : Quiz Battle\n"
                "Version : 1.0.0",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.8,
                ),
              ),

              const SizedBox(height: 30),

              /// Developed By
              Text(
                "Developed By",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 12),

              Text(
                "Quiz Battle Team\n\nThank you for choosing Quiz Battle. We are committed to providing an engaging, reliable, and enjoyable quiz experience. Your feedback and suggestions help us improve the application and deliver new features in future updates.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.8,
                ),
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}