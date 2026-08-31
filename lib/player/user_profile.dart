import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz_battle/auth/login_admin_organiser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileInfo extends StatefulWidget {
  const UserProfileInfo({super.key});

  @override
  State<UserProfileInfo> createState() => _UserProfileInfoState();
}

class _UserProfileInfoState extends State<UserProfileInfo> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  Map<String, dynamic>? userInfo;
  File? selectedImage;
  bool isUploading = false;
  bool isEditingName = false;
  bool isSavingName = false;

  // Theme Palette
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
    getUser();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Modern Floating Custom SnackBar Helper
  void _showCustomSnackBar({
    required String title,
    required String message,
    required bool isSuccess,
  }) {
    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();

    final Color accentColor = isSuccess ? const Color(0xFF10B981) : const Color(0xFFEF4444);

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
        duration: const Duration(milliseconds: 3000),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        padding: EdgeInsets.zero,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: surfaceWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: textDark.withAlpha(20),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSuccess ? Icons.check_circle_rounded : Icons.error_rounded,
                  color: accentColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: textDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      message,
                      style: const TextStyle(
                        color: textGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.close_rounded, size: 18, color: textGrey),
                onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getUser() async {
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

  Future<void> updatePlayerName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final newName = _nameController.text.trim();

    if (uid == null) return;

    if (newName.isEmpty) {
      _showCustomSnackBar(
        title: "Invalid Input",
        message: "Full Name cannot be empty.",
        isSuccess: false,
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      isSavingName = true;
    });

    try {
      await FirebaseFirestore.instance.collection('player').doc(uid).set({
        'player_name': newName,
      }, SetOptions(merge: true));

      if (mounted) {
        setState(() {
          isEditingName = false;
        });

        _showCustomSnackBar(
          title: "Profile Updated",
          message: "Your name has been updated successfully!",
          isSuccess: true,
        );
      }
    } catch (e) {
      if (mounted) {
        _showCustomSnackBar(
          title: "Update Failed",
          message: "Error updating name: $e",
          isSuccess: false,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSavingName = false;
        });
      }
    }
  }

  /// Pick an image from gallery and upload it automatically
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
        await addPlayerImage(uploadedUrl);

        // Refresh local user state after upload
        getUser();

        if (mounted) {
          _showCustomSnackBar(
            title: "Photo Updated",
            message: "Profile image changed successfully!",
            isSuccess: true,
          );
        }
      } catch (e) {
        if (mounted) {
          _showCustomSnackBar(
            title: "Upload Failed",
            message: "Could not upload image: $e",
            isSuccess: false,
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

  Future<void> addPlayerImage(String imageUrl) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance.collection('player').doc(uid).set({
      'image_url': imageUrl,
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getDocumentById(String docId) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('player')
          .doc(docId)
          .get();

      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint("Error fetching document: $e");
    }
    return null;
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('role');
    await FirebaseAuth.instance.signOut();
  }

  // Logout Confirmation Dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: surfaceWhite,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Color(0xFFEF4444),
                    size: 32,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  "Logout",
                  style: TextStyle(
                    color: textDark,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Are you sure you want to log out of your account?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textGrey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: borderColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: textGrey,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(dialogContext).pop();
                          await logout();
                          if (!context.mounted) return;
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                                (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Player Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Profile Avatar Container
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
                        "Player",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                      ),

                      const SizedBox(height: 4),
                      Text(
                        "Manage your player account",
                        style: TextStyle(
                          color: Colors.white.withAlpha(200),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 2. FORM CONTAINER CARD WITH FIRESTORE STREAM BY UID
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
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: currentUid != null
                      ? FirebaseFirestore.instance
                      .collection('player')
                      .doc(currentUid)
                      .snapshots()
                      : null,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(color: headerBlue),
                        ),
                      );
                    }

                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Center(
                          child: Text(
                            "Player profile not found",
                            style: TextStyle(color: textGrey, fontSize: 14),
                          ),
                        ),
                      );
                    }

                    var data = snapshot.data!.data() ?? {};
                    String playerName = data['player_name'] ?? '';
                    String playerEmail = data['player_email'] ?? '';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Full Name *",
                          style: TextStyle(
                            color: textDark,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Editable Full Name Container
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: isEditingName ? 4 : 14,
                          ),
                          decoration: BoxDecoration(
                            color: bgCanvas,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isEditingName ? headerBlue : borderColor,
                              width: isEditingName ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.person_outline_rounded,
                                color: headerBlue,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: isEditingName
                                    ? TextField(
                                  controller: _nameController,
                                  autofocus: true,
                                  style: const TextStyle(
                                    color: textDark,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                  ),
                                )
                                    : Text(
                                  playerName,
                                  style: const TextStyle(
                                    color: textDark,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              IconButton(
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  isEditingName
                                      ? Icons.close_rounded
                                      : Icons.edit_outlined,
                                  color: headerBlue,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (!isEditingName) {
                                      _nameController.text = playerName;
                                    }
                                    isEditingName = !isEditingName;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Email *",
                          style: TextStyle(
                            color: textDark,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

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
                              Expanded(
                                child: Text(
                                  playerEmail,
                                  style: const TextStyle(
                                    color: textDark,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Conditional: Shows Save Button when editing, otherwise shows Logout Button
                        if (isEditingName)
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton.icon(
                              onPressed: isSavingName ? null : updatePlayerName,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF10B981),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              icon: isSavingName
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                                  : const Icon(Icons.check_circle_outline),
                              label: Text(
                                isSavingName ? "Saving..." : "Save Profile",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        else
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
                              onPressed: () => _showLogoutDialog(context),
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

  Widget _buildAvatarContent() {
    if (selectedImage != null) {
      return Image.file(
        selectedImage!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

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