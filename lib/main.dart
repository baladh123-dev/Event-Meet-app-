import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:screen_protector/screen_protector.dart';

import 'MyApp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  if (Platform.isAndroid || Platform.isIOS) {
    await ScreenProtector.preventScreenshotOn();
  }

  runApp(MyApp());
}
