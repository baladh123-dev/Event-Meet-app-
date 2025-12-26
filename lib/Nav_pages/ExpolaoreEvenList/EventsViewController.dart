import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventsViewController extends GetxController {
  // Tab selection
  var selectedTab = 'All Events'.obs; // 'All Events' or 'Favorites'

  // Loading states
  var isLoading = true.obs;
  var isSearching = false.obs;

  // Search
  var searchController = TextEditingController();
  var searchQuery = ''.obs;

  // Events data
  var allEvents = <Map<String, dynamic>>[].obs;
  var favoriteEvents = <Map<String, dynamic>>[].obs;
  var filteredEvents = <Map<String, dynamic>>[].obs;

  // User favorites
  var userFavorites = <String>[].obs;

  // Current user
  String? currentUserId;

  @override
  void onInit() {
    super.onInit();
    currentUserId = FirebaseAuth.instance.currentUser?.uid;
    fetchEvents();
    fetchUserFavorites();

    // Listen to search input
    searchController.addListener(() {
      searchQuery.value = searchController.text;
      filterEvents();
    });
  }

  // Fetch all events from Firebase
  Future<void> fetchEvents() async {
    try {
      isLoading.value = true;

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('events')
          .orderBy('dateTime', descending: false)
          .get();

      allEvents.value = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();

      filterEvents();
      log('✅ Fetched ${allEvents.length} events');
    } catch (e) {
      log('❌ Error fetching events: $e');
      Get.snackbar(
        'Error',
        'Failed to load events',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch user's favorite events
  Future<void> fetchUserFavorites() async {
    if (currentUserId == null) return;

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        userFavorites.value = List<String>.from(data['favoriteEvents'] ?? []);
        updateFavoriteEvents();
      }
    } catch (e) {
      log('Error fetching favorites: $e');
    }
  }

  // Update favorite events list
  void updateFavoriteEvents() {
    favoriteEvents.value = allEvents
        .where((event) => userFavorites.contains(event['id']))
        .toList();
    filterEvents();
  }

  // Toggle favorite
  Future<void> toggleFavorite(String eventId) async {
    if (currentUserId == null) {
      Get.snackbar(
        'Login Required',
        'Please login to save favorites',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF9C27B0),
        colorText: Colors.white,
      );
      return;
    }

    try {
      if (userFavorites.contains(eventId)) {
        userFavorites.remove(eventId);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .update({
          'favoriteEvents': FieldValue.arrayRemove([eventId])
        });
      } else {
        userFavorites.add(eventId);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .update({
          'favoriteEvents': FieldValue.arrayUnion([eventId])
        });
      }
      updateFavoriteEvents();
    } catch (e) {
      log('Error toggling favorite: $e');
      Get.snackbar(
        'Error',
        'Failed to update favorites',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Filter events based on search and selected tab
  void filterEvents() {
    List<Map<String, dynamic>> sourceEvents =
    selectedTab.value == 'All Events' ? allEvents : favoriteEvents;

    if (searchQuery.value.isEmpty) {
      filteredEvents.value = sourceEvents;
    } else {
      filteredEvents.value = sourceEvents.where((event) {
        String query = searchQuery.value.toLowerCase();
        String title = (event['title'] ?? '').toLowerCase();
        String description = (event['description'] ?? '').toLowerCase();
        String category = (event['category'] ?? '').toLowerCase();
        String location = (event['location'] ?? '').toLowerCase();

        return title.contains(query) ||
            description.contains(query) ||
            category.contains(query) ||
            location.contains(query);
      }).toList();
    }
  }

  // Switch tab
  void switchTab(String tab) {
    selectedTab.value = tab;
    filterEvents();
  }

  // Clear search
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    filterEvents();
  }

  // Navigate to event details
  void openEventDetails(Map<String, dynamic> event) {
    Get.toNamed('/event-details', arguments: event);
  }

  // Navigate to create event
  void createNewEvent() {
    Get.toNamed('/create-event');
  }

  // Refresh events
  Future<void> refreshEvents() async {
    await fetchEvents();
    await fetchUserFavorites();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}