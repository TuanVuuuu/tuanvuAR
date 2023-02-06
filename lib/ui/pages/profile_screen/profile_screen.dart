import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/src/shared/app_scaffold.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String tagsButton = "";

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent, // Color for Android
        statusBarBrightness: Brightness.light, // Dark == white status bar -- for IOS.
      ),
    );
    return AppScaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg/bg3.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scrollbar(
          child: CustomScrollView(
        //physics: const BouncingScrollPhysics(parent: ),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(),
          )
        ],
      )),
    ));
  }
}
