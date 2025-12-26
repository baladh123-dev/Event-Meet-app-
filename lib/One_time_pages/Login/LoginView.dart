import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'LoginController.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFFf093fb),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo/Icon Section
                  _buildLogoSection(),

                  SizedBox(height: 20),

                  // App Name
                  _buildAppName(),

                  SizedBox(height: 16),

                  // Tagline
                  _buildTagline(),

                  SizedBox(height: 50),

                  // Google Sign In Button
                  Obx(() => _buildGoogleSignInButton(controller)),

                  SizedBox(height: 24),

                  // Terms and Privacy
                  _buildTermsText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 800),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              Icons.event_available,
              size: 60,
              color: Color(0xFF667eea),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppName() {
    return Text(
      'EventMeetApp',
      style: GoogleFonts.poppins(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTagline() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTaglineItem(Icons.connect_without_contact, 'Connect'),
            SizedBox(width: 8),
            Text(
              '•',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 20,
              ),
            ),
            SizedBox(width: 8),
            _buildTaglineItem(Icons.groups, 'Gather'),
            SizedBox(width: 8),
            Text(
              '•',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 20,
              ),
            ),
            SizedBox(width: 8),
            _buildTaglineItem(Icons.explore, 'Discover'),
          ],
        ),
        SizedBox(height: 12),
        Text(
          'Your gateway to amazing events',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: Colors.white.withOpacity(0.85),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildTaglineItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        SizedBox(width: 4),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: Colors.white.withOpacity(0.95),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleSignInButton(LoginController controller) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: controller.isLoading.value ? null : () => controller.signInWithGoogle(),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: controller.isLoading.value
                ? Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
                ),
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://cdn.cdnlogo.com/logos/g/35/google-icon.svg',
                  height: 24,
                  width: 24,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.g_mobiledata, size: 32, color: Color(0xFF667eea));
                  },
                ),
                SizedBox(width: 16),
                Text(
                  'Continue with Google',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTermsText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        'By continuing, you agree to our Terms of Service and Privacy Policy',
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.white.withOpacity(0.8),
          height: 1.5,
        ),
      ),
    );
  }
}