import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController extends GetxController {
  // Loading states
  var isLoading = true.obs;
  var isUpdating = false.obs;

  // User data
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userPhotoUrl = ''.obs;
  var userCountry = ''.obs;
  var userState = ''.obs;
  var userCity = ''.obs;
  var userInterests = <String>[].obs;
  var loginType = ''.obs;
  var memberSince = ''.obs;

  // Statistics
  var eventsAttended = 0.obs;
  var eventsCreated = 0.obs;
  var connectionsCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  // Fetch user profile from Firebase
  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        Get.snackbar(
          'Error',
          'No user logged in',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

        // Update observable variables
        userName.value = data['name'] ?? 'User';
        userEmail.value = data['email'] ?? '';
        userPhotoUrl.value = data['photoUrl'] ?? '';
        userCountry.value = data['country'] ?? '';
        userState.value = data['state'] ?? '';
        userCity.value = data['city'] ?? '';
        userInterests.value = List<String>.from(data['interests'] ?? []);
        loginType.value = data['loginType'] ?? '';

        // Format member since date
        if (data['createdAt'] != null) {
          Timestamp timestamp = data['createdAt'];
          DateTime date = timestamp.toDate();
          memberSince.value = _formatDate(date);
        }

        // Fetch statistics (you can implement these based on your app logic)
        await _fetchUserStatistics(user.uid);

        log('✅ Profile loaded successfully');
      } else {
        log('⚠️ User document not found');
      }
    } catch (e) {
      log('❌ Error fetching profile: $e');
      Get.snackbar(
        'Error',
        'Failed to load profile',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch user statistics (events, connections, etc.)
  Future<void> _fetchUserStatistics(String uid) async {
    try {
      // Example: Count events attended
      QuerySnapshot attendedEvents = await FirebaseFirestore.instance
          .collection('events')
          .where('attendees', arrayContains: uid)
          .get();
      eventsAttended.value = attendedEvents.docs.length;

      // Example: Count events created
      QuerySnapshot createdEvents = await FirebaseFirestore.instance
          .collection('events')
          .where('createdBy', isEqualTo: uid)
          .get();
      eventsCreated.value = createdEvents.docs.length;

      // Example: Count connections
      DocumentSnapshot connectionsDoc = await FirebaseFirestore.instance
          .collection('connections')
          .doc(uid)
          .get();

      if (connectionsDoc.exists) {
        Map<String, dynamic> data = connectionsDoc.data() as Map<String, dynamic>;
        connectionsCount.value = (data['friends'] as List?)?.length ?? 0;
      }
    } catch (e) {
      log('Error fetching statistics: $e');
    }
  }

  // Format date
  String _formatDate(DateTime date) {
    return '${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month];
  }

  // Edit Profile
  void editProfile() {
    Get.toNamed('/edit-profile');
  }

  // Logout
  Future<void> logout() async {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.logout,
                color: Color(0xFF9C27B0),
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to logout?',
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
                        'Cancel',
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
                      onPressed: () async {
                        Get.back();
                        await FirebaseAuth.instance.signOut();
                        Get.offAllNamed('/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9C27B0),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Logout',
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

  // Refresh profile
  Future<void> refreshProfile() async {
    await fetchUserProfile();
  }
}