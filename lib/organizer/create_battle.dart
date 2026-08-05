import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart' as excel;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_battle/organizer/Battle_Room_Org.dart';

class create_battle extends StatefulWidget {
  const create_battle({super.key});

  @override
  State<create_battle> createState() => _create_battleState();
}

class _create_battleState extends State<create_battle> {
  final formKey = GlobalKey<FormState>();
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? selectedFileName;
  Uint8List? selectedBytes;
  DateTime? selectedDate;
  int totalQuestions = 0;
  final TextEditingController roomname = TextEditingController();
  late String roomCode;

  // Time Picker Logic
  Future<void> pickTime(bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? (startTime ?? TimeOfDay.now())
          : (endTime ?? TimeOfDay.now()),
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  // File Picker Logic
  Future<void> pickExcelFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
      withData: true,
    );

    if (result != null) {
      setState(() {
        selectedFileName = result.files.single.name;
        selectedBytes = result.files.single.bytes;
      });
    }
  }

  // Cloudinary Upload Logic
  Future<String?> uploadExcelToCloudinary() async {
    if (selectedBytes == null) {
      throw Exception("Please select Excel file");
    }

    var uri = Uri.parse("https://api.cloudinary.com/v1_1/mios4bnz/raw/upload");
    var request = http.MultipartRequest("POST", uri);
    request.fields["upload_preset"] = "quiz_excel";
    request.files.add(
      http.MultipartFile.fromBytes(
        "file",
        selectedBytes!,
        filename: selectedFileName ?? "questions.xlsx",
      ),
    );

    print("Uploading Excel...");
    var response = await request.send();
    String body = await response.stream.bytesToString();

    print(response.statusCode);
    print(body);

    if (response.statusCode == 200) {
      final data = jsonDecode(body);
      return data["secure_url"];
    }

    throw Exception(body);
  }

  Future<void> uploadQuestionsToFirestore(String roomCode) async {
    try {
      DocumentSnapshot battleDoc =
      await FirebaseFirestore.instance
          .collection("Battle_Room_Details")
          .doc(roomCode)
          .get();

      String excelUrl = battleDoc["question_file"];

      final response = await http.get(Uri.parse(excelUrl));

      if (response.statusCode != 200) {
        throw Exception("Excel download failed");
      }

      var excelFile = excel.Excel.decodeBytes(response.bodyBytes);

      int index = 0;

      for (var sheet in excelFile.tables.keys) {
        var table = excelFile.tables[sheet];

        if (table == null) continue;

        int que_id = 1;
        // Skip header row
        for (int row = 1; row < table.rows.length; row++) {
          var currentRow = table.rows[row];

          if (currentRow.isEmpty) continue;

          await FirebaseFirestore.instance
              .collection("Battle_Room_Details")
              .doc(roomCode)
              .collection("Questions").doc("Question :${que_id}")
              .set({
            "question":
            currentRow[0]?.value.toString() ?? "",

            "optionA":
            currentRow[1]?.value.toString() ?? "",

            "optionB":
            currentRow[2]?.value.toString() ?? "",

            "optionC":
            currentRow[3]?.value.toString() ?? "",

            "optionD":
            currentRow[4]?.value.toString() ?? "",

            "correctAnswer":
            currentRow[5]?.value.toString() ?? "",

            "questionIndex": index,

            "createdAt":
            FieldValue.serverTimestamp(),
          });

          index++;
          que_id++;
        }
      }

      print("Questions Uploaded Successfully");
    } catch (e) {
      print("Error: $e");
    }
  }

  // Sample Excel View Logic
  Future<void> showSampleExcel() async {
    final data = await rootBundle.load(
      "assets/sample/sample_file.xlsx",
    );

    final bytes = data.buffer.asUint8List();
    final excelFile = excel.Excel.decodeBytes(bytes);

    List<List<String>> rows = [];



    for (var sheet in excelFile.tables.keys) {
      int rowIndex = 0;
      for (var row in excelFile.tables[sheet]!.rows) {
        if (rowIndex == 1) {
          rowIndex++;
          continue; // Skip 2nd row
        }
        rows.add(
          row.map((e) => e?.value.toString() ?? "").toList(),
        );
      }
    }

    // Show sample file dialog with a Close button
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Sample Excel",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded, color: Color(0xFF94A3B8)),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: rows.first
                  .map(
                    (e) => DataColumn(
                  label: Text(
                    e,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )
                  .toList(),
              rows: rows
                  .skip(1)
                  .map(
                    (row) => DataRow(
                  cells: row
                      .map(
                        (e) => DataCell(Text(e)),
                  )
                      .toList(),
                ),
              )
                  .toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF3B82F6),
            ),
            child: const Text(
              "Close",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Date Picker Logic
  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Room Code Generator Logic
  String generateRoomCode() {
    const characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    final random = Random();
    String code = "";
    for (int i = 0; i < 6; i++) {
      code += characters[random.nextInt(characters.length)];
    }
    return code;
  }

  // Firestore Addition Logic
  Future<void> addCreateRoomDetails() async {
    try {
      print("Uploading Excel...");
      String? excelUrl = await uploadExcelToCloudinary();

      // Combine selectedDate and startTime into a full DateTime
      DateTime fullStartDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        startTime!.hour,
        startTime!.minute,
      );

      // Combine selectedDate and endTime into a full DateTime
      DateTime fullEndDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        endTime!.hour,
        endTime!.minute,
      );

      await FirebaseFirestore.instance
          .collection("Battle_Room_Details")
          .doc(roomCode)
          .set({
        "room_name": roomname.text.trim(),
        "room_code": roomCode,
        "questions": totalQuestions,
        "start_time": Timestamp.fromDate(fullStartDateTime),
        "end_time": Timestamp.fromDate(fullEndDateTime),
        "status": "waiting", // Initial lobby status: "waiting", "live", "ended"
        "battle_date": selectedDate,
        "question_file": excelUrl,
        "created_at": FieldValue.serverTimestamp(),
        "o_email": FirebaseAuth.instance.currentUser?.email,
        "leaderboardGenerated": false,
        "winner_name":null
      });

      print("Firestore Saved");
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    roomCode = generateRoomCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. TOP HEADER SECTION
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        // Back Button Box
                        InkWell(
                          onTap: () => Navigator.maybePop(context),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0A000000),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 18,
                              color: Color(0xFF3B82F6),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Title & Subtitle
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Create Battle Room",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Setup your quiz battle",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Header Badge/Icon
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.sports_esports_rounded,
                        size: 28,
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 2. ROOM NAME CARD (INLINE)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x05000000),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          size: 20,
                          color: Color(0xFF3B82F6),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Room Name",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 3),
                            TextField(
                              controller: roomname,
                              decoration: const InputDecoration(
                                hintText: "Enter Room Name",
                                hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // 3. QUESTIONS FOR BATTLE CARD (INLINE)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x05000000),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.help_outline_rounded,
                          size: 20,
                          color: Color(0xFF3B82F6),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Questions for Battle",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              "Questions",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              if (totalQuestions > 1) {
                                setState(() => totalQuestions--);
                              }
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.remove,
                                size: 16,
                                color: Color(0xFF3B82F6),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              "$totalQuestions",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3B82F6),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (totalQuestions < 50) {
                                setState(() => totalQuestions++);
                              }
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 16,
                                color: Color(0xFF3B82F6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // 4. START TIME CARD (INLINE)
                InkWell(
                  onTap: () => pickTime(true),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x05000000),
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.access_time_rounded,
                            size: 20,
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Start Time",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                "Select Start Time",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: startTime != null ? const Color(0xFF1E293B) : const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              startTime == null ? "--:--" : startTime!.format(context),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF3B82F6),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.access_time_rounded, color: Color(0xFF3B82F6), size: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // 5. END TIME CARD (INLINE)
                InkWell(
                  onTap: () => pickTime(false),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x05000000),
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.access_time_rounded,
                            size: 20,
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "End Time",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                "Select End Time",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: endTime != null ? const Color(0xFF1E293B) : const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              endTime == null ? "--:--" : endTime!.format(context),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF3B82F6),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.access_time_rounded, color: Color(0xFF3B82F6), size: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // 6. QUIZ DATE CARD (INLINE)
                InkWell(
                  onTap: pickDate,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x05000000),
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.calendar_today_rounded,
                            size: 20,
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Quiz Date",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                "Select Date",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: selectedDate != null ? const Color(0xFF1E293B) : const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              selectedDate == null
                                  ? "--/--/---"
                                  : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF3B82F6),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.calendar_month_rounded, color: Color(0xFF3B82F6), size: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // 7. QUESTION FILE CARD (INLINE)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x05000000),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.note_add_outlined,
                          size: 20,
                          color: Color(0xFF3B82F6),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Question File",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              selectedFileName ?? "Upload Excel File",
                              style: TextStyle(
                                fontSize: 14,
                                color: selectedFileName != null ? const Color(0xFF1E293B) : const Color(0xFF94A3B8),
                                fontWeight: selectedFileName != null ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: pickExcelFile,
                        child: const Icon(Icons.folder_open_rounded, color: Color(0xFF3B82F6)),
                      ),
                    ],
                  ),
                ),

                // "View Sample File" Link
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, right: 4.0, bottom: 4.0),
                    child: GestureDetector(
                      onTap: showSampleExcel,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.visibility_outlined, size: 16, color: Color(0xFF3B82F6)),
                          SizedBox(width: 4),
                          Text(
                            "View Sample File",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF3B82F6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 8. CREATE BATTLE BUTTON (INLINE)
                Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF3B82F6),
                        Color(0xFF2563EB),
                      ],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3D3B82F6),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (selectedDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please select date")),
                        );
                        return;
                      }
                      await addCreateRoomDetails();
                      await uploadQuestionsToFirestore(roomCode);
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Org_BattleRoom(roomCode: roomCode),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.sports_esports_rounded, color: Colors.white),
                    label: const Text(
                      "Create Battle",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}