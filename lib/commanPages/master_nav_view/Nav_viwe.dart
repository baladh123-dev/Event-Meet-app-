import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Screens
import '../../Nav_pages/ExpolaoreEvenList/EventsViewScreen.dart';
import '../../Nav_pages/MyEvents/MyEvents_viwe.dart';
import '../../Nav_pages/Profile/Profile_viwe.dart';
import 'Nav_Controller.dart';

class MasterNavView extends StatelessWidget {
  MasterNavView({super.key});

  final BottomNavController controller = Get.put(BottomNavController());

  final List<Widget> pages = [
    EventsViewScreen(),
    MyEventsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      body: pages[controller.currentIndex.value],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: controller.changeTab,

        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,

        selectedItemColor: AppColors.purple,
        unselectedItemColor: Colors.grey,

        selectedLabelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Inter',
        ),

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    ));
  }
}


class AppColors {
  static const Color purple = Color(0xFF9C27B0);
  static const Color teal = Color(0xFF26A69A);
  static const Color green = Color(0xFF66BB6A);

  static const Color purpleDeep = Color(0xFF7B1FA2);
  static const Color tealLight = Color(0xFF4DB6AC);
  static const Color greenMint = Color(0xFF81C784);
}