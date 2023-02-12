import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/components/loading/one_cache_images.dart';
import 'package:flutter_application_1/src/components/one_colors.dart';
import 'package:flutter_application_1/src/components/one_theme.dart';
import 'package:flutter_application_1/src/models/one_list_colors.dart';
import 'package:flutter_application_1/ui/pages/discovery_screen/discovery_detail_screen.dart';
import 'package:get/get.dart';

class CardDiscoverPlanets extends StatelessWidget {
  const CardDiscoverPlanets({
    super.key,
    required this.records,
    required this.indexRandom,
    required this.sizeHeight,
    required this.sizeWidth,
    required this.name,
    required this.info,
    required this.tags,
    required this.image2DUrl,
  });

  final DocumentSnapshot<Object?> records;
  final int indexRandom;
  final double sizeHeight;
  final double sizeWidth;
  final String? name;
  final String? info;
  final List tags;
  final String? image2DUrl;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(
            () => DiscoveryDetailScreen(
                  argument: records,
                  color: OneColorRamdom.colors[indexRandom],
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
                decoration: BoxDecoration(color: OneColorRamdom.colors[indexRandom].withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
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
                                child: CachedImage(imageUrl: image2DUrl ?? ""),
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
  }
}
