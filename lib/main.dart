// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

import 'src/components/shared/theme/custom_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  InitialBinding().dependencies();
  await Firebase.initializeApp();
  await Permission.camera.request();
  await Permission.microphone.request();
  // await FlutterDownloader.initialize();
  // FlutterDownloader.registerCallback(downloadCallback);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('assets/images/bg/bg5.png'), context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      navigatorKey: AppRouteExt.navigatorKey,
      key: key,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('vi', 'VI'),
        Locale.fromSubtags(languageCode: 'vi'),
      ],
      theme: CustomTheme.fromContext(context).appTheme,
      initialRoute: AppRoutes.SPLASH_SCREEN.name,
      onGenerateRoute: AppRouteExt.bindingRoute,
      initialBinding: AppBinding(),
    );
  }
}

class AppBinding extends Bindings {
  @override
  void dependencies() {
    injectService();
  }

  void injectService() {}
}
