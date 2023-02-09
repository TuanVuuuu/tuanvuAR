import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/components/loading/one_cache_images.dart';
import 'package:flutter_application_1/src/components/one_colors.dart';
import 'package:flutter_application_1/src/components/one_theme.dart';
import 'package:get/get.dart';

class CardPlanets extends StatelessWidget {
  const CardPlanets({
    Key? key,
    required this.data,
    this.cardLength,
    this.currentPlanets,
  }) : super(key: key);

  final CollectionReference<Object?> data;
  final int? cardLength;
  final String? currentPlanets;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.25,
      child: Row(
        children: [
          StreamBuilder(
            stream: data.snapshots(),
            builder: ((context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasData) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(parent: BouncingScrollPhysics()),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: cardLength ?? snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot records = snapshot.data.docs[snapshot.data?.docs.length - index - 1];
                    String idname = records["idName"];
                    String imageUrl = records["image2D"]["imageUrl"];

                    return InkWell(
                        onTap: () {
                          Get.to(() => PlanetDetailScreen(argument: records), curve: Curves.linear, transition: Transition.rightToLeft, duration: const Duration(milliseconds: 200));
                        },
                        child: currentPlanets != idname
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(color: OneColors.black.withOpacity(0.4), borderRadius: BorderRadius.circular(10)),
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
                                        style: OneTheme.of(context).body1.copyWith(color: OneColors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox());
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
