import 'package:flutter/material.dart';

class u_dashboard extends StatelessWidget {
  const u_dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StudentDashboard(),
    );
  }
}

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FF),

      appBar: AppBar(
        backgroundColor: Color(0xFF306AE7),
        elevation: 0,
        toolbarHeight: 80,
        title: const Text(
          "Student Dashboard",

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

              const Text(
                "Hello,",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "STUDENT",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              /// PROFILE CARD
              Container(
                width: double.infinity,
                height: 170,

                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF4A7CFF),
                          Color(0xFF306AE7),
                        ]
                    ),
                  borderRadius: BorderRadius.circular(25),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Row(
                    children: [

                      const CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,

                        child: Icon(
                          Icons.person,
                          color: Colors.blue,
                          size: 40,
                        ),
                      ),

                      const SizedBox(width: 20),

                      const Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [

                            Text(
                              "John Smith",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 8),

                            Text(
                              "Rank #25",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 5),

                            Text(
                              "1250 XP",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(
                        Icons.emoji_events,
                        color: Colors.white54,
                        size: 70,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Row(
                children: [

                  Expanded(
                    child: Container(
                      height: 120,

                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF4A7CFF),
                                Color(0xFF306AE7),
                              ]
                          ),
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [

                          Icon(
                            Icons.flash_on,
                            color: Colors.white,
                            size: 45,
                          ),

                          SizedBox(height: 10),

                          Text(
                            "Quick Battle",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Container(
                      height: 120,

                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF4A7CFF),
                                Color(0xFF306AE7),
                              ]
                          ),
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [

                          Icon(
                            Icons.group,
                            color: Colors.white,
                            size: 45,
                          ),

                          SizedBox(height: 10),

                          Text(
                            "Join Battle",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 25),


              /// STATISTICS
              Row(
                children: [

                  Expanded(
                    child: statCard(
                      Icons.sports_esports,
                      "25",
                      "Battles",
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: statCard(
                      Icons.emoji_events,
                      "18",
                      "Wins",
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: statCard(
                      Icons.trending_up,
                      "72%",
                      "Win Rate",
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "Upcoming Battles",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              battleCard(
                "Flutter Quiz Battle",
                "10 Questions",
                "Today • 6:00 PM",
              ),

              const SizedBox(height: 15),

              battleCard(
                "Java Challenge",
                "15 Questions",
                "Tomorrow • 4:30 PM",
              ),

              const SizedBox(height: 15),

              battleCard(
                "Database Battle",
                "20 Questions",
                "Friday • 7:00 PM",
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget statCard(
      IconData icon,
      String number,
      String title,
      ) {
    return Container(
      height: 110,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
          ),
        ],
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Icon(
            icon,
            color: Color(0xFF4A7CFF),
            size: 32,
          ),

          const SizedBox(height: 8),

          Text(
            number,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(title),

        ],
      ),
    );
  }

  Widget battleCard(
      String title,
      String questions,
      String time,
      ) {
    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
          ),
        ],
      ),

      child: Row(
        children: [

          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: Color(0xFF4A7CFF),
              borderRadius: BorderRadius.circular(15),
            ),

            child: const Icon(
              Icons.sports_esports,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(questions),

                Text(
                  time,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

              ],
            ),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),

            onPressed: () {},

            child: const Text(
              "JOIN",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),

        ],
      ),
    );
  }
}