// ignore_for_file: must_be_immutable, use_build_context_synchronously, library_private_types_in_public_api

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/components/loading/one_loading.dart';
import 'package:flutter_application_1/src/widgets/one_news_widget/one_card_news_image.dart';
import 'package:flutter_application_1/ui/pages/news_screen/detail_news_screen.dart';
import 'package:intl/intl.dart';

class CardNewsWithTags extends StatefulWidget {
  CardNewsWithTags({
    Key? key,
    required this.data,
    required this.tagsButton,
    this.checktags,
    this.cardLength,
    this.checkindexRandom,
    this.style,
  }) : super(key: key);

  final CollectionReference<Object?> data;
  final String tagsButton;
  final bool? checktags;
  int? cardLength;
  bool? checkindexRandom;
  bool? style;

  @override
  _CardNewsWithTagsState createState() => _CardNewsWithTagsState();
}

class _CardNewsWithTagsState extends State<CardNewsWithTags> {
  List<DocumentSnapshot<Object?>>? _documents;
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    if (_isFetching) {
      _isFetching = false;
      // Huỷ quá trình fetch data
    }
    super.dispose();
  }

  Future<void> fetchData() async {
    _isFetching = true;
    final snapshot = await widget.data.get();
    if (!_isFetching) return; // Nếu fetch data đã bị huỷ thì không setState
    setState(() {
      _documents = snapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_documents != null) {
      _documents!.sort((a, b) => b["date"].compareTo(a["date"]));
      return SliverToBoxAdapter(
        child: Column(
          children: [
            ListView.builder(
              physics: const BouncingScrollPhysics(parent: BouncingScrollPhysics()),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: widget.cardLength ?? _documents!.length,
              itemBuilder: (context, index) {
                var indexRandom = Random().nextInt(_documents!.length);
                final DocumentSnapshot records = widget.checkindexRandom != true ? _documents![index] : _documents![indexRandom];
                Timestamp time = records["date"];
                var dateFormat = DateFormat.yMMMMd('en_US').add_jm().format(DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch));
                if (widget.checktags == true && !(records["tags"].any((tag) => tag == widget.tagsButton))) {
                  return const SizedBox();
                } else {
                  return _buildCardInfo(records, dateFormat, context);
                }
              },
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      );
    } else {
      return SliverToBoxAdapter(child: Center(child: OneLoading.space_loading_larget));
    }
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
          color: widget.style != true ? OneColors.black.withOpacity(0.5) : OneColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: (records["content"][0]["images"]["imageUrl"] != null && records["content"][0]["images"]["imageUrl"] != "")
            ? OneCardNewsImage(
                records: records,
                dateFormat: dateFormat,
                style: widget.style,
              )
            : OneCardNewsImage(
                records: records,
                dateFormat: dateFormat,
                checkimages: false,
                style: widget.style,
              ),
      ),
    );
  }
}
