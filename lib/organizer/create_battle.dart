import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart' as excel;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_battle/organizer/battle_room_org.dart';

/// Reads a cell defensively — rows in a real workbook are often shorter than
/// the header, and indexing past the end used to throw a RangeError.
String _cellAt(List<excel.Data?> row, int index) {
  if (index >= row.length) return "";
  return row[index]?.value?.toString().trim() ?? "";
}

/// Parses a questions workbook into question maps, without touching the
/// network. Rows are returned in workbook order across every sheet.
List<Map<String, dynamic>> parseQuestionRows(List<int> bytes) {
  final excelFile = excel.Excel.decodeBytes(bytes);
  final List<Map<String, dynamic>> parsed = [];

  for (final sheetName in excelFile.tables.keys) {
    final table = excelFile.tables[sheetName];
    if (table == null) continue;

    // Row 0 is the header.
    for (int row = 1; row < table.rows.length; row++) {
      final currentRow = table.rows[row];
      if (currentRow.isEmpty) continue;

      final question = _cellAt(currentRow, 0);
      // Skip blank padding rows that trail most spreadsheets.
      if (question.isEmpty) continue;

      parsed.add({
        "question": question,
        "optionA": _cellAt(currentRow, 1),
        "optionB": _cellAt(currentRow, 2),
        "optionC": _cellAt(currentRow, 3),
        "optionD": _cellAt(currentRow, 4),
        "correctAnswer": _cellAt(currentRow, 5),
      });
    }
  }

  return parsed;
}

class CreateBattle extends StatefulWidget {
  const CreateBattle({super.key});

  @override
  State<CreateBattle> createState() => _CreateBattleState();
}

class _CreateBattleState extends State<CreateBattle> {
  final formKey = GlobalKey<FormState>();
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? selectedFileName;
  Uint8List? selectedBytes;
  DateTime? selectedDate;
  int totalQuestions = 0;
  bool isLoading = false;
  final TextEditingController roomname = TextEditingController();
  late String roomCode;

  @override
  void initState() {
    super.initState();
    roomCode = generateRoomCode();
  }

  @override
  void dispose() {
    roomname.dispose();
    super.dispose();
  }

  /// Helper to reset all form fields back to default state
  void _resetFormFields() {
    roomname.clear();
    totalQuestions = 0;
    startTime = null;
    endTime = null;
    selectedDate = null;
    selectedFileName = null;
    selectedBytes = null;
    roomCode = generateRoomCode();
  }

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

    var response = await request.send();
    String body = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(body);
      return data["secure_url"];
    }

    throw Exception("Failed to upload file to Cloudinary");
  }

  Future<void> uploadQuestionsToFirestore(String roomCode) async {
    final bytes = selectedBytes;
    if (bytes == null) {
      throw Exception("Please select Excel file");
    }

    final rows = parseQuestionRows(bytes);
    if (rows.isEmpty) {
      throw Exception("No questions found in the uploaded file");
    }

    final questionsRef = FirebaseFirestore.instance
        .collection("Battle_Room_Details")
        .doc(roomCode)
        .collection("Questions");

    // One batch instead of a round trip per row. `index` is global across
    // sheets so a multi-sheet workbook no longer overwrites its own questions.
    final batch = FirebaseFirestore.instance.batch();

    for (int index = 0; index < rows.length; index++) {
      batch.set(questionsRef.doc("question_${index + 1}"), {
        ...rows[index],
        "questionIndex": index,
        "createdAt": FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
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
          continue;
        }
        rows.add(
          row.map((e) => e?.value?.toString() ?? "").toList(),
        );
      }
    }

    if (rows.isEmpty) {
      _showErrorSnackBar("The sample file could not be read.");
      return;
    }

    // DataTable asserts if any row's cell count differs from the header's, and
    // trailing empty cells are routinely trimmed by spreadsheet editors.
    final int columnCount = rows.first.length;
    rows = rows
        .map((row) => List<String>.generate(
              columnCount,
              (i) => i < row.length ? row[i] : "",
            ))
        .toList();

    if (!mounted) return;

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

  /// Generates a room code that no existing battle is already using.
  ///
  /// The document is keyed by the code, so a collision would silently
  /// overwrite another organizer's battle and its questions.
  Future<String> generateUniqueRoomCode() async {
    for (int attempt = 0; attempt < 10; attempt++) {
      final candidate = generateRoomCode();
      final existing = await FirebaseFirestore.instance
          .collection("Battle_Room_Details")
          .doc(candidate)
          .get();

      if (!existing.exists) return candidate;
    }
    throw Exception("Could not allocate a free room code. Please try again.");
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
    // Claim a free code before writing, so one battle can't clobber another.
    roomCode = await generateUniqueRoomCode();

    String? excelUrl = await uploadExcelToCloudinary();

    DateTime fullStartDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      startTime!.hour,
      startTime!.minute,
    );

    DateTime fullEndDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      endTime!.hour,
      endTime!.minute,
    );

    // A battle scheduled to end "before" it starts is one that runs past
    // midnight, so roll the end date forward a day.
    if (!fullEndDateTime.isAfter(fullStartDateTime)) {
      fullEndDateTime = fullEndDateTime.add(const Duration(days: 1));
    }

    await FirebaseFirestore.instance
        .collection("Battle_Room_Details")
        .doc(roomCode)
        .set({
      "room_name": roomname.text.trim(),
      "room_code": roomCode,
      "questions": totalQuestions,
      "start_time": Timestamp.fromDate(fullStartDateTime),
      "end_time": Timestamp.fromDate(fullEndDateTime),
      "status": "waiting",
      "battle_date": selectedDate,
      "question_file": excelUrl,
      "created_at": FieldValue.serverTimestamp(),
      "o_email": FirebaseAuth.instance.currentUser?.email,
      "leaderboardGenerated": false,
      "winner_name": null
    });
  }

  // Custom Error SnackBar Display
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 4,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 85),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFFECDD3), width: 1),
        ),
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFEF4444),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Color(0xFF1E293B),
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

  // Form Validation Check Logic
  bool _validateForm() {
    if (roomname.text.trim().isEmpty) {
      _showErrorSnackBar("Please enter room name");
      return false;
    }
    if (totalQuestions <= 0) {
      _showErrorSnackBar("Please add questions for battle");
      return false;
    }
    if (startTime == null) {
      _showErrorSnackBar("Please select start time");
      return false;
    }
    if (endTime == null) {
      _showErrorSnackBar("Please select end time");
      return false;
    }
    if (selectedDate == null) {
      _showErrorSnackBar("Please select quiz date");
      return false;
    }

    DateTime start = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      startTime!.hour,
      startTime!.minute,
    );

    DateTime end = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      endTime!.hour,
      endTime!.minute,
    );

    // An end time earlier in the day than the start means the battle runs past
    // midnight, which is allowed. Identical times are not.
    if (end.isAtSameMomentAs(start)) {
      _showErrorSnackBar("End time must be different from start time");
      return false;
    }

    if (selectedBytes == null) {
      _showErrorSnackBar("Please upload question Excel file");
      return false;
    }

    // The question count is a manual stepper, so it can easily exceed what the
    // workbook actually contains. Players used to crash mid-battle when it did.
    final int available = _availableQuestionCount();
    if (available == 0) {
      _showErrorSnackBar(
        "No questions found in the file. Check it against the sample.",
      );
      return false;
    }
    if (totalQuestions > available) {
      _showErrorSnackBar(
        "The file only has $available question${available == 1 ? "" : "s"}. "
        "Lower the question count.",
      );
      return false;
    }

    return true;
  }

  /// Number of usable question rows in the selected workbook.
  int _availableQuestionCount() {
    final bytes = selectedBytes;
    if (bytes == null) return 0;
    try {
      return parseQuestionRows(bytes).length;
    } catch (e) {
      debugPrint("Could not parse the selected workbook: $e");
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF6F8FD),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18.0, 12.0, 18.0, 100.0),
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

                // 2. ROOM NAME CARD
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
                            TextFormField(
                              controller: roomname,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Please enter room name";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: "Enter Room Name",
                                hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                                border: InputBorder.none,
                                errorStyle: TextStyle(fontSize: 10, height: 0.8),
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

                // 3. QUESTIONS FOR BATTLE CARD
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

                // 4. START TIME CARD
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

                // 5. END TIME CARD
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

                // 6. QUIZ DATE CARD
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

                // 7. QUESTION FILE CARD
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

                // 8. CREATE BATTLE BUTTON
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
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                      if (!_validateForm()) return;

                      setState(() {
                        isLoading = true;
                      });

                      try {
                        await addCreateRoomDetails();
                        await uploadQuestionsToFirestore(roomCode);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              elevation: 4,
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 50),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: const BorderSide(
                                    color: Color(0xFFE2E8F0), width: 1),
                              ),
                              content: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF3B82F6)
                                          .withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check_circle_outline_rounded,
                                      color: Color(0xFF3B82F6),
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Text(
                                      "Battle Room Created Successfully!",
                                      style: TextStyle(
                                        color: Color(0xFF1E293B),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );

                          final String currentRoomCode = roomCode;
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrgBattleRoom(
                                roomCode: currentRoomCode,
                              ),
                            ),
                          );

                          if (mounted) {
                            setState(() {
                              _resetFormFields();
                            });
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          _showErrorSnackBar(
                              e.toString().replaceAll("Exception: ", ""));
                        }
                      } finally {
                        if (mounted) {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.sports_esports_rounded,
                            color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "Create Battle",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
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