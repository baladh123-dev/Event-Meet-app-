import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'UserInfoController.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserInfoController controller = Get.put(UserInfoController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Modern Header
            _buildModernHeader(controller),

            // Content
            Expanded(
              child: Obx(() {
                switch (controller.currentStep.value) {
                  case 0:
                    return _buildLocationStep(controller);
                  case 1:
                    return _buildInterestsStep(controller);
                  default:
                    return Container();
                }
              }),
            ),

            // Bottom Navigation
            _buildBottomNavigation(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHeader(UserInfoController controller) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9C27B0).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Logo or App Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.celebration,
              color: Colors.white,
              size: 32,
            ),
          ),

          const SizedBox(height: 16),

          // App Name
          Text(
            'EventMeet',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 8),

          // Tagline
          Text(
            'Connect. Gather. Discover.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 24),

          // Progress Indicator
          Obx(() => Row(
            children: List.generate(2, (index) {
              bool isActive = index <= controller.currentStep.value;
              bool isCurrent = index == controller.currentStep.value;

              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: isCurrent ? 6 : 4,
                  margin: EdgeInsets.only(right: index < 1 ? 12 : 0),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white
                        : Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: isActive
                        ? [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                        : null,
                  ),
                ),
              );
            }),
          )),

          const SizedBox(height: 20),

          // Step Title
          Obx(() => Text(
            _getStepTitle(controller.currentStep.value),
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          )),

          const SizedBox(height: 6),

          // Step Subtitle
          Obx(() => Text(
            _getStepSubtitle(controller.currentStep.value),
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.white.withOpacity(0.85),
            ),
            textAlign: TextAlign.center,
          )),
        ],
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return '📍 Where are you?';
      case 1:
        return '🎯 What interests you?';
      default:
        return '';
    }
  }

  String _getStepSubtitle(int step) {
    switch (step) {
      case 0:
        return 'Discover amazing events happening near you';
      case 1:
        return 'Select at least 1 topics to personalize your feed';
      default:
        return '';
    }
  }

  Widget _buildLocationStep(UserInfoController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF26A69A).withOpacity(0.1),
                  const Color(0xFF4DB6AC).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF26A69A).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF26A69A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'We use your location to show events near you',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Location Picker Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Your Location',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                CountryStateCityPicker(
                  country: controller.countryController,
                  state: controller.stateController,
                  city: controller.cityController,
                  dialogColor: Colors.grey[100],
                  textFieldDecoration: InputDecoration(
                    fillColor: Colors.grey[50],
                    filled: true,
                    suffixIcon: Icon(
                      Icons.arrow_drop_down_circle,
                      color: const Color(0xFF9C27B0).withOpacity(0.7),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Color(0xFF9C27B0),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Selected Location Preview
          Obx(() {
            if (controller.selectedCountry.value.isNotEmpty) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF26A69A), Color(0xFF4DB6AC)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF26A69A).withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Location',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${controller.selectedCity.value}, ${controller.selectedState.value}',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            controller.selectedCountry.value,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildInterestsStep(UserInfoController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selection Counter - Changed minimum to 0
          Obx(() => Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: controller.selectedInterests.isEmpty
                    ? [Colors.grey[100]!, Colors.grey[200]!]
                    : controller.selectedInterests.length >= 0
                    ? [const Color(0xFF66BB6A), const Color(0xFF81C784)]
                    : [Colors.orange[100]!, Colors.orange[200]!],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: controller.selectedInterests.length >= 0
                  ? [
                BoxShadow(
                  color: const Color(0xFF66BB6A).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  controller.selectedInterests.isEmpty
                      ? Icons.touch_app
                      : controller.selectedInterests.length >= 1
                      ? Icons.check_circle
                      : Icons.info_outline,
                  color: controller.selectedInterests.isEmpty
                      ? Colors.grey[600]
                      : controller.selectedInterests.length >= 1
                      ? Colors.white
                      : Colors.orange[800],
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  controller.selectedInterests.isEmpty
                      ? 'Select at least 1 interests'
                      : controller.selectedInterests.length >= 1
                      ? '${controller.selectedInterests.length} interests selected ✓'
                      : '${controller.selectedInterests.length}/ interests selected',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: controller.selectedInterests.isEmpty
                        ? Colors.grey[700]
                        : controller.selectedInterests.length >= 0
                        ? Colors.white
                        : Colors.orange[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )),

          const SizedBox(height: 20),

          // Interests Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 2.1,
            ),
            itemCount: controller.interests.length,
            itemBuilder: (context, index) {
              final interest = controller.interests[index];

              return Obx(() {
                final isSelected =
                controller.selectedInterests.contains(interest['name']);

                return GestureDetector(
                  onTap: () => controller.toggleInterest(interest['name']),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(int.parse(interest['color'])),
                          Color(int.parse(interest['color']))
                              .withOpacity(0.8),
                        ],
                      )
                          : null,
                      color: isSelected ? null : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : Colors.grey[300]!,
                        width: isSelected ? 0 : 1.5,
                      ),
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: Color(int.parse(interest['color']))
                              .withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ]
                          : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                interest['icon'],
                                style: TextStyle(
                                  fontSize: 22,
                                  shadows: isSelected
                                      ? [
                                    const Shadow(
                                      blurRadius: 8,
                                      color: Colors.black26,
                                    ),
                                  ]
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  interest['name'],
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check,
                                color: Color(int.parse(interest['color'])),
                                size: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              });
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(UserInfoController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Obx(() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main Action Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.nextStep(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C27B0),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                shadowColor: const Color(0xFF9C27B0).withOpacity(0.4),
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.currentStep.value == 1
                        ? 'Complete Setup'
                        : 'Continue',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Secondary Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (controller.currentStep.value > 0)
                TextButton.icon(
                  onPressed: () => controller.previousStep(),
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: Text(
                    'Back',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[600],
                  ),
                ),
              if (controller.currentStep.value > 0)
                Container(
                  height: 20,
                  width: 1,
                  color: Colors.grey[300],
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
              TextButton(
                onPressed: () => controller.skipForNow(),
                child: Text(
                  'Skip for now',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}