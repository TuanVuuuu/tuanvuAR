import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/widgets/one_news_widget/one_card_news_image.dart';
import 'package:flutter_application_1/src/widgets/one_news_widget/one_card_news_no_image.dart';
import 'package:flutter_application_1/ui/pages/news_screen/detail_news_screen.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CardNewsWithTags extends StatelessWidget {
  const CardNewsWithTags({
    Key? key,
    required this.data,
    required this.tagsButton,
  }) : super(key: key);

  final CollectionReference<Object?> data;
  final String tagsButton;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          StreamBuilder(
            stream: data.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                const Center(
                    child: OneLoadingShimmer(
                  itemCount: 5,
                ));
              }
              if (snapshot.hasData) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(parent: BouncingScrollPhysics()),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    int indexRev = snapshot.data!.docs.length - index - 1;
                    final DocumentSnapshot records = snapshot.data!.docs[indexRev];
                    Timestamp time = records["date"];
                    var dateFormat = DateFormat.yMMMMd('en_US').add_jm().format(DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch));
                    return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        child: (() {
                          for (int i = 0; i < records["tags"].length; i++) {
                            if (records["tags"][i] == tagsButton) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: InkWell(
                                  onTap: (() => Get.to(() => DetailNewsScreen(argument: records), curve: Curves.linear, transition: Transition.rightToLeft)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: OneColors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: (records["content"][0]["images"]["imageUrl"] != null && records["content"][0]["images"]["imageUrl"] != "")
                                        ? OneCardNewsImage(records: records, dateFormat: dateFormat)
                                        : OneCardNewsNoImage(records: records, dateFormat: dateFormat),
                                  ),
                                ),
                              );
                            } else {}
                          }
                          {}
                        })());
                  },
                );
              }
              return const Center(
                  child: OneLoadingShimmer(
                itemCount: 5,
              ));
            },
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
