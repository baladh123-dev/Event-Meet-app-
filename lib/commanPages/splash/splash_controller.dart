import 'dart:async';
import 'dart:developer';
import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// ========== SPLASH CONTROLLER ==========
class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fade;
  late Animation<double> scale;
  late Animation<double> rotate;

  @override
  void onInit() {
    super.onInit();
    _initAnimation();
    _navigateToHome();
  }

  void _initAnimation() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..forward();

    fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    scale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    rotate = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
      ),
    );
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));

    // 🌐 Check internet connection
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      log("❌ NO INTERNET CONNECTION");
      Get.offAllNamed('/no-more-internet');
      return;
    }

    log("✅ INTERNET CONNECTED");

    // 📦 Get saved email from SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString("gmail"); // 🔴 KEY NAME

    if (email != null && email.isNotEmpty) {
      log("✅ EMAIL FOUND → $email");
      Get.offAllNamed('/Nav');
    } else {
      log("❌ EMAIL NOT FOUND");
      Get.offAllNamed('/Login');
    }
  }

      @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
