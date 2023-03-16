// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_null_comparison, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/shared/firestore_helper.dart';
import 'package:flutter_application_1/src/widgets/build_footer.dart';
import 'package:flutter_application_1/src/widgets/one_news_widget/card_with_tags.dart';
import 'package:flutter_application_1/ui/pages/discovery_screen/discovery_detail_screen.dart';
import 'package:flutter_application_1/ui/pages/search_tags_screen/search_tags_screen.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DetailNewsScreen extends StatefulWidget {
  DetailNewsScreen({
    Key? key,
    required this.argument,
    this.viewscheck,
  }) : super(key: key);

  final argument;
  bool? viewscheck;

  @override
  State<DetailNewsScreen> createState() => _DetailNewsScreenState();
}

class _DetailNewsScreenState extends State<DetailNewsScreen> {
  final CollectionReference homedata = FirebaseFirestore.instance.collection("homedata");
  final List list = [];

  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _discoverDataList = [];
  List<Map<String, dynamic>> _planetsDataList = [];
  @override
  void initState() {
    super.initState();
    getDiscoverData().then((discoverData) {
      setState(() {
        _discoverDataList = discoverData;
      });
    });
    getPlanetsData().then((planetsData) {
      setState(() {
        _planetsDataList = planetsData;
      });
    });
    if (widget.viewscheck != false) {
      // Lấy số lượt xem hiện tại
      int views = widget.argument["views"] ?? 0;

      // Tăng giá trị số lượt xem lên 1
      widget.argument.reference.update({"views": views + 1});
    }
  }

  @override
  Widget build(BuildContext context) {
    List contentList = widget.argument["content"];

    Timestamp time = widget.argument["date"];
    var dateFormat = DateFormat.yMMMMd('en_US').add_jm().format(DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch));

    return AppScaffold(
      floatingActionButton: OneFloatToTop(scrollController: _scrollController),
      body: Scrollbar(
          child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          //Build Header
          _buildHeader(context),
          //Content
          SliverToBoxAdapter(
            child: Column(children: [
              // Build title
              _buildTitle(context),
              // Build Tags
              _buildTags(),
              // Build date
              _buildDate(dateFormat, context),
              //
              _buildTitleSmall(context),

              _buildTitleGuild(context),
              //Nội dung
              _buildContents(contentList, context),

              // Nguồn
              _buildAuthor(context, dateFormat),
              //Có thể bạn sẽ thích nó
              _buildLikes(context),
              //
            ]),
          ),
          CardNewsWithTags(
            cardLength: 2,
            checkindexRandom: true,
            data: homedata,
            tagsButton: 'Tất cả',
          ),

          const SliverToBoxAdapter(child: BuildFooter())
        ],
      )),
    );
  }

  Padding _buildContents(List<dynamic> contentList, BuildContext context) {
    // double sizeHeight = MediaQuery.of(context).size.height;
    // double sizeWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Container(
        alignment: Alignment.topLeft,
        child: Column(
          children: contentList.map((e) {
            String tagscheck = e["tags"];

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // build caption
                _buildCaption(e, context),
                // build contents
                _buildContentOne(e, context),
                // build image
                e["images"]["imageUrl"] != "" ? _buildImage(e, context) : const SizedBox(),
                // build contents more
                _buildContentMore(e, context),

                _buildDiscoverDataList(tagscheck),
                _buildPlanetsDataList(tagscheck)
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Padding _buildCaption(e, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        "${e["caption"]}",
        style: OneTheme.of(context).caption1.copyWith(color: OneColors.black, fontSize: 16),
      ),
    );
  }

  Column _buildContentOne(e, BuildContext context) {
    return Column(
      children: e["contents"]
          .map((contents) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  contents,
                  style: OneTheme.of(context).body2.copyWith(color: OneColors.black, fontSize: 14, height: 1.5),
                  textAlign: TextAlign.justify,
                ),
              ],
            );
          })
          .toList()
          .cast<Widget>(),
    );
  }

  Padding _buildImage(e, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(e["images"]["imageUrl"]),
          const SizedBox(height: 3),
          Text(
            e["images"]["imageNotes"],
            style: OneTheme.of(context).body2.copyWith(color: OneColors.black, fontSize: 12),
          ),
          const SizedBox(height: 3),
          e["images"]["imageCredit"] != ""
              ? Text(
                  "Nguồn: ${e["images"]["imageCredit"]}",
                  style: OneTheme.of(context).body2.copyWith(color: OneColors.black, fontSize: 10),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Column _buildContentMore(e, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: e["contentsMore"]
          .map((contentsMore) {
            return Column(
              children: [
                Text(
                  contentsMore,
                  style: OneTheme.of(context).body2.copyWith(color: OneColors.black, fontSize: 14, height: 1.5),
                  textAlign: TextAlign.justify,
                ),
              ],
            );
          })
          .toList()
          .cast<Widget>(),
    );
  }

  SizedBox _buildPlanetsDataList(String tagscheck) {
    return SizedBox(
      child: Column(
        children: [
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _planetsDataList.length,
              itemBuilder: (context, index) {
                var data = _planetsDataList[index];
                String idName = data["idName"];
                String url = data["image2D"]["imageUrl"];
                String name = data["name"];
                String info = data["info"];
                return (idName == tagscheck)
                    ? InkWell(
                        onTap: () {
                          Get.to(
                              () => PlanetDetailScreen(
                                    argument: data,
                                  ),
                              curve: Curves.linear,
                              transition: Transition.rightToLeft);
                        },
                        child: Container(
                            decoration: BoxDecoration(color: OneColors.white, borderRadius: BorderRadius.circular(15), boxShadow: const [
                              BoxShadow(
                                color: OneColors.grey,
                                blurRadius: 4,
                              )
                            ]),
                            height: 110,
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 80,
                                      child: CachedImage(
                                        imageUrl: url,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        name,
                                        style: OneTheme.of(context).body1.copyWith(color: OneColors.black),
                                      ),
                                      Text(
                                        info,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: OneTheme.of(context).body2.copyWith(color: OneColors.black),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )),
                      )
                    : const SizedBox();
              }
              // Loại bỏ phần tử null

              ),
        ],
      ),
    );
  }

  SizedBox _buildDiscoverDataList(String tagscheck) {
    return SizedBox(
      child: Column(
        children: [
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: _discoverDataList.length,
            itemBuilder: (context, index) {
              var data = _discoverDataList[index];
              String idnew = data["idnew"];
              String url = data["images"]["image2DUrl"];
              String name = data["name"];
              String info = data["info"];
              return (idnew == tagscheck)
                  ? InkWell(
                      onTap: () {
                        Get.to(
                            () => DiscoveryDetailScreen(
                                  argument: data,
                                  color: OneColors.white,
                                ),
                            curve: Curves.linear,
                            transition: Transition.rightToLeft);
                      },
                      child: Container(
                          decoration: BoxDecoration(color: OneColors.white, borderRadius: BorderRadius.circular(15), boxShadow: const [
                            BoxShadow(
                              color: OneColors.grey,
                              blurRadius: 4,
                            )
                          ]),
                          height: 110,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 80,
                                    child: CachedImage(
                                      imageUrl: url,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      name,
                                      style: OneTheme.of(context).body1.copyWith(color: OneColors.black),
                                    ),
                                    Text(
                                      info,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: OneTheme.of(context).body2.copyWith(color: OneColors.black),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )),
                    )
                  : const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  Padding _buildTitleSmall(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 20, right: 20),
      child: Text(
        widget.argument["title"],
        style: OneTheme.of(context).body2.copyWith(fontSize: 16, color: OneColors.black),
      ),
    );
  }

  Padding _buildTitleGuild(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 20, right: 20),
      child: Text(
        widget.argument["guideTitle"],
        style: OneTheme.of(context).body2.copyWith(fontSize: 16, color: OneColors.black),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
  ) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.08,
      leading: const SizedBox(),
      floating: false,
      pinned: true,
      backgroundColor: OneColors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.05,
            left: 20,
            right: 20,
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.arrow_back_ios, color: OneColors.black),
                const SizedBox(width: 10),
                Text("Trở về", style: OneTheme.of(context).body1.copyWith(color: OneColors.black)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildLikes(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Có thể bạn sẽ thích :",
              style: OneTheme.of(context).title1.copyWith(height: 2, color: OneColors.greyLight, fontStyle: FontStyle.normal),
            ),
          ),
          const Expanded(child: OneThickNess())
        ],
      ),
    );
  }

  Padding _buildDate(String dateFormat, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Được cập nhật vào $dateFormat",
            style: OneTheme.of(context).body2.copyWith(color: OneColors.black),
          )),
    );
  }

  Padding _buildAuthor(BuildContext context, String dateFormat) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Được đăng tải bởi : ${widget.argument["author"]}",
              style: OneTheme.of(context).title2.copyWith(color: OneColors.black, fontStyle: FontStyle.italic),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              dateFormat,
              style: OneTheme.of(context).body2.copyWith(color: OneColors.black, fontStyle: FontStyle.normal),
            ),
          ),
        ],
      ),
    );
  }

  Row _buildTags() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24.0),
          child: SizedBox(
            height: 50,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.argument["tags"].length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: (() {
                    String tagsSearch = (widget.argument["tags"][index]);

                    setState(() {
                      if (list.isEmpty) {
                        list.add(tagsSearch);
                      } else if (list.isNotEmpty) {
                        list.clear();
                        list.add(tagsSearch);
                      }
                    });

                    Get.to(() => MySearch(list: list), curve: Curves.linear, transition: Transition.rightToLeft);
                  }),
                  child: Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: OneColors.blue100),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.argument["tags"][index],
                            style: const TextStyle(color: OneColors.brandVNP),
                          )),
                    ),
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }

  Padding _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 23, right: 23),
      child: Text(
        widget.argument["title"],
        style: OneTheme.of(context).header.copyWith(fontSize: 26, color: OneColors.black),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
