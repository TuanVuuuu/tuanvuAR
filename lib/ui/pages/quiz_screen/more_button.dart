import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/components/loading/one_loading.dart';
import 'package:get/get.dart';

class MoreButton extends StatelessWidget {
  const MoreButton({
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
      height: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder(
            stream: data.snapshots(),
            builder: ((context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                Center(child: OneLoading.space_loading);
              }

              if (snapshot.hasData) {
                return ListView.builder(
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
                        child: currentPlanets == idname
                            ? Align(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    // Image
                                    _buildImage(imageUrl),
                                    //Name
                                    _buildName(records, context),
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
        ],
      ),
    );
  }

  Padding _buildName(DocumentSnapshot<Object?> records, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Text(
        records["name"],
        maxLines: 2,
        style: OneTheme.of(context).body1.copyWith(color: OneColors.white),
      ),
    );
  }

  Container _buildImage(String imageUrl) {
    return Container(
      decoration: BoxDecoration(color: OneColors.black.withOpacity(0.4), borderRadius: BorderRadius.circular(10)),
      height: 40,
      width: 40,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CachedImage(imageUrl: imageUrl),
      ),
    );
  }
}
