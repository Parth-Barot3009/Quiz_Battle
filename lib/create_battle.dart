import 'package:flutter/material.dart';
// import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class create_battle extends StatefulWidget {
  const create_battle({super.key});

  @override
  State<create_battle> createState() => _create_battleState();
}

class _create_battleState extends State<create_battle> {

  TimeOfDay? startTime;
  TimeOfDay? endTime;

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

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(

      appBar: AppBar(
        toolbarHeight: 100,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0,0.45],
              colors: [
                Color(0xFF4A7CFF),
                Color(0xFF306AE7),
              ],
            ),
          ),
        ),
        title: Text("Create Battle Room",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontFamily: "BaiJamjuree",),),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back),iconSize: 25,color: Color(0xFF4A7CFF),)
          ),
        ),
      ),

      body: SingleChildScrollView(

        //main container
        child: Container(
          color: Color(0xFF306AE7),

          //child container
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),

            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        //room name

                        Text("Room Name", style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        ),

                        SizedBox(height: 15),

                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Enter Room Name",

                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                width: 44,
                                height: 44,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE9ECFF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Color(0xFF4A6CF7),
                                  size: 22,
                                ),
                              ),
                            ),

                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 70,
                              minHeight: 60,
                            ),

                            filled: true,
                            fillColor: Colors.white,

                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 16,
                            ),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(
                                color: Color(0xFFE0E0E0),
                              ),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(
                                color: Color(0xFF4A6CF7),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        //room code

                        Text("Room Code", style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        ),

                        SizedBox(height: 15),

                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Enter Room Code",

                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                width: 44,
                                height: 44,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE9ECFF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.numbers_rounded,
                                  color: Color(0xFF4A6CF7),
                                  size: 22,
                                ),
                              ),
                            ),

                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 70,
                              minHeight: 60,
                            ),

                            filled: true,
                            fillColor: Colors.white,

                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 16,
                            ),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(
                                color: Color(0xFFE0E0E0),
                              ),
                            ),

                            suffixIcon: IconButton(
                              onPressed: () {
                                // Your refresh code here
                              },
                              icon: const Icon(
                                Icons.refresh,
                                color: Color(0xFF4A6CF7),
                                size: 26,
                              ),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(
                                color: Color(0xFF4A6CF7),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        //question file

                        Text("Question File", style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        ),

                        SizedBox(height: 15),

                        InkWell(
                            onTap: () {
                              print("clicked");
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(

                              height: 60,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Left Icon
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8EEFF),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.upload_file_rounded,
                                      color: Color(0xFF3366E8),
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  const Expanded(
                                    child: Text(
                                      "Upload Excel File",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),

                                  const Icon(
                                    Icons.folder_open_rounded,
                                    color: Color(0xFF3366E8),
                                  ),
                                ],
                              ),
                            )
                        ),

                        SizedBox(height: 20),

                        //start time

                        Text("Start Time", style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        ),

                        SizedBox(height: 15),

                        Container(
                          height: 65,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: const Color(0xFFE0E0E0),
                            ),
                          ),
                          child: Row(
                            children: [

                              // Left Icon
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE9ECFF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.access_time_rounded,
                                  color: Color(0xFF4A6CF7),
                                ),
                              ),

                              const SizedBox(width: 15),

                              // Center Text
                              const Expanded(
                                child: Text(
                                  "Select Start Time",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              // Selected Time
                              Text(
                                startTime == null
                                    ? "--:--"
                                    : startTime!.format(context),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4A6CF7),
                                ),
                              ),

                              const SizedBox(width: 5),

                              // Clock Button
                              IconButton(
                                onPressed: () => pickTime(true),
                                icon: const Icon(
                                  Icons.schedule_rounded,
                                  color: Color(0xFF4A6CF7),
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),

                        //End time

                        Text("End Time", style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        ),

                        SizedBox(height: 15),

                        Container(
                          height: 65,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: const Color(0xFFE0E0E0),
                            ),
                          ),
                          child: Row(
                            children: [

                              // Left Icon
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE9ECFF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.access_time_rounded,
                                  color: Color(0xFF4A6CF7),
                                ),
                              ),

                              const SizedBox(width: 15),

                              // Center Text
                              const Expanded(
                                child: Text(
                                  "Select End Time",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              // Selected Time
                              Text(
                                endTime == null
                                    ? "--:--"
                                    : endTime!.format(context),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4A6CF7),
                                ),
                              ),

                              const SizedBox(width: 5),

                              // Clock Button
                              IconButton(
                                onPressed: () => pickTime(false),
                                icon: const Icon(
                                  Icons.schedule_rounded,
                                  color: Color(0xFF4A6CF7),
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        )

                      ],
                    ),
                  ),
                )
              ],

            ),
          ),
        ),
      ),


    );

  }
}

