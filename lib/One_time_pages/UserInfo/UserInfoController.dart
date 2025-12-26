import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfoController extends GetxController {
  // Observable variables
  var currentStep = 0.obs;
  var isLoading = false.obs;

  // User data
  var selectedCountry = ''.obs;
  var selectedState = ''.obs;
  var selectedCity = ''.obs;
  var selectedInterests = <String>[].obs;

  // TextEditingControllers for CountryStateCityPicker
  late TextEditingController countryController;
  late TextEditingController stateController;
  late TextEditingController cityController;

  final List<Map<String, dynamic>> interests = [
    {'name': 'Music Festival', 'icon': '🎵', 'color': '0xFF9C27B0'},
    {'name': 'Sports', 'icon': '⚽', 'color': '0xFF66BB6A'},
    {'name': 'Tech Conference', 'icon': '💻', 'color': '0xFF26A69A'},
    {'name': 'Food & Dining', 'icon': '🍔', 'color': '0xFFFF9800'},
    {'name': 'Networking', 'icon': '🤝', 'color': '0xFF7B1FA2'},
    {'name': 'Casual Hangouts', 'icon': '☕', 'color': '0xFF4DB6AC'},
    {'name': 'Arts & Culture', 'icon': '🎨', 'color': '0xFFE91E63'},
    {'name': 'Gaming', 'icon': '🎮', 'color': '0xFF673AB7'},
    {'name': 'Business', 'icon': '💼', 'color': '0xFF607D8B'},
    {'name': 'Travel', 'icon': '✈️', 'color': '0xFF26A69A'},
    {'name': 'Photography', 'icon': '📷', 'color': '0xFF795548'},
    {'name': 'Dance', 'icon': '💃', 'color': '0xFFFF4081'},
    {'name': 'Yoga & Wellness', 'icon': '🧘', 'color': '0xFF81C784'},
    {'name': 'Cooking Workshop', 'icon': '👨‍🍳', 'color': '0xFFFF5722'},
    {'name': 'Movies & Cinema', 'icon': '🎬', 'color': '0xFF9C27B0'},
    {'name': 'Book Club', 'icon': '📖', 'color': '0xFF5D4037'},
    {'name': 'Fitness & Gym', 'icon': '💪', 'color': '0xFF66BB6A'},
    {'name': 'Fashion', 'icon': '👗', 'color': '0xFFE91E63'},
    {'name': 'Education', 'icon': '📚', 'color': '0xFF2196F3'},
    {'name': 'Comedy Shows', 'icon': '😂', 'color': '0xFFFF9800'},
  ];

  @override
  void onInit() {
    super.onInit();

    // Initialize TextEditingControllers
    countryController = TextEditingController();
    stateController = TextEditingController();
    cityController = TextEditingController();

    // Add listeners to sync controllers with reactive variables
    countryController.addListener(() {
      selectedCountry.value = countryController.text;
    });

    stateController.addListener(() {
      selectedState.value = stateController.text;
    });

    cityController.addListener(() {
      selectedCity.value = cityController.text;
    });

    _loadSavedData();
  }

  // Load saved data if available
  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String country = prefs.getString('country') ?? '';
    String state = prefs.getString('state') ?? '';
    String city = prefs.getString('city') ?? '';

    // Update both reactive variables and controllers
    selectedCountry.value = country;
    selectedState.value = state;
    selectedCity.value = city;

    countryController.text = country;
    stateController.text = state;
    cityController.text = city;

  }

  // Select/Deselect interest
  void toggleInterest(String interest) {
    if (selectedInterests.contains(interest)) {
      selectedInterests.remove(interest);
    } else {
      selectedInterests.add(interest);
    }
  }

  // Validate current step
  bool validateCurrentStep() {
    switch (currentStep.value) {
      case 0: // Country, State & City
        if (selectedCountry.value.isEmpty) {
          Get.snackbar(
            'Location Required',
            'Please select your country to continue',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF9C27B0),
            colorText: Colors.white,
            borderRadius: 12,
            margin: const EdgeInsets.all(16),
          );
          return false;
        }
        if (selectedState.value.isEmpty) {
          Get.snackbar(
            'Location Required',
            'Please select your state to continue',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF9C27B0),
            colorText: Colors.white,
            borderRadius: 12,
            margin: const EdgeInsets.all(16),
          );
          return false;
        }
        if (selectedCity.value.isEmpty) {
          Get.snackbar(
            'Location Required',
            'Please select your city to continue',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF9C27B0),
            colorText: Colors.white,
            borderRadius: 12,
            margin: const EdgeInsets.all(16),
          );
          return false;
        }
        return true;

      case 1: // Interests
        if (selectedInterests.length < 1) {
          Get.snackbar(
            'Interests Required',
            'Please select at least 1 interests to personalize your experience',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF9C27B0),
            colorText: Colors.white,
            borderRadius: 12,
            margin: const EdgeInsets.all(16),
          );
          return false;
        }
        return true;

      default:
        return true;
    }
  }

  // Go to next step
  void nextStep() {
    if (validateCurrentStep()) {
      if (currentStep.value < 1) {
        currentStep.value++;
      } else {
        saveUserInfo();
      }
    }
  }

  // Go to previous step
  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  // Save user info to both local storage and Firebase
  Future<void> saveUserInfo() async {
    try {
      isLoading.value = true;

      // 1️⃣ Get current user (Google / Firebase)
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        Get.snackbar(
          'Authentication Error',
          'User not logged in. Please sign in again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 12,
          margin: const EdgeInsets.all(16),
        );
        return;
      }

      final String uid = user.uid;
      final String? userEmail = user.email; // 📧 Get user email

      if (userEmail == null) {
        Get.snackbar(
          'Email Error',
          'Email not found. Please sign in again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 12,
          margin: const EdgeInsets.all(16),
        );
        return;
      }

      // 2️⃣ Save locally (SharedPreferences)
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('gmail', userEmail); // 📧 Save email

      // 3️⃣ Save to Firestore using EMAIL as document ID
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail) // 🔥 Using email as document ID
          .set({
        'uid': uid, // Store UID as a field
        'country': selectedCountry.value,
        'state': selectedState.value,
        'city': selectedCity.value,
        'interests': selectedInterests.toList(),
        'isProfileComplete': true,
        'loginType': user.providerData.first.providerId,
        'email': userEmail,
        'name': user.displayName,
        'photoUrl': user.photoURL,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // 4️⃣ Success UI
      Get.snackbar(
        '🎉 Welcome to EventMeet!',
        'Your profile is all set. Let\'s discover events!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF66BB6A),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );

      // 5️⃣ Navigate to Home
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAllNamed('/Nav');

    } catch (e) {
      log('❌ Error saving user info: $e');

      Get.snackbar(
        'Oops! Something went wrong',
        'Failed to save profile. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }


  // Skip for now
  void skipForNow() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.info_outline,
                color: Color(0xFF9C27B0),
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'Skip Profile Setup?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'You can complete your profile later from settings. However, we recommend completing it now for a better experience.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Color(0xFF9C27B0)),
                      ),
                      child: const Text(
                        'Continue Setup',
                        style: TextStyle(
                          color: Color(0xFF9C27B0),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.offAllNamed('/Nav');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9C27B0),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onClose() {
    // Dispose controllers
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
    super.onClose();
  }
}