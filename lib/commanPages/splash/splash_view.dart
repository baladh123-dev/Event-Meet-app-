import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matrimony/commanPages/splash/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SplashController controller = Get.put(SplashController());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF9C27B0), // Purple
              Color(0xFF7B1FA2), // Deep Purple
              Color(0xFF26A69A), // Teal
              Color(0xFF66BB6A), // Green
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated background particles
            ...List.generate(20, (index) => _FloatingParticle(index: index)),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Logo
                  AnimatedBuilder(
                    animation: controller.controller,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: controller.scale.value,
                        child: Transform.rotate(
                          angle: controller.rotate.value * 0.5,
                          child: Opacity(
                            opacity: controller.fade.value,
                            child: Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.2),
                                    blurRadius: 40,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Image.asset(
                                'assets/logo-bk.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // App Name with Animation
                  FadeTransition(
                    opacity: controller.fade,
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.white, Color(0xFFE1F5FE)],
                      ).createShader(bounds),
                      child:RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Even ',
                              style: GoogleFonts.poppins(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E3B74), // blue
                                letterSpacing: 1.5,
                              ),
                            ),
                            TextSpan(
                              text: 'Meet',
                              style: GoogleFonts.poppins(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3CB0A5), // green
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      )

                    ),
                  ),

                  const SizedBox(height: 12),

                  // Tagline
                  FadeTransition(
                    opacity: controller.fade,
                    child:  Text(
                      'Connect  Gather  Discover',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Color(0xFF162A64),
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w300,
                      ),
                    ),

                  ),

                  const SizedBox(height: 60),

                  // Loading Indicator
                  FadeTransition(
                    opacity: controller.fade,
                    child: const _ModernLoader(),
                  ),
                ],
              ),
            ),

            // Bottom wave decoration
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: controller.controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: 0.2,
                    child: CustomPaint(
                      size: Size(MediaQuery.of(context).size.width, 150),
                      painter: WavePainter(controller.controller.value),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingParticle extends StatelessWidget {
  final int index;

  const _FloatingParticle({required this.index});

  @override
  Widget build(BuildContext context) {
    final random = (index * 13) % 100;
    final size = 4.0 + (random % 8);
    final duration = 3 + (random % 4);
    final left = (random * 3.7) % 100;

    return Positioned(
      left: MediaQuery.of(context).size.width * (left / 100),
      top: -50,
      child: _AnimatedParticle(
        size: size,
        duration: duration,
      ),
    );
  }
}




// ========== ANIMATED PARTICLE ==========
class _AnimatedParticle extends StatefulWidget {
  final double size;
  final int duration;

  const _AnimatedParticle({
    required this.size,
    required this.duration,
  });

  @override
  State<_AnimatedParticle> createState() => _AnimatedParticleState();
}

class _AnimatedParticleState extends State<_AnimatedParticle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: widget.duration),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
              0, MediaQuery.of(context).size.height * _animation.value * 1.2),
          child: Opacity(
            opacity: (1 - _animation.value) * 0.5,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}






// ========== MODERN LOADER WIDGET ==========
class _ModernLoader extends StatelessWidget {
  const _ModernLoader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        children: [
          // Outer ring
          CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white.withOpacity(0.3),
            ),
          ),
          // Inner spinning ring
          const CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeCap: StrokeCap.round,
          ),
        ],
      ),
    );
  }
}

// ========== WAVE PAINTER ==========
class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.5);

    for (double i = 0; i < size.width; i++) {
      path.lineTo(
        i,
        size.height * 0.5 +
            20 *
                Math.sin((i / size.width * 2 * Math.pi) +
                    (animationValue * 2 * Math.pi)),
      );
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}