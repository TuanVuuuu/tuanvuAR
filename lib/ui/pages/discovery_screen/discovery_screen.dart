import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/src/components/loading/one_loading_shimer.dart';
import 'package:flutter_application_1/src/components/one_colors.dart';
import 'package:flutter_application_1/src/components/one_images.dart';
import 'package:flutter_application_1/src/components/one_theme.dart';
import 'package:flutter_application_1/src/shared/app_scaffold.dart';
import 'package:flutter_application_1/ui/pages/discovery_screen/discovery_detail_screen.dart';
import 'package:flutter_application_1/ui/views/discovery_header.dart';
import 'package:get/get.dart';

class DiscoveryScreen extends StatelessWidget {
  DiscoveryScreen({
    Key? key,
  }) : super(key: key);

  final CollectionReference discoverydata = FirebaseFirestore.instance.collection("discoverdata");

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: OneColors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent, // Color for Android
        statusBarBrightness: Brightness.light, // Dark == white status bar -- for IOS.
      ),
    );

    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
    List colors = [
      const Color.fromARGB(255, 250, 182, 123),
      const Color.fromARGB(255, 205, 248, 126),
      const Color.fromARGB(255, 240, 143, 150),
      const Color.fromARGB(255, 240, 138, 172),
      const Color.fromARGB(255, 152, 243, 141),
      const Color.fromARGB(255, 147, 145, 248),
      const Color.fromARGB(255, 247, 165, 229),
      const Color.fromARGB(255, 237, 243, 151),
      const Color.fromARGB(255, 194, 138, 240),
      const Color.fromARGB(255, 197, 165, 247),
    ];
    Random random = Random();

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
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: <Widget>[
          const BuildDiscoveryHeader(
            title: "Các vì sao",
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        child: StreamBuilder(
                            stream: discoverydata.snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                const Center(
                                    child: OneLoadingShimmer(
                                  itemCount: 5,
                                ));
                              }
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data?.docs.length,
                                  itemBuilder: (context, index) {
                                    final DocumentSnapshot records = snapshot.data!.docs[index];
                                    String? name = records["name"];
                                    String? image2DUrl = records["images"]["image2DUrl"];
                                    String? info = records["info"];
                                    List tags = records["tags"];
                                    int indexRandom = random.nextInt(colors.length);

                                    return InkWell(
                                      onTap: () {
                                        Get.to(
                                            () => DiscoveryDetailScreen(
                                                  argument: records,
                                                  color: colors[indexRandom],
                                                ),
                                            curve: Curves.linear,
                                            transition: Transition.rightToLeft);
                                      },
                                      child: Container(
                                          margin: const EdgeInsets.symmetric(vertical: 10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: sizeHeight * 0.16,
                                                width: sizeWidth - 40,
                                                decoration: BoxDecoration(color: colors[indexRandom].withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                                                child: Container(
                                                  margin: const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                                                  child: DottedBorder(
                                                    color: OneColors.transparent,
                                                    strokeWidth: 1,
                                                    borderType: BorderType.RRect,
                                                    radius: const Radius.circular(15),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              // Tên ngôi sao
                                                              Align(
                                                                alignment: Alignment.centerLeft,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(left: 5.0),
                                                                  child: Text(
                                                                    "$name",
                                                                    style: OneTheme.of(context).caption1.copyWith(color: OneColors.black, fontSize: 10, fontWeight: FontWeight.w700),
                                                                  ),
                                                                ),
                                                              ),
                                                              // thông tin ngôi sao
                                                              Center(
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(5.0),
                                                                  child: Text(
                                                                    "$info",
                                                                    style: OneTheme.of(context).caption1.copyWith(
                                                                          color: OneColors.black,
                                                                          fontSize: 10,
                                                                          fontWeight: FontWeight.w400,
                                                                        ),
                                                                    maxLines: 5,
                                                                    textAlign: TextAlign.justify,
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                ),
                                                              ),
                                                              // tags
                                                              Row(
                                                                  children: tags.map((i) {
                                                                return Container(
                                                                  margin: const EdgeInsets.only(left: 5),
                                                                  height: 20,
                                                                  decoration: BoxDecoration(color: OneColors.brandVNP.withOpacity(0.4), borderRadius: BorderRadius.circular(5)),
                                                                  child: Align(
                                                                    alignment: Alignment.center,
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                                      child: Text(
                                                                        i,
                                                                        style: OneTheme.of(context).body1.copyWith(color: OneColors.white, fontSize: 10),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }).toList()),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 8.0),
                                                            child: DottedBorder(
                                                              color: OneColors.black,
                                                              strokeWidth: 0.05,
                                                              borderType: BorderType.RRect,
                                                              child: SizedBox(
                                                                height: sizeHeight * 0.12,
                                                                child: Image.network(image2DUrl ?? ""),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // Hình ảnh ngôi sao

                                              // Text(
                                              //   name ?? "",
                                              //   style: OneTheme.of(context).header.copyWith(color: OneColors.white),
                                              // ),
                                            ],
                                          )),
                                    );
                                  },
                                );
                              }

                              return Container();
                            }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      )),
    ));
  }
}
