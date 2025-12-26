import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'EventsViewController.dart';

class EventsViewScreen extends StatelessWidget {
  const EventsViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EventsViewController controller = Get.put(EventsViewController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header with gradient
            _buildHeader(controller),

            // Tab Toggle
            _buildTabToggle(controller),

            // Search Bar
            _buildSearchBar(controller),

            // Events List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          color: Color(0xFF9C27B0),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Loading events...',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.filteredEvents.isEmpty) {
                  return _buildEmptyState(controller);
                }

                return RefreshIndicator(
                  onRefresh: controller.refreshEvents,
                  color: const Color(0xFF9C27B0),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: controller.filteredEvents.length,
                    itemBuilder: (context, index) {
                      return _buildEventCard(
                        controller,
                        controller.filteredEvents[index],
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),

    );
  }

  Widget _buildHeader(EventsViewController controller) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.celebration,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'EventMeet',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Discover amazing events around you',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabToggle(EventsViewController controller) {
    return Obx(() => Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              controller: controller,
              title: 'All Events',
              icon: Icons.grid_view_rounded,
              isSelected: controller.selectedTab.value == 'All Events',
            ),
          ),
          Expanded(
            child: _buildTabButton(
              controller: controller,
              title: 'Favorites',
              icon: Icons.favorite,
              isSelected: controller.selectedTab.value == 'Favorites',
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildTabButton({
    required EventsViewController controller,
    required String title,
    required IconData icon,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => controller.switchTab(title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
            colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
          )
              : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(EventsViewController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: Color(0xFF9C27B0),
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller.searchController,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: 'Search events, categories, locations...',
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          Obx(() {
            if (controller.searchQuery.value.isNotEmpty) {
              return IconButton(
                icon: const Icon(Icons.clear, size: 20),
                color: Colors.grey[600],
                onPressed: controller.clearSearch,
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildEventCard(
      EventsViewController controller,
      Map<String, dynamic> event,
      ) {
    String eventId = event['id'] ?? '';
    String title = event['title'] ?? 'Untitled Event';
    String description = event['description'] ?? '';
    String category = event['category'] ?? 'General';
    String location = event['location'] ?? 'Location TBA';
    String imageUrl = event['imageUrl'] ?? '';
    int attendeesCount = (event['attendees'] as List?)?.length ?? 0;

    // Parse date
    DateTime? dateTime;
    String formattedDate = 'Date TBA';
    String formattedTime = '';

    if (event['dateTime'] != null) {
      try {
        dateTime = (event['dateTime'] as Timestamp).toDate();
        formattedDate = DateFormat('MMM dd, yyyy').format(dateTime);
        formattedTime = DateFormat('hh:mm a').format(dateTime);
      } catch (e) {
        log('Error parsing date: $e');
      }
    }

    bool isFavorite = controller.userFavorites.contains(eventId);

    return GestureDetector(
      onTap: () => controller.openEventDetails(event),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF9C27B0), Color(0xFF26A69A)],
                    ),
                    image: imageUrl.isNotEmpty
                        ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: imageUrl.isEmpty
                      ? Center(
                    child: Icon(
                      Icons.event,
                      size: 60,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  )
                      : null,
                ),

                // Category Badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Favorite Button
                Positioned(
                  top: 12,
                  right: 12,
                  child: Obx(() {
                    bool isFav = controller.userFavorites.contains(eventId);
                    return GestureDetector(
                      onTap: () => controller.toggleFavorite(eventId),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.grey[600],
                          size: 20,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),

            // Event Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Description
                  if (description.isNotEmpty)
                    Text(
                      description,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                  const SizedBox(height: 12),

                  // Date & Time
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF26A69A).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.calendar_today,
                          color: Color(0xFF26A69A),
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formattedDate,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            if (formattedTime.isNotEmpty)
                              Text(
                                formattedTime,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Location
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9C27B0).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Color(0xFF9C27B0),
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          location,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Attendees
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF66BB6A).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.people,
                          color: Color(0xFF66BB6A),
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '$attendeesCount attending',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(EventsViewController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: const Color(0xFF9C27B0).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              controller.selectedTab.value == 'Favorites'
                  ? Icons.favorite_border
                  : Icons.event_busy,
              size: 80,
              color: const Color(0xFF9C27B0),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            controller.selectedTab.value == 'Favorites'
                ? 'No Favorites Yet'
                : controller.searchQuery.value.isNotEmpty
                ? 'No Events Found'
                : 'No Events Available',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              controller.selectedTab.value == 'Favorites'
                  ? 'Start adding events to your favorites by tapping the heart icon'
                  : controller.searchQuery.value.isNotEmpty
                  ? 'Try adjusting your search terms'
                  : 'Be the first to create an event!',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          if (controller.selectedTab.value != 'Favorites' &&
              controller.searchQuery.value.isEmpty)
            ElevatedButton.icon(
              onPressed: controller.createNewEvent,
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text(
                'Create Event',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C27B0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}