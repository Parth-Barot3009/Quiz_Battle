import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_battle/player/waiting_room.dart';

class JoinBattleScreen extends StatefulWidget {
  const JoinBattleScreen({super.key});

  @override
  State<JoinBattleScreen> createState() => _JoinBattleScreenState();
}

class _JoinBattleScreenState extends State<JoinBattleScreen> {

  final TextEditingController roomCode = TextEditingController();

  static const Color brandBlue = Color(0xFF306AE7);
  static const Color background = Color(0xFFEBF1FF);
  static const Color darkText = Color(0xFF1E293B);
  static const Color greyText = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: background,

      body: Stack(
        children: [

// Decorative circles

          Positioned(
            top: -80,
            left: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: brandBlue.withOpacity(.08),
              ),
            ),
          ),

          Positioned(
            bottom: -80,
            right: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: brandBlue.withOpacity(.05),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
//==========================
// HEADER
//==========================

                  Row(
                    children: [

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: darkText,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),

                      const SizedBox(width: 18),

                      const Text(
                        "Join Battle",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: darkText,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

//==========================
// GAME ICON
//==========================

                  Center(
                    child: Container(
                      width: 150,
                      height: 150,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),

                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF4A7CFF),
                            Color(0xFF306AE7),
                          ],
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: brandBlue.withOpacity(.30),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),

                      child: const Icon(
                        Icons.sports_esports_rounded,
                        size: 75,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Center(
                    child: Text(
                      "Enter the room code given by your organiser",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: darkText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
//==========================
// ROOM CODE TITLE
//==========================

                  const Text(
                    "ROOM CODE",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: brandBlue,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 15),

//==========================
// ROOM CODE TEXTFIELD
//==========================

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.08),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),

                    child: TextField(
                      controller: roomCode,
                      textAlign: TextAlign.center,

                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 6,
                        color: darkText,
                      ),

                      decoration: InputDecoration(
                        hintText: "ENTER ROOM CODE",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 18,
                          letterSpacing: 1,
                        ),

                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 24,
                          horizontal: 20,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

//==========================
// JOIN BUTTON
//==========================

                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () async{

                        QuerySnapshot snapshot = await FirebaseFirestore.instance
                            .collection("Battle_Room_Details")
                            .where("room_code", isEqualTo: roomCode.text.trim())
                            .limit(1)
                            .get();

                        if(snapshot.docs.isNotEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Joining Battle..."),
                            ),
                          );

                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>WaitingRoom(roomcode: roomCode.text.trim(),)));
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Enter Valide Room Code"),
                            ),
                          );
                        }


                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),

                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF4A7CFF),
                              Color(0xFF306AE7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),

                        child: Container(
                          alignment: Alignment.center,

                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Icon(
                                Icons.sports_esports_rounded,
                                color: Colors.white,
                              ),

                              SizedBox(width: 10),

                              Text(
                                "JOIN BATTLE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  //==========================
                  // HOW TO JOIN CARD
                  //==========================

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.08),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Row(
                          children: [

                            Icon(
                              Icons.info_outline_rounded,
                              color: brandBlue,
                              size: 28,
                            ),

                            SizedBox(width: 10),

                            Text(
                              "How to Join",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: darkText,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        _step(
                          number: "1",
                          text: "Ask your organiser for the room code.",
                        ),

                        const SizedBox(height: 18),

                        _step(
                          number: "2",
                          text: "Enter the room code in the text field above.",
                        ),

                        const SizedBox(height: 18),

                        _step(
                          number: "3",
                          text: "Tap JOIN BATTLE to enter the quiz room.",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _step({
    required String number,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: brandBlue,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: darkText,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
// ],
// ),
// ),
// ),
// ],
// ),
// );
// }
// }