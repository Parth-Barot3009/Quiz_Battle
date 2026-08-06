import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz_battle/auth/login_admin_organiser.dart';
import 'package:quiz_battle/organizer/editorganizerprofile.dart';
import 'package:quiz_battle/player/edituserprofile.dart';

class OrganiserProfileInfo extends StatefulWidget {
  const OrganiserProfileInfo({super.key});

  @override
  State<OrganiserProfileInfo> createState() => _OrganiserProfileInfoState();
}

class _OrganiserProfileInfoState extends State<OrganiserProfileInfo> {
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic>? userInfo;
  File? selectedImage;
  bool isUploading = false;

  // Theme Palette
  static const Color brandBlue = Color(0xFF2563EB);
  static const Color headerBlue = Color(0xFF306AE7);
  static const Color bgCanvas = Color(0xFFF4F7FF);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);

  // Cloudinary Config
  static const String cloudName = "bjcbyn5j";
  static const String uploadPreset = "quizx-app";
  static final Uri _uploadUrl = Uri.parse(
    "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
  );

  @override
  void initState() {
    super.initState();
    getOrganizer();
  }

  void getOrganizer() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await getDocumentById(user.uid);
      if (mounted) {
        setState(() {
          userInfo = doc;
        });
      }
    }
  }

  /// Select image from gallery and upload directly
  Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
        isUploading = true;
      });

      try {
        final String uploadedUrl = await uploadImage(selectedImage!);
        await updateOrganizerImage(uploadedUrl);

        // Refresh local memory data
        getOrganizer();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile image updated successfully!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update image: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            isUploading = false;
          });
        }
      }
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

  Future<void> updateOrganizerImage(String imageUrl) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    // Use SetOptions(merge: true) to preserve other organizer fields
    await FirebaseFirestore.instance.collection('organizer').doc(uid).set({
      'image_url': imageUrl,
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getDocumentById(String docId) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('organizer')
          .doc(docId)
          .get();

      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching document: $e");
      return null;
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCanvas,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. TOP GRADIENT HEADER BANNER
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4A7CFF),
                    headerBlue,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Watermark Background Pattern Icons
                      Positioned(
                        left: -20,
                        top: 10,
                        child: Icon(
                          Icons.bubble_chart_rounded,
                          size: 100,
                          color: Colors.white.withAlpha(20),
                        ),
                      ),
                      // Profile Header Content
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Organizer Profile",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Profile Avatar Image Container with Edit Trigger
                          GestureDetector(
                            onTap: isUploading ? null : pickAndUploadImage,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 96,
                                  height: 96,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: surfaceWhite,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(20),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(48.0),
                                      child: _buildAvatarContent(),
                                    ),
                                  ),
                                ),
                                if (isUploading)
                                  Container(
                                    width: 96,
                                    height: 96,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black.withAlpha(100),
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    ),
                                  ),
                                Positioned(
                                  bottom: 2,
                                  right: 2,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: headerBlue,
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
                          const SizedBox(height: 14),

                          // Profile Role Title
                          const Text(
                            "Organizer",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Manage your organizer account",
                            style: TextStyle(
                              color: Colors.white.withAlpha(200),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 2. FORM CONTAINER CARD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: surfaceWhite,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: borderColor, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: textDark.withAlpha(8),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('organizer')
                      .where(
                    'o_email',
                    isEqualTo: FirebaseAuth.instance.currentUser?.email,
                  )
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(color: headerBlue),
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Center(
                          child: Text(
                            "Organizer not found",
                            style: TextStyle(color: textGrey, fontSize: 14),
                          ),
                        ),
                      );
                    }

                    var data = snapshot.data!.docs.first.data();
                    String organizerName = data['o_name'] ?? '';
                    String organizerEmail = data['o_email'] ?? '';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Full Name Field Label
                        const Text(
                          "Full Name *",
                          style: TextStyle(
                            color: textDark,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Full Name Display Container
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: bgCanvas,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderColor, width: 1),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.person_outline_rounded,
                                color: headerBlue,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                data['o_name'] ?? '',
                                style: const TextStyle(
                                  color: textDark,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Email Field Label
                        const Text(
                          "Email *",
                          style: TextStyle(
                            color: textDark,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Email Display Container
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: bgCanvas,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderColor, width: 1),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.email_outlined,
                                color: headerBlue,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                data['o_email'] ?? '',
                                style: const TextStyle(
                                  color: textDark,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),


                        /// Edit Profile Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: () async {

                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditProfileScreenOrganizer(
                                    organizerName: organizerName,
                                    organizerEmail: organizerEmail,
                                  ),
                                ),
                              );

                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            icon: const Icon(Icons.edit),
                            label: const Text(
                              "Edit Profile",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Logout Button
                        Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: headerBlue.withAlpha(77),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              await logout();
                              if (!context.mounted) return;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: headerBlue,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.logout_rounded, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  "Logout",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// Helper widget to decide which avatar image to display
  Widget _buildAvatarContent() {
    // 1. Show newly picked file first if available
    if (selectedImage != null) {
      return Image.file(
        selectedImage!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    // 2. Show registered Cloudinary image from Firestore if available
    final existingUrl = userInfo?["image_url"]?.toString();
    if (existingUrl != null && existingUrl.isNotEmpty) {
      return Image.network(
        existingUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.person,
          size: 44,
          color: textGrey,
        ),
      );
    }

    // 3. Fallback standard placeholder icon
    return Container(
      color: const Color(0xFFEEF2FF),
      child: const Icon(
        Icons.add_a_photo_outlined,
        size: 36,
        color: headerBlue,
      ),
    );
  }
}