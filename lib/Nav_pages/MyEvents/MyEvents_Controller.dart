import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyEventsController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable list of events
  var myEvents = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyEvents();
  }

  // Fetch events created by current user
  Future<void> fetchMyEvents() async {
    try {
      isLoading.value = true;

      final user = _auth.currentUser;
      if (user == null) {
        log('❌ No user logged in');
        Get.snackbar(
          'Error',
          'Please login to view your events',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      log('🔍 Fetching events for user: ${user.uid}');

      // Query events where createdBy matches current user's UID
      final QuerySnapshot snapshot = await _firestore
          .collection('events')
          .where('createdBy', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .get();

      // Convert to list of maps with document IDs
      myEvents.value = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add document ID
        return data;
      }).toList();

      log('✅ Fetched ${myEvents.length} events');
    } catch (e) {
      log('❌ Error fetching events: $e');
      Get.snackbar(
        'Error',
        'Failed to load your events',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh events
  Future<void> refreshEvents() async {
    await fetchMyEvents();
  }

  // View event details
  void viewEventDetails(Map<String, dynamic> event) {
    // Navigate to event details screen
    // Get.toNamed('/event-details', arguments: event);

    // For now, show event info
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          event['title'] ?? 'Event Details',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (event['description'] != null && event['description'].toString().isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Description:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event['description'],
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              _buildDetailRow(
                icon: Icons.category,
                label: 'Category',
                value: event['category'] ?? 'N/A',
              ),
              _buildDetailRow(
                icon: Icons.location_on,
                label: 'Location',
                value: event['location'] ?? 'N/A',
              ),
              _buildDetailRow(
                icon: Icons.people,
                label: 'Attendees',
                value: '${(event['attendees'] as List).length} people',
              ),
              if (event['maxAttendees'] != null)
                _buildDetailRow(
                  icon: Icons.person_add,
                  label: 'Max Attendees',
                  value: '${event['maxAttendees']} people',
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF667eea)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Delete event
  Future<void> deleteEvent(String eventId) async {
    // Show confirmation dialog
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Delete Event?'),
        content: const Text(
          'Are you sure you want to delete this event? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back(); // Close dialog
              await _performDelete(eventId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _performDelete(String eventId) async {
    try {
      log('🗑️ Deleting event: $eventId');

      // Delete from Firestore
      await _firestore.collection('events').doc(eventId).delete();

      // Remove from local list
      myEvents.removeWhere((event) => event['id'] == eventId);

      log('✅ Event deleted successfully');

      Get.snackbar(
        'Success',
        'Event deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      log('❌ Error deleting event: $e');
      Get.snackbar(
        'Error',
        'Failed to delete event',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}