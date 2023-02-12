// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/shared/controller/app_routes.dart';
import 'package:flutter_application_1/src/shared/controller/initial_binding.dart';
import 'package:flutter_application_1/src/widgets/example/quizapp/quiz_screen/quiz_screen.dart';
import 'package:flutter_application_1/src/widgets/example/quizapp/result_screen/result_screen.dart';
import 'package:flutter_application_1/src/widgets/example/quizapp/welcome_screen.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  InitialBinding().dependencies();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize();
  FlutterDownloader.registerCallback(downloadCallback);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // home: SplashScreen(),
      initialRoute: AppRoutes.SPLASH_SCREEN.name,
      onGenerateRoute: AppRouteExt.bindingRoute,
    );
  }
}

void downloadCallback(String id, DownloadTaskStatus status, int progress) async {
  print('callback: ID = $id || status = $status || progress = $progress');
}
