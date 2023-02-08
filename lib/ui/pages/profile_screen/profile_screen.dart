// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/src/components/one_images.dart';
import 'package:flutter_application_1/src/components/shared/add_data_discover.dart';
import 'package:flutter_application_1/src/components/shared/add_planets_data.dart';
import 'package:flutter_application_1/src/shared/app_scaffold.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

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
          image: AssetImage(OneImages.bg3),
          fit: BoxFit.cover,
        ),
      ),
      child: Scrollbar(
          child: CustomScrollView(
        //physics: const BouncingScrollPhysics(parent: ),
        slivers: <Widget>[
          _buildAddData(context)
        ],
      )),
    ));
  }

  SliverToBoxAdapter _buildAddData(BuildContext context) {
    return SliverToBoxAdapter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
              ),
              ElevatedButton(
                  onPressed: () {
                    Get.to(() => const AddDiscoverData());
                  },
                  child: const Text("Add data discover")),
              ElevatedButton(
                  onPressed: () {
                    Get.to(() => const AddPlanetsData());
                  },
                  child: const Text("Add data planets")),
            ],
          ),
        );
  }
}
