import 'package:flutter/material.dart';

class AdminDeshboard extends StatefulWidget {
  const AdminDeshboard({super.key});

  @override
  State<AdminDeshboard> createState() => _AdminDeshboardState();
}

class _AdminDeshboardState extends State<AdminDeshboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Deshboard"),
      ),
    );
  }
}
