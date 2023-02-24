// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/widgets/one_news_widget/one_card_news_image.dart';
import 'package:flutter_application_1/ui/pages/news_screen/detail_news_screen.dart';
import 'package:intl/intl.dart';

class CardNewsWithTags extends StatelessWidget {
  CardNewsWithTags({
    Key? key,
    required this.data,
    required this.tagsButton,
    this.checktags,
    this.cardLength,
    this.checkindexRandom,
  }) : super(key: key);

  final CollectionReference<Object?> data;
  final String tagsButton;
  final bool? checktags;
  int? cardLength;
  bool? checkindexRandom;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          FutureBuilder(
            future: data.get(), // Sử dụng phương thức get()
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: OneLoadingShimmer(
                    itemCount: 5,
                  ),
                );
              } else if (snapshot.hasData) {
                List<DocumentSnapshot<Object?>> documents = snapshot.data!.docs;
                documents.sort((a, b) => b["date"].compareTo(a["date"]));
                return ListView.builder(
                  physics: const BouncingScrollPhysics(parent: BouncingScrollPhysics()),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: cardLength ?? documents.length,
                  itemBuilder: (context, index) {
                    var indexRandom = Random().nextInt(documents.length);
                    final DocumentSnapshot records = checkindexRandom != true ? documents[index] : documents[indexRandom];
                    Timestamp time = records["date"];
                    var dateFormat = DateFormat.yMMMMd('en_US').add_jm().format(DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch));
                    if (checktags == true && !(records["tags"].any((tag) => tag == tagsButton))) {
                      return const SizedBox();
                    } else {
                      return _buildCardInfo(records, dateFormat, context);
                    }
                  },
                );
              }
              return const Center(
                child: OneLoadingShimmer(
                  itemCount: 5,
                ),
              );
            },
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  InkWell _buildCardInfo(DocumentSnapshot<Object?> records, String dateFormat, BuildContext context) {
    return InkWell(
      onTap: (() {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(animation),
                child: child,
              );
            },
            pageBuilder: (context, animation, secondaryAnimation) => DetailNewsScreen(
              argument: records,
            ),
          ),
        );
      }),
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
        decoration: BoxDecoration(
          color: OneColors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(7),
        ),
        child: (records["content"][0]["images"]["imageUrl"] != null && records["content"][0]["images"]["imageUrl"] != "")
            ? OneCardNewsImage(records: records, dateFormat: dateFormat)
            : OneCardNewsImage(
                records: records,
                dateFormat: dateFormat,
                checkimages: false,
              ),
      ),
    );
  }
}
