import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matrimony/Routes/controller.dart' as di;
import 'package:matrimony/Routes/viwes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: di.MyBindings(),
      debugShowCheckedModeBanner: false,
      getPages: Routes.routes,
      initialRoute:'/',
    );
  }
}
