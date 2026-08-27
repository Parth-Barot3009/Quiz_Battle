import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quiz_battle/admin/addorganiser.dart';

class Org_List extends StatefulWidget {
  const Org_List({super.key});

  @override
  State<Org_List> createState() => _Org_ListState();
}

class _Org_ListState extends State<Org_List> {
  final search_organizer = TextEditingController();
  String _searchQuery = "";

  // Color Palette
  static const Color brandBlue = Color(0xFF2563EB);
  static const Color bgCanvas = Color(0xFFF4F7FF);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);

  // Accent Colors for Left Edge Bar
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

  // Deletes organizer from Firebase Auth using a Secondary App instance
  Future<void> _deleteOrganizerCompletely({
    required String docId,
    required String email,
    required String password,
  }) async {
    FirebaseApp? tempApp;
    try {
      tempApp = await Firebase.initializeApp(
        name: 'TempDeleteApp_${DateTime.now().millisecondsSinceEpoch}',
        options: Firebase.app().options,
      );

      FirebaseAuth tempAuth = FirebaseAuth.instanceFor(app: tempApp);

      UserCredential userCredential = await tempAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.delete();

      await FirebaseFirestore.instance
          .collection('organizer')
          .doc(docId)
          .delete();

      debugPrint("Successfully deleted organizer from Auth & Firestore.");
    } catch (e) {
      debugPrint("Error during deletion: $e");
      rethrow;
    } finally {
      await tempApp?.delete();
    }
  }

  // Toggle Block/Unblock Status in Firestore
  Future<void> _toggleBlockOrganizer({
    required String docId,
    required bool currentStatus,
  }) async {
    await FirebaseFirestore.instance
        .collection('organizer')
        .doc(docId)
        .update({'is_blocked': !currentStatus});
  }

  void _showSnackBar(String message, {bool isError = false, bool isWarning = false}) {
    if (!mounted) return;
    Color iconColor = brandBlue;
    IconData icon = Icons.check_circle_outline_rounded;

    if (isError) {
      iconColor = const Color(0xFFEF4444);
      icon = Icons.error_outline_rounded;
    } else if (isWarning) {
      iconColor = Colors.orange;
      icon = Icons.warning_amber_rounded;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 4,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 70),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isError
                ? const Color(0xFFFECDD3)
                : (isWarning ? const Color(0xFFFDBA74) : borderColor),
            width: 1,
          ),
        ),
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: textDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
                    Positioned(
                      right: 40,
                      top: -10,
                      child: Icon(
                        Icons.person_outline_rounded,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Organizer",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Manage and view all organizers",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        Material(
                          color: Colors.white,
                          shape: const CircleBorder(),
                          elevation: 6,
                          shadowColor: const Color(0xFF1D4ED8).withAlpha(80),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Addorganiser(),
                                ),
                              );
                            },
                            customBorder: const CircleBorder(),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              child: const Icon(
                                Icons.add,
                                color: Color(0xFF306AE7),
                                size: 28,
                              ),
                            ),
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
                  hintText: "Search Organizer",
                  hintStyle: TextStyle(color: textGrey, fontSize: 13),
                  prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF306AE7), size: 22),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 3. ORGANIZERS STREAM LIST
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('organizer').snapshots(),
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
                    child: Text("No Organizer Found"),
                  );
                }

                final organizerList = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final name = (data['o_name'] ?? '').toString().toLowerCase();
                  final email = (data['o_email'] ?? '').toString().toLowerCase();
                  return name.contains(_searchQuery) || email.contains(_searchQuery);
                }).toList();

                if (organizerList.isEmpty) {
                  return const Center(
                    child: Text("No Organizer Found"),
                  );
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  itemCount: organizerList.length,
                  itemBuilder: (context, index) {
                    final organizer = organizerList[index];
                    final data = organizer.data() as Map<String, dynamic>;

                    final String name = data['o_name'] ?? '';
                    final String email = data['o_email'] ?? '';
                    final String? imageUrl = data['image_url'];
                    final bool isBlocked = data['is_blocked'] ?? false;

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
                            Positioned(
                              left: 0,
                              top: 0,
                              bottom: 0,
                              child: Container(
                                width: 5,
                                color: isBlocked ? const Color(0xFFEF4444) : cardAccentColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  const SizedBox(width: 4),
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
                                            color: isBlocked
                                                ? const Color(0xFFEF4444)
                                                : const Color(0xFF10B981),
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 1.5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                name,
                                                style: const TextStyle(
                                                  color: textDark,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (isBlocked) ...[
                                              const SizedBox(width: 6),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFFEE2E2),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: const Text(
                                                  "Blocked",
                                                  style: TextStyle(
                                                    color: Color(0xFFEF4444),
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
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

                                  // Three-Dot Action Menu
                                  PopupMenuButton<String>(
                                    icon: const Icon(
                                      Icons.more_vert_rounded,
                                      color: textGrey,
                                      size: 22,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 4,
                                    onSelected: (value) async {
                                      if (value == 'block') {
                                        // Confirm Block / Unblock Dialog
                                        bool? confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            title: Text(isBlocked ? "Unblock Organizer" : "Block Organizer"),
                                            content: Text(
                                              isBlocked
                                                  ? "Are you sure you want to unblock $name?"
                                                  : "Are you sure you want to block $name? They won't be able to log in or organize quizzes.",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, false),
                                                child: const Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, true),
                                                style: TextButton.styleFrom(
                                                  foregroundColor: isBlocked
                                                      ? const Color(0xFF10B981)
                                                      : const Color(0xFFF59E0B),
                                                ),
                                                child: Text(isBlocked ? "Unblock" : "Block"),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirm != true) return;

                                        try {
                                          await _toggleBlockOrganizer(
                                            docId: organizer.id,
                                            currentStatus: isBlocked,
                                          );
                                          _showSnackBar(
                                            isBlocked
                                                ? "Organizer unblocked successfully!"
                                                : "Organizer blocked successfully!",
                                          );
                                        } catch (e) {
                                          _showSnackBar("Failed to update status: $e", isError: true);
                                        }
                                      } else if (value == 'delete') {
                                        // Confirm Delete Dialog
                                        bool? confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            title: const Text("Delete Organizer"),
                                            content: Text("Are you sure you want to delete $name permanently?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, false),
                                                child: const Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, true),
                                                style: TextButton.styleFrom(
                                                  foregroundColor: const Color(0xFFEF4444),
                                                ),
                                                child: const Text("Delete"),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirm != true) return;

                                        try {
                                          final String password = data['password'] ?? '';

                                          if (password.isEmpty) {
                                            await FirebaseFirestore.instance
                                                .collection('organizer')
                                                .doc(organizer.id)
                                                .delete();
                                            _showSnackBar(
                                              "Organizer document deleted from Firestore (Password missing).",
                                              isWarning: true,
                                            );
                                            return;
                                          }

                                          await _deleteOrganizerCompletely(
                                            docId: organizer.id,
                                            email: email,
                                            password: password,
                                          );
                                          _showSnackBar("Organizer permanently deleted!");
                                        } catch (e) {
                                          _showSnackBar("Deletion failed: $e", isError: true);
                                        }
                                      }
                                    },
                                    itemBuilder: (BuildContext context) => [
                                      PopupMenuItem<String>(
                                        value: 'block',
                                        child: Row(
                                          children: [
                                            Icon(
                                              isBlocked ? Icons.lock_open_rounded : Icons.block_rounded,
                                              color: isBlocked ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                                              size: 18,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              isBlocked ? "Unblock Organizer" : "Block Organizer",
                                              style: TextStyle(
                                                color: isBlocked ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.delete_outline_rounded,
                                              color: Color(0xFFEF4444),
                                              size: 18,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "Delete Organizer",
                                              style: TextStyle(
                                                color: Color(0xFFEF4444),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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
            stream: FirebaseFirestore.instance.collection('organizer').snapshots(),
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
                        Icons.folder_shared_rounded,
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
                      "You've added $total organizers",
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