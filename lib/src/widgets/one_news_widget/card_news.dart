import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/components/loading/one_loading_shimer.dart';
import 'package:flutter_application_1/src/components/one_card.dart';
import 'package:flutter_application_1/src/components/one_colors.dart';
import 'package:flutter_application_1/src/widgets/one_news_widget/one_card_news_image.dart';
import 'package:flutter_application_1/src/widgets/one_news_widget/one_card_news_no_image.dart';
import 'package:flutter_application_1/ui/pages/news_screen/detail_news_screen.dart';
import 'package:intl/intl.dart';

class CardNews extends StatelessWidget {
  const CardNews({
    Key? key,
    required this.data,
    this.cardLength,
  }) : super(key: key);

  final CollectionReference<Object?> data;
  final int? cardLength;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          StreamBuilder(
            stream: data.snapshots(),
            builder: ((context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                const Center(
                  child: OneLoadingShimmer(
                    itemCount: 5,
                  ),
                );
              }

              if (snapshot.hasData) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(parent: BouncingScrollPhysics()),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: cardLength ?? snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot records = snapshot.data.docs[snapshot.data?.docs.length - index - 1];
                    Timestamp time = records["date"];
                    var dateFormat = DateFormat.yMMMMd('en_US').add_jm().format(DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch));
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: InkWell(
                        onTap: (() => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => DetailNewsScreen(argument: records)),
                            ))),
                        child: OneCard(
                          color: OneColors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(7),
                          child: (records["content"][0]["images"]["imageUrl"] != null && records["content"][0]["images"]["imageUrl"] != "")
                              ? OneCardNewsImage(records: records, dateFormat: dateFormat)
                              : OneCardNewsNoImage(records: records, dateFormat: dateFormat),
                        ),
                      ),
                    );
                  },
                );
              }
              return const Center(child: OneLoadingShimmer(
                                        itemCount: 5,
                                      ));
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
