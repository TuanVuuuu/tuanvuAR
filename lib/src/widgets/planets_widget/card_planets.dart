import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/components/loading/one_loading.dart';
import 'package:flutter_application_1/src/shared/contant.dart';
import 'package:get/get.dart';

class CardPlanets extends StatelessWidget {
  const CardPlanets({
    Key? key,
    required this.data,
    this.cardLength,
    this.currentPlanets,
    this.titleColor,
  }) : super(key: key);

  final CollectionReference<Object?> data;
  final int? cardLength;
  final String? currentPlanets;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    AppContants.init(context);
    return SizedBox(
      height: AppContants.sizeHeight * 0.25,
      child: Row(
        children: [
          StreamBuilder(
            stream: data.snapshots(),
            builder: ((context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                Center(child: OneLoading.space_loading);
              }

              if (snapshot.hasData) {
                return SizedBox(
                  width: AppContants.sizeWidth,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: cardLength ?? snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot records = snapshot.data.docs[index];
                      String idname = records["idName"];
                      String imageUrl = records["image2D"]["imageUrl"];

                      return InkWell(
                          onTap: () {
                            Get.to(() => PlanetDetailScreen(argument: records), curve: Curves.linear, transition: Transition.rightToLeft, duration: const Duration(milliseconds: 200));
                          },
                          child: currentPlanets != idname
                              ? Padding(
                                  padding: EdgeInsets.symmetric(horizontal: (AppContants.sizeWidth - 300) / 10, vertical: 10),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(color: OneColors.white, borderRadius: BorderRadius.circular(10), boxShadow: const [
                                          BoxShadow(
                                            color: OneColors.grey,
                                            blurRadius: 4,
                                          )
                                        ]),
                                        height: 75,
                                        width: 75,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CachedImage(imageUrl: imageUrl),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Text(
                                          records["name"],
                                          maxLines: 2,
                                          style: OneTheme.of(context).body1.copyWith(color: titleColor ?? OneColors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox());
                    },
                  ),
                );
              }
              return Center(child: OneLoading.space_loading);
            }),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
