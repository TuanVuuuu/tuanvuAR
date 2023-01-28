import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/src/components/loading/one_loading_shimer.dart';
import 'package:flutter_application_1/src/components/one_colors.dart';
import 'package:flutter_application_1/src/components/one_theme.dart';
import 'package:flutter_application_1/src/shared/app_scaffold.dart';
import 'package:flutter_application_1/src/widgets/one_news_widget/card_news.dart';
import 'package:flutter_application_1/src/widgets/one_news_widget/card_with_tags.dart';
import 'dart:math' as math;

import 'package:html_builder/elements.dart';

class TopNewsScreen extends StatefulWidget {
  const TopNewsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TopNewsScreen> createState() => _TopNewsScreenState();
}

class _TopNewsScreenState extends State<TopNewsScreen> {
  String tagsButton = "Tất cả";
  List dataList = [];
  List<String> tagsButtonList = [];
  List<String> docIds = [];
  bool _delayCheck = false;

  void delay() {
    Future.delayed(const Duration(milliseconds: 1000), (() {
      if (_delayCheck != true) {
        if (mounted) {
          setState(() {
            _delayCheck = true;
          });
        }
      }
    }));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    delay();
    final CollectionReference data = FirebaseFirestore.instance.collection("homedata");
    List result = Set.of(tagsButtonList).toList();
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
        backgroundColor: Colors.white,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg/bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Scrollbar(
              child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
              // _buildTopNews(context, result),
              SliverToBoxAdapter(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 80, bottom: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              child: StreamBuilder(
                                  stream: data.snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      const Center(child: CircularProgressIndicator(color: Colors.blue));
                                    }
                                    if (snapshot.hasData) {
                                      return ListView.builder(
                                        physics: const BouncingScrollPhysics(parent: BouncingScrollPhysics()),
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemCount: snapshot.data?.docs.length,
                                        itemBuilder: (context, index) {
                                          final DocumentSnapshot records = snapshot.data!.docs[index];
                                          return Padding(
                                              padding: EdgeInsets.zero,
                                              child: (() {
                                                for (int i = 0; i < records["tags"].length; i++) {
                                                  if (result.isEmpty && dataList != []) {
                                                    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
                                                          tagsButtonList.add(records["tags"][i]);
                                                          dataList.add(records["title"]);
                                                        }));
                                                  }
                                                }

                                                return Container();
                                              })());
                                        },
                                      );
                                    }

                                    return Container();
                                  }),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Có thể bạn chưa biết!",
                            style: OneTheme.of(context).header.copyWith(color: OneColors.white),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              tagsButtonView("Tất cả"),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  //width: MediaQuery.of(context).size.height -40,
                                  height: 40,
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(parent: BouncingScrollPhysics()),
                                    itemCount: result.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          tagsButtonView(result[index]),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                            ],
                          ),
                        ),

                        //Text(textHolder),
                        tagsButton != "Tất cả"
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Bạn đang tìm kiếm với từ khoá : ',
                                    style: DefaultTextStyle.of(context).style.copyWith(color: OneColors.white),
                                    children: <TextSpan>[
                                      TextSpan(text: tagsButton, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                                    ],
                                  ),
                                ))
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),

              if (_delayCheck != true)
                const SliverToBoxAdapter(
                  child: OneLoadingShimmer(
                    itemCount: 5,
                  ),
                )
              else
                tagsButton != "Tất cả"
                    ? CardNewsWithTags(data: data, tagsButton: tagsButton)
                    : CardNews(
                        data: data,
                      )
            ],
          )),
        ));
  }

  Widget tagsButtonView(String label) {
    return InkWell(
      onTap: (() {
        setState(() {
          tagsButton = label;
        });
      }),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.blue.shade100),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
              alignment: Alignment.center,
              child: Text(
                label,
                style: const TextStyle(color: OneColors.brandVNP),
              )),
        ),
      ),
    );

    // Padding(
    //   padding: const EdgeInsets.only(right: 8),
    //   child: Align(
    //     alignment: Alignment.centerLeft,
    //     child: OneButton(
    //       onPressed: () {
    //         setState(() {
    //           tagsButton = label;
    //         });
    //       },
    //       label: label,
    //       color: Colors.blue,
    //       borderRadius: BorderRadius.all(Radius.circular(20)),
    //     ),
    //   ),
    // );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}
