import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/src/components/one_colors.dart';
import 'package:flutter_application_1/src/components/one_theme.dart';
import 'package:flutter_application_1/src/shared/app_scaffold.dart';
import 'package:flutter_application_1/src/widgets/build_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String tagsButton = "";

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
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
        body: Scrollbar(
            child: CustomScrollView(
      //physics: const BouncingScrollPhysics(parent: ),
      slivers: <Widget>[
        BuildHeader(
          context: context,
          title_header: "Profile",
          icon_header: const Icon(
            Icons.person,
            color: Colors.blue,
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 100,
          ),
        ),
        SliverToBoxAdapter(
            child: // Figma Flutter Generator Group92Widget - GROUP
                cardImages(sizeHeight: sizeHeight, sizeWidth: sizeWidth))
      ],
    )));
  }
}

class cardImages extends StatelessWidget {
  const cardImages({
    super.key,
    required this.sizeHeight,
    required this.sizeWidth,
  });

  final double sizeHeight;
  final double sizeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        //color: OneColors.red,
        height: sizeHeight * 0.12,
        child: Stack(children: <Widget>[
          SizedBox(
              width: sizeWidth,
              child: Stack(children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF081C2D),
                      Color(0xFF0A3A5C),
                      Color(0xFF0C5B8D),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.only(top : 0.0),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: const DecorationImage(image: AssetImage('assets/images/robot.png'), fit: BoxFit.fitWidth),
                      )),
                ),
              ])),
        ]));
  }
}
