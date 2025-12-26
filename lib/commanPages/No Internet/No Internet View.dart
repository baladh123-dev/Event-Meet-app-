import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'No Internet.dart';

class NoInternetView extends GetView<NoInternetController> {
  const NoInternetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFD4145A),
              Color(0xFFFF6B9D),
              Color(0xFFFFD700),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background circles
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -150,
              left: -150,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Main content
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 3D-style WiFi off icon container
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              Colors.white.withOpacity(0.8),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 40,
                              offset: const Offset(0, 20),
                              spreadRadius: -5,
                            ),
                            BoxShadow(
                              color: const Color(0xFFD4145A).withOpacity(0.3),
                              blurRadius: 30,
                              offset: const Offset(-10, -10),
                            ),
                          ],
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFD4145A),
                                Color(0xFFFF6B9D),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.wifi_off_rounded,
                            size: 70,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // No Internet Message with 3D effect
                      Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateX(-0.02),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                              BoxShadow(
                                color: const Color(0xFFD4145A).withOpacity(0.4),
                                blurRadius: 25,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [
                                    Color(0xFFD4145A),
                                    Color(0xFFFF6B9D),
                                  ],
                                ).createShader(bounds),
                                child: const Text(
                                  "No Internet Connection",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [
                                    Color(0xFFD4145A),
                                    Color(0xFFFF6B9D),
                                  ],
                                ).createShader(bounds),
                                child: const Text(
                                  "இணைய இணைப்பு இல்லை",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFFD4145A).withOpacity(0.1),
                                      const Color(0xFFFF6B9D).withOpacity(0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: const Color(0xFFFF6B9D).withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                                child: const Text(
                                  "Please check your connection",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Main card with 3D effect
                      Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateX(0.01),
                        alignment: Alignment.center,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 60,
                                offset: const Offset(0, 30),
                                spreadRadius: -10,
                              ),
                              BoxShadow(
                                color: const Color(0xFFFFD700).withOpacity(0.4),
                                blurRadius: 40,
                                offset: const Offset(0, 20),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Community name with gradient text effect
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [
                                    Color(0xFFD4145A),
                                    Color(0xFFFF6B9D),
                                    Color(0xFFFFD700),
                                  ],
                                ).createShader(bounds),
                                child: const Text(
                                  "காட்டு நாயக்கன்\nமக்கள் சமுதாயம்",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    height: 1.3,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // 3D Matrimony badge
                              Transform(
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.002)
                                  ..rotateX(-0.05),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xFFFFD700),
                                        Color(0xFFFFC107),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFFD700).withOpacity(0.5),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(
                                        Icons.favorite_rounded,
                                        color: Color(0xFFD4145A),
                                        size: 24,
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        "Matrimony App",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFFD4145A),
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Icon(
                                        Icons.favorite_rounded,
                                        color: Color(0xFFD4145A),
                                        size: 24,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 32),

                              // Decorative divider
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            const Color(0xFFFF6B9D).withOpacity(0.5),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFFD4145A),
                                            Color(0xFFFF6B9D),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            const Color(0xFFFF6B9D).withOpacity(0.5),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 32),

                              // Description card with 3D effect
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFFFF6B9D).withOpacity(0.1),
                                      const Color(0xFFFFD700).withOpacity(0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xFFFF6B9D).withOpacity(0.3),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFF6B9D).withOpacity(0.2),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: const [
                                    Icon(
                                      Icons.groups_rounded,
                                      size: 40,
                                      color: Color(0xFFD4145A),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "இந்த மொபைல் பயன்பாடு",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF333333),
                                        height: 1.6,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "காட்டுநாயக்க மக்கள் சமுதாயத்துக்காக",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF333333),
                                        height: 1.6,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "உருவாக்கப்பட்டது",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF333333),
                                        height: 1.6,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Government verification badge with 3D effect
                              Transform(
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.002)
                                  ..rotateX(0.05),
                                child: Container(
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFFD4145A),
                                        Color(0xFFFF6B9D),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFD4145A).withOpacity(0.5),
                                        blurRadius: 25,
                                        offset: const Offset(0, 12),
                                      ),
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.verified_user_rounded,
                                          size: 28,
                                          color: Color(0xFFD4145A),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              "இந்த அனைத்து தரவுகளும்",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                height: 1.4,
                                              ),
                                            ),
                                            Text(
                                              "தமிழக அரசால் சேமிக்கப்பட்டுள்ளன",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                height: 1.4,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}