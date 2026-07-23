import 'package:flutter/material.dart';

class GeneralSettingScreen extends StatefulWidget {
  GeneralSettingScreen({super.key});

  @override
  State<GeneralSettingScreen> createState() =>
      _GeneralSettingScreenState();
}

class _GeneralSettingScreenState
    extends State<GeneralSettingScreen> {
  bool notification = true;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "General Settings",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        toolbarHeight: 80,
        iconTheme: IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Icon(
                    Icons.notifications,
                    color: Colors.blue,
                  ),
                  title: Text(
                    "Notifications",
                    style: TextStyle(
                        fontWeight: FontWeight.bold),
                  ),
                  value: notification,
                  onChanged: (value) {
                    setState(() {
                      notification = value;
                    });
                  },
                ),

                Divider(),

                SwitchListTile(
                  secondary: Icon(
                    Icons.dark_mode,
                    color: Colors.blue,
                  ),
                  title: Text(
                    "Dark Mode",
                    style: TextStyle(
                        fontWeight: FontWeight.bold),
                  ),
                  value: darkMode,
                  onChanged: (value) {
                    setState(() {
                      darkMode = value;
                    });
                  },
                ),

                Divider(),

                ListTile(
                  leading: Icon(
                    Icons.cleaning_services,
                    color: Colors.blue,
                  ),
                  title: Text(
                    "Clear Cache",
                    style: TextStyle(
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Cache cleared successfully."),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),

                Divider(),

                ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                  ),
                  title: Text(
                    "App Version",
                    style: TextStyle(
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    "1.0.0",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}