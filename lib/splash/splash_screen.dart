// ignore_for_file: depend_on_referenced_packages, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/splash/splash_bg.dart';
import 'package:flutter_application_1/src/components/one_colors.dart';
import 'package:flutter_application_1/src/components/one_images.dart';
import 'package:flutter_application_1/src/components/one_theme.dart';
import 'package:flutter_application_1/ui/entryPoint/entry_point.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final CollectionReference modeldata = FirebaseFirestore.instance.collection("modeldata");
  final CollectionReference discoverdata = FirebaseFirestore.instance.collection("discoverdata");

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
    int seconds = 10;
    return Stack(
      children: [
        SizedBox(height: sizeHeight, width: sizeWidth, child: const SplashWidget()),
        Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    height: sizeHeight * 0.2,
                    width: sizeWidth * 0.7,
                    decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(OneImages.Astronomy))),
                  ),
                ),
                SizedBox(
                  height: sizeHeight * 0.2,
                  width: sizeWidth * 0.6,
                  child: Text(
                    "Bắt đầu hành trình khám phá vũ trụ cùng với Astronomy ngay nào !!",
                    style: OneTheme.of(context).header.copyWith(color: OneColors.white, height: 1.5, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Container(
                    height: sizeHeight * 0.3,
                    width: sizeWidth * 0.7,
                    decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(OneImages.telescope))),
                  ),
                ),
                Center(
                  child: SizedBox(
                    height: sizeHeight * 0.25,
                    width: sizeWidth * 0.9,
                    child: Lottie.network(
                      "https://assets2.lottiefiles.com/packages/lf20_qogkaqmb.json",
                      onLoaded: (p0) {
                        Future.delayed(Duration(seconds: seconds), (() {
                          Get.offAll(() => const EntryPoint(), curve: Curves.linear, duration: const Duration(seconds: 1));
                        }));
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            "Không có kết nối Internet\nVui lòng kiểm tra lại kết nối mạng!",
                            style: OneTheme.of(context).title1.copyWith(color: OneColors.white),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                      width: sizeWidth * 0.7,
                      child: LinearPercentIndicator(
                          animation: true,
                          animationDuration: seconds * 1000 + 2000,
                          lineHeight: 5,
                          percent: 1,
                          progressColor: OneColors.textOrange,
                          backgroundColor: OneColors.grey,
                          barRadius: const Radius.circular(15))),
                ),
                Column(
                  children: [
                    Container(
                      color: OneColors.transparent,
                      height: 0.5,
                      width: MediaQuery.of(context).size.width,
                      child: StreamBuilder(
                          stream: modeldata.snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {}
                            if (snapshot.hasData) {
                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: snapshot.data?.docs.length,
                                itemBuilder: (context, index) {
                                  final DocumentSnapshot records = snapshot.data!.docs[index];

                                  // Image colors
                                  var colors = records["image2D"]["colors"];
                                  String colorModel = colors["colorModel"];

                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10, left: 10),
                                    child: SizedBox(child: _buildImagePlanets2D(colorModel, records, records["image2D"]["imageUrl"])),
                                  );
                                },
                              );
                            }
                            return Container();
                          }),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      color: OneColors.transparent,
                      height: 0.5,
                      width: MediaQuery.of(context).size.width,
                      child: StreamBuilder(
                          stream: discoverdata.snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {}
                            if (snapshot.hasData) {
                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: snapshot.data?.docs.length,
                                itemBuilder: (context, index) {
                                  final DocumentSnapshot records = snapshot.data!.docs[index];

                                  // Image colors
                                  String image2DUrl = records["images"]["image2DUrl"];

                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      right: 10,
                                      left: 10,
                                    ),
                                    child: SizedBox(child: _buildImageDiscover2D(records, image2DUrl)),
                                  );
                                },
                              );
                            }
                            return Container();
                          }),
                    ),
                  ],
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildImageDiscover2D(DocumentSnapshot<Object?> records, String imageUrl) {
    return CircleAvatar(
      backgroundColor: OneColors.transparent,
      radius: 2,
      child: Image.network(imageUrl,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return const Center();
          },
          errorBuilder: (context, error, stackTrace) => Image.asset(OneImages.not_found)),
    );
  }

  Widget _buildImagePlanets2D(String colorModel, DocumentSnapshot<Object?> records, String imageUrl) {
    return CircleAvatar(
      backgroundColor: OneColors.transparent,
      radius: 2,
      child: Image.network(imageUrl,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return const Center();
          },
          errorBuilder: (context, error, stackTrace) => Image.asset(OneImages.not_found)),
    );
  }
}
