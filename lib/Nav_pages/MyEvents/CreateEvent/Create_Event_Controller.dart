import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class CreateEventController extends GetxController {
  // Form controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final maxAttendeesController = TextEditingController();

  // Observable variables
  var selectedCategory = ''.obs;
  var selectedDate = Rx<DateTime?>(null);
  var selectedTime = Rx<TimeOfDay?>(null);
  var selectedImage = Rx<File?>(null);
  var imageUrl = ''.obs;

  // Loading states
  var isLoading = false.obs;
  var isUploadingImage = false.obs;

  // Categories list
  final List<Map<String, dynamic>> categories = [
    {'name': 'Music Festival', 'icon': '🎵', 'color': '0xFF9C27B0'},
    {'name': 'Sports', 'icon': '⚽', 'color': '0xFF66BB6A'},
    {'name': 'Tech Conference', 'icon': '💻', 'color': '0xFF26A69A'},
    {'name': 'Food & Dining', 'icon': '🍔', 'color': '0xFFFF9800'},
    {'name': 'Networking', 'icon': '🤝', 'color': '0xFF7B1FA2'},
    {'name': 'Casual Hangout', 'icon': '☕', 'color': '0xFF4DB6AC'},
    {'name': 'Arts & Culture', 'icon': '🎨', 'color': '0xFFE91E63'},
    {'name': 'Gaming', 'icon': '🎮', 'color': '0xFF673AB7'},
    {'name': 'Business', 'icon': '💼', 'color': '0xFF607D8B'},
    {'name': 'Workshop', 'icon': '🛠️', 'color': '0xFF26A69A'},
    {'name': 'Party', 'icon': '🎉', 'color': '0xFF9C27B0'},
    {'name': 'Fitness', 'icon': '💪', 'color': '0xFF66BB6A'},
  ];

  @override
  void onInit() {
    super.onInit();
  }

  // Pick image from gallery
  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        log('✅ Image selected: ${image.path}');
      }
    } catch (e) {
      log('❌ Error picking image: $e');
      Get.snackbar(
        'Error',
        'Failed to pick image',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Upload image to Firebase Storage
  Future<String?> uploadImage() async {
    if (selectedImage.value == null) return null;

    try {
      isUploadingImage.value = true;

      final String fileName = 'event_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('event_images')
          .child(fileName);

      await storageRef.putFile(selectedImage.value!);
      final String downloadUrl = await storageRef.getDownloadURL();

      log('✅ Image uploaded: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      log('❌ Error uploading image: $e');
      Get.snackbar(
        'Upload Error',
        'Failed to upload image',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    } finally {
      isUploadingImage.value = false;
    }
  }

  // Select category
  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  // Pick date
  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF9C27B0),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  // Pick time
  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF9C27B0),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedTime.value = picked;
    }
  }

  // Validate form
  bool validateForm() {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please enter event title',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF9C27B0),
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
      return false;
    }

    if (selectedCategory.value.isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please select a category',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF9C27B0),
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
      return false;
    }

    if (selectedDate.value == null) {
      Get.snackbar(
        'Required Field',
        'Please select event date',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF9C27B0),
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
      return false;
    }

    if (selectedTime.value == null) {
      Get.snackbar(
        'Required Field',
        'Please select event time',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF9C27B0),
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
      return false;
    }

    if (locationController.text.trim().isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please enter event location',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF9C27B0),
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
      return false;
    }

    return true;
  }

  // Create event
  Future<void> createEvent() async {
    if (!validateForm()) return;

    try {
      isLoading.value = true;

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar(
          'Authentication Error',
          'Please login to create events',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Upload image if selected
      String? uploadedImageUrl;
      if (selectedImage.value != null) {
        uploadedImageUrl = await uploadImage();
      }

      // Combine date and time
      final DateTime eventDateTime = DateTime(
        selectedDate.value!.year,
        selectedDate.value!.month,
        selectedDate.value!.day,
        selectedTime.value!.hour,
        selectedTime.value!.minute,
      );

      // Parse max attendees
      int? maxAttendees;
      if (maxAttendeesController.text.trim().isNotEmpty) {
        maxAttendees = int.tryParse(maxAttendeesController.text.trim());
      }

      // Create event document
      final eventData = {
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'category': selectedCategory.value,
        'location': locationController.text.trim(),
        'dateTime': Timestamp.fromDate(eventDateTime),
        'imageUrl': uploadedImageUrl ?? '',
        'maxAttendees': maxAttendees,
        'attendees': [user.uid], // Creator is first attendee
        'createdBy': user.uid,
        'createdByName': user.displayName ?? 'Anonymous',
        'createdByPhoto': user.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isActive': true,
      };

      await FirebaseFirestore.instance.collection('events').add(eventData);

      log('✅ Event created successfully');

      // Show success message
      Get.snackbar(
        '🎉 Event Created!',
        'Your event has been published successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF66BB6A),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );

      // Navigate back
      await Future.delayed(const Duration(milliseconds: 500));
      Get.back(result: true);

    } catch (e) {
      log('❌ Error creating event: $e');
      Get.snackbar(
        'Error',
        'Failed to create event. Please try again.',
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

  // Remove selected image
  void removeImage() {
    selectedImage.value = null;
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    maxAttendeesController.dispose();
    super.onClose();
  }
}