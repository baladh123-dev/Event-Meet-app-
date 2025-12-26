import 'package:get/get.dart';
import '../Nav_pages/ExpolaoreEvenList/EventsViewController.dart';
import '../Nav_pages/ExpolaoreEvenList/EventsViewScreen.dart';
import '../Nav_pages/MyEvents/CreateEvent/Create_Event_Controller.dart';
import '../Nav_pages/MyEvents/CreateEvent/Create_Event_viwe.dart';
import '../Nav_pages/MyEvents/MyEvents_Controller.dart';
import '../Nav_pages/MyEvents/MyEvents_viwe.dart';
import '../Nav_pages/Profile/Profile_Controller.dart';
import '../Nav_pages/Profile/Profile_viwe.dart';
import '../One_time_pages/Login/LoginController.dart';
import '../One_time_pages/Login/LoginView.dart';
import '../One_time_pages/UserInfo/UserInfoController.dart';
import '../One_time_pages/UserInfo/UserInfoScreen.dart';
import '../commanPages/No Internet/No Internet View.dart';
import '../commanPages/No Internet/No Internet.dart';
import '../commanPages/master_nav_view/Nav_Controller.dart';
import '../commanPages/master_nav_view/Nav_viwe.dart';
import '../commanPages/splash/splash_controller.dart';
import '../commanPages/splash/splash_view.dart';


class Routes {
  static final List<GetPage> routes = [
    GetPage(
        name: '/',
        page: () => SplashScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<SplashController>(() => SplashController());
        })),


    GetPage(
        name: '/Login',
        page: () => LoginScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<LoginController>(() => LoginController());
        })),



    GetPage(
        name: '/no-more-intrnet',
        page: () => NoInternetView(),
        binding: BindingsBuilder(() {
          Get.lazyPut<NoInternetController>(() => NoInternetController());
        })),




    GetPage(
        name: '/user-info',
        page: () => UserInfoScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<UserInfoController>(() => UserInfoController());
        })),


    GetPage(
        name: '/Nav',
        page: () => MasterNavView(),
        binding: BindingsBuilder(() {
          Get.lazyPut<BottomNavController>(() => BottomNavController());
        })),

    GetPage(
        name: '/Profile',
        page: () => ProfileScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<ProfileController>(() => ProfileController());
        })),

    GetPage(
        name: '/Create_event',
        page: () => CreateEventScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<CreateEventController>(() => CreateEventController());
        })),


    GetPage(
        name: '/View_event',
        page: () => EventsViewScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<EventsViewController>(() => EventsViewController());
        })),

    GetPage(
        name: '/My_Events',
        page: () => MyEventsScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<MyEventsController>(() => MyEventsController());
        })),

  ];
}