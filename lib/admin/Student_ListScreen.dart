import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Stu_List extends StatefulWidget {
  const Stu_List({super.key});

  @override
  State<Stu_List> createState() => _Stu_ListState();
}

class _Stu_ListState extends State<Stu_List> {
  final search_organizer = TextEditingController();
  String _searchQuery = "";

  // Color System
  static const Color brandBlue = Color(0xFF2563EB);
  static const Color bgCanvas = Color(0xFFF4F7FF);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);

  // Soft Accent Colors for Card Front Edges
  static const List<Color> accentColors = [
    Color(0xFF2563EB), // Royal Blue
    Color(0xFF8B5CF6), // Purple
    Color(0xFF10B981), // Emerald Green
    Color(0xFFF59E0B), // Amber / Gold
  ];

  @override
  void dispose() {
    search_organizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCanvas,
      body: Column(
        children: [
          // 1. TOP HEADER BANNER
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4A7CFF),
                  Color(0xFF306AE7),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Background Watermark Icons
                    Positioned(
                      right: 40,
                      top: -10,
                      child: Icon(
                        Icons.school_outlined,
                        size: 90,
                        color: Colors.white.withAlpha(25),
                      ),
                    ),
                    Positioned(
                      right: -10,
                      bottom: -20,
                      child: Icon(
                        Icons.star_outline_rounded,
                        size: 70,
                        color: Colors.white.withAlpha(20),
                      ),
                    ),

                    // Header Text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Players",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "View registered players",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 2. SEARCH BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: surfaceWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: textDark.withAlpha(8),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: search_organizer,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase().trim();
                  });
                },
                style: const TextStyle(color: textDark, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: "Search Player",
                  hintStyle: TextStyle(color: textGrey, fontSize: 13),
                  prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF306AE7), size: 22),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 3. STUDENTS FIRESTORE STREAM LIST ('player' collection)
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('player').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: brandBlue),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Something went wrong"),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No Player Found"),
                  );
                }

                // Filtering based on search query
                final playerList = snapshot.data!.docs.where((doc) {
                  final data = doc.data();
                  final name = (data['player_name'] ?? '').toString().toLowerCase();
                  final email = (data['player_email'] ?? '').toString().toLowerCase();
                  return name.contains(_searchQuery) || email.contains(_searchQuery);
                }).toList();

                if (playerList.isEmpty) {
                  return const Center(
                    child: Text("No Player Found"),
                  );
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  itemCount: playerList.length,
                  itemBuilder: (context, index) {
                    final player = playerList[index];
                    final data = player.data() as Map<String, dynamic>;

                    final String name = data['player_name'] ?? '';
                    final String email = data['player_email'] ?? '';
                    final String? imageUrl = data['image_url'];

                    final Color cardAccentColor = accentColors[index % accentColors.length];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: surfaceWhite,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: borderColor, width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: textDark.withAlpha(6),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            // Front Accent Color Bar
                            Positioned(
                              left: 0,
                              top: 0,
                              bottom: 0,
                              child: Container(
                                width: 5,
                                color: cardAccentColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  const SizedBox(width: 4),

                                  // Profile Avatar
                                  Stack(
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: cardAccentColor.withAlpha(30),
                                          image: imageUrl != null && imageUrl.isNotEmpty
                                              ? DecorationImage(
                                            image: NetworkImage(imageUrl),
                                            fit: BoxFit.cover,
                                          )
                                              : null,
                                        ),
                                        child: imageUrl == null || imageUrl.isEmpty
                                            ? Icon(
                                          Icons.person_rounded,
                                          color: cardAccentColor,
                                          size: 26,
                                        )
                                            : null,
                                      ),
                                      Positioned(
                                        right: 2,
                                        bottom: 2,
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF10B981),
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 1.5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 14),

                                  // Name & Email
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: const TextStyle(
                                            color: textDark,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          email,
                                          style: const TextStyle(
                                            color: textGrey,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // 4. BOTTOM FOOTER COUNTER BADGE
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('player').snapshots(),
            builder: (context, snapshot) {
              final total = snapshot.hasData ? snapshot.data!.docs.length : 0;
              return Container(
                padding: const EdgeInsets.only(bottom: 16, top: 4),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: surfaceWhite,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: brandBlue.withAlpha(20),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        color: Color(0xFF306AE7),
                        size: 26,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "All Set!",
                      style: TextStyle(
                        color: Color(0xFF306AE7),
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "You have $total registered Player",
                      style: const TextStyle(
                        color: textGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}