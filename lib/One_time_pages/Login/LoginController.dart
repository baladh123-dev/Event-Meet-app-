import 'dart:developer';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginController extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;
  var user = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    _checkCurrentUser();
  }

  // Check if user already logged in
  void _checkCurrentUser() {
    user.value = _auth.currentUser;
    if (user.value != null) {
      log("User already logged in: ${user.value!.email}");
    }
  }

  // 🔥 CHECK USER BY EMAIL (Firestore)
  Future<bool> _isExistingUserByEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      log("Error checking user by email: $e");
      return false;
    }
  }

  // 🔐 GOOGLE SIGN IN
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      log("Starting Google Sign In...");

      final GoogleSignInAccount? googleUser =
      await _googleSignIn.signIn();

      if (googleUser == null) {
        log("Google Sign In canceled by user");
        return;
      }

      log("Google User Email: ${googleUser.email}");

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      user.value = userCredential.user;

      final String email = user.value!.email ?? '';
      log("Firebase User Email: $email");
      log("Firebase UID: ${user.value!.uid}");

      // 🔍 EMAIL BASED CHECK
      bool isExisting = await _isExistingUserByEmail(email);

      // Save email locally
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userEmail', email);

      // Snackbar
      Get.snackbar(
        isExisting ? 'Welcome Back!' : 'Welcome!',
        isExisting
            ? 'Hello again, ${user.value!.displayName?.split(' ')[0] ?? 'there'}!'
            : 'Let\'s get you started, ${user.value!.displayName?.split(' ')[0] ?? 'there'}!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      // 🚦 ROUTING
      if (isExisting) {
        Get.offAllNamed('/Nav');       // OLD USER
      } else {
        Get.offAllNamed('/user-info'); // NEW USER
      }
    } catch (e) {
      log("Google Sign In Error: $e");
      Get.snackbar(
        'Error',
        'Failed to sign in with Google. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
