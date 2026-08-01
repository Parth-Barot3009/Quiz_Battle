import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class StaticWaitingRoom extends StatefulWidget {
  const StaticWaitingRoom({super.key});

  @override
  State<StaticWaitingRoom> createState() => _StaticWaitingRoomState();
}

class _StaticWaitingRoomState extends State<StaticWaitingRoom>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  // Theme Colors
  static const Color brandBlue = Color(0xFF306AE7);
  static const Color brandGradientStart = Color(0xFF4A7CFF);
  static const Color background = Color(0xFFEBF1FF);
  static const Color darkText = Color(0xFF1E293B);
  static const Color greyText = Color(0xFF64748B);

  // Static Dummy Room Code & Players List
  final String dummyRoomCode = "873ZDA";
  final List<String> dummyPlayers = [
    "Prachi",
    "Kashyap",
    "Alex Johnson",
    "Rahul Sharma",
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.92,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(_controller);

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          // Background Decorative Circles
          Positioned(
            top: -70,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: brandBlue.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            right: -50,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: brandBlue.withOpacity(0.06),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // 1. TOP HEADER BAR
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
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
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        "Waiting Room",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: darkText,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        // 2. ROOM CODE CARD
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [brandGradientStart, brandBlue],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: brandBlue.withOpacity(0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const Text(
                                "ROOM CODE",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white70,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  dummyRoomCode,
                                  style: const TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 6,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Share this code with players to join",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // 3. PLAYERS CARD & STATIC LIST
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Section Header
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: brandBlue.withOpacity(0.1),
                                          borderRadius:
                                          BorderRadius.circular(12),
                                        ),
                                        child: const Icon(
                                          Icons.people_alt_rounded,
                                          color: brandBlue,
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        "Players",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: darkText,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: brandBlue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "${dummyPlayers.length} Joined",
                                      style: const TextStyle(
                                        color: brandBlue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 18),

                              // Static List of Players
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: dummyPlayers.length,
                                separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  String name = dummyPlayers[index];

                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: background,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: brandBlue.withOpacity(0.12),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: brandBlue,
                                          child: Text(
                                            name.isNotEmpty
                                                ? name[0].toUpperCase()
                                                : "P",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Text(
                                            name,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: darkText,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF10B981)
                                                .withOpacity(0.12),
                                            borderRadius:
                                            BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Icon(
                                                Icons.check_circle_rounded,
                                                size: 14,
                                                color: Color(0xFF10B981),
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                "Joined",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF10B981),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // 4. ANIMATED FOOTER
                        Center(
                          child: Column(
                            children: [
                              ScaleTransition(
                                scale: _scaleAnimation,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.amber.shade100,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.amber.withOpacity(0.4),
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.bolt_rounded,
                                    size: 54,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              FadeTransition(
                                opacity: _fadeAnimation,
                                child: const Text(
                                  "BATTLE STARTING!",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: brandBlue,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              AnimatedTextKit(
                                repeatForever: true,
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    "Get ready to compete...",
                                    speed: const Duration(milliseconds: 70),
                                    textStyle: const TextStyle(
                                      fontSize: 15,
                                      color: greyText,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}