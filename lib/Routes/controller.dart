import 'package:get/get.dart';
import '../Nav_pages/MyEvents/CreateEvent/Create_Event_Controller.dart';
import '../Nav_pages/MyEvents/MyEvents_Controller.dart';
import '../Nav_pages/Profile/Profile_Controller.dart';
import '../One_time_pages/Login/LoginController.dart';
import '../One_time_pages/UserInfo/UserInfoController.dart';
import '../commanPages/No Internet/No Internet.dart';
import '../commanPages/master_nav_view/Nav_Controller.dart';
import '../commanPages/splash/splash_controller.dart';

class MyBindings extends Bindings {
  @override
  void dependencies() {
    // Eager initialization of DatePickerController
    Get.lazyPut<SplashController>(() => SplashController());
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<NoInternetController>(() => NoInternetController());
    Get.lazyPut<UserInfoController>(() => UserInfoController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<BottomNavController>(() => BottomNavController());
    Get.lazyPut<CreateEventController>(() => CreateEventController());
    Get.lazyPut<MyEventsController>(() => MyEventsController());
  }
}
