import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/components/one_card.dart';
import 'package:flutter_application_1/src/components/one_colors.dart';
import 'package:flutter_application_1/src/components/one_theme.dart';
import 'package:flutter_application_1/src/components/one_thick_ness.dart';
import 'package:flutter_application_1/src/shared/app_scaffold.dart';
import 'package:flutter_application_1/src/widgets/build_footer.dart';
import 'package:flutter_application_1/src/widgets/build_header.dart';
import 'package:flutter_application_1/src/widgets/one_news_widget/card_news.dart';
import 'package:flutter_application_1/ui/pages/search_tags_screen/search_tags_screen.dart';
import 'package:flutter_application_1/ui/views/sliver_appbar_delegate.dart';
import 'package:intl/intl.dart';

class DetailNewsScreen extends StatefulWidget {
  const DetailNewsScreen({
    Key? key,
    required this.argument,
  }) : super(key: key);

  final argument;

  @override
  State<DetailNewsScreen> createState() => _DetailNewsScreenState();
}

class _DetailNewsScreenState extends State<DetailNewsScreen> {
  final CollectionReference homedata = FirebaseFirestore.instance.collection("homedata");
  final List list = [];
  // contentList
  final List contentListCaption = [];
  final List contentListContents = [];
  final List contentsListMore = [];
  final List contentsListImage = [];

  @override
  Widget build(BuildContext context) {
    List contentList = widget.argument["content"];

    // Xoá bỏ phần tử trùng lặp
    Set.of(contentListCaption).toList();
    Set.of(contentListContents).toList();
    Set.of(contentsListMore).toList();
    Set.of(contentsListImage).toList();

    Timestamp time = widget.argument["date"];
    var dateFormat = DateFormat.yMMMMd('en_US').add_jm().format(DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch));
    return AppScaffold(
      backgroundColor: OneColors.black,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg/bg4.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scrollbar(
            child: CustomScrollView(
          slivers: [
            //Build Header
            _buildHeader(context),
            //Content
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // Build title
                  _buildTitle(context),
                  // Build Tags
                  _buildTags(),
                  // Build date
                  _buildDate(dateFormat, context),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 20, right: 20, bottom: 10),
                    child: Text(
                      widget.argument["title"],
                      style: OneTheme.of(context).body2.copyWith(fontSize: 16, color: OneColors.white),
                    ),
                  ),
                  //setState  Nội dung
                  Padding(
                      padding: EdgeInsets.zero,
                      child: (() {
                        for (int i = 0; i < widget.argument["content"].length; i++) {
                          String caption = contentList[i]["caption"];
                          String contents = contentList[i]["contents"];
                          String contentsMore = contentList[i]["contentsMore"];
                          var images = contentList[i]["images"];

                          setState(() {
                            contentListContents.add(contents);
                            contentListCaption.add(caption);
                            contentsListMore.add(contentsMore);
                            contentsListImage.add(images);
                          });
                        }
                      })()),
                  //NỘI DUNG
                  _buildContents(contentList),
                  // Nguồn
                  _buildAuthor(context, dateFormat),
                  //Có thể bạn sẽ thích nó
                  _buildLikes(context),
                ],
              ),
            ),
            CardNews(data: homedata, cardLength: 2),
            const SliverToBoxAdapter(child: BuildFooter())
          ],
        )),
      ),
    );
  }

  SliverPersistentHeader _buildHeader(BuildContext context) {
    return SliverPersistentHeader(
      pinned: false,
      floating: false,
      delegate: SliverAppBarDelegate(
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0, left: 20, right: 24),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.arrow_back_ios, color: Colors.blue),
                      const SizedBox(width: 10),
                      Text("Back", style: OneTheme.of(context).body1.copyWith(color: OneColors.brandVNP)),
                    ],
                  ),
                ),
              ),
              Expanded(flex: 1, child: Row(mainAxisAlignment: MainAxisAlignment.end, children: const []))
            ],
          ),
        ),
        minHeight: MediaQuery.of(context).padding.top + 70,
        maxHeight: MediaQuery.of(context).padding.top + 70,
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
              style: OneTheme.of(context).title1.copyWith(height: 2, color: OneColors.textGrey3, fontStyle: FontStyle.normal),
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
            style: OneTheme.of(context).body2.copyWith(color: OneColors.textGrey2),
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
              style: OneTheme.of(context).title2.copyWith(color: OneColors.textGrey2, fontStyle: FontStyle.italic),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              dateFormat,
              style: OneTheme.of(context).body2.copyWith(color: OneColors.textGrey2, fontStyle: FontStyle.normal),
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildContents(List<dynamic> contentList) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            SizedBox(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(parent: BouncingScrollPhysics()),
                itemCount: contentList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      // CAPTION
                      index <= contentListCaption.length
                          ? Padding(
                              padding: contentListCaption[index] != null ? EdgeInsets.zero : const EdgeInsets.symmetric(vertical: 5),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  contentListCaption[index] ?? "",
                                  style: OneTheme.of(context).caption1.copyWith(fontSize: 18, color: OneColors.white),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            )
                          : const SizedBox(),
                      // CONTENT
                      index <= contentListContents.length
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  contentListContents[index] ?? "",
                                  style: OneTheme.of(context).body2.copyWith(fontSize: 15, color: OneColors.white),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            )
                          : const SizedBox(),

                      //CONTENT IMAGE
                      index <= contentsListImage.length
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: (contentsListImage[index]["imageUrl"] != null && contentsListImage[index]["imageUrl"] != "")
                                      ? Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.4), blurRadius: 10)]),
                                              child: Image.network(contentsListImage[index]["imageUrl"],
                                                  fit: BoxFit.fill,
                                                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                    if (loadingProgress == null) return child;
                                                    return Center(
                                                      child: CircularProgressIndicator(
                                                        color: Colors.blue,
                                                        value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                                                      ),
                                                    );
                                                  },
                                                  errorBuilder: (context, error, stackTrace) => Image.asset("assets/images/not_found.png")),
                                            ),
                                            const SizedBox(height: 5),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                contentsListImage[index]["imageNotes"] ?? "",
                                                style: OneTheme.of(context).body2.copyWith(fontSize: 10, fontStyle: FontStyle.italic, color: OneColors.textGrey1),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Nguồn : ${contentsListImage[index]["imageCredit"] ?? ""}",
                                                style: OneTheme.of(context).body2.copyWith(fontSize: 10, fontStyle: FontStyle.italic, color: OneColors.textGrey1),
                                                textAlign: TextAlign.justify,
                                              ),
                                            )
                                          ],
                                        )
                                      : const SizedBox()),
                            )
                          : const SizedBox(),
                      // CONTENT MORE
                      index <= contentsListMore.length
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  contentsListMore[index] ?? "",
                                  style: OneTheme.of(context).body2.copyWith(fontSize: 15, color: OneColors.white),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  );
                },
              ),
            )
          ],
        ),
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

                    Navigator.push(context, MaterialPageRoute(builder: (context) => MySearch(list: list)));
                  }),
                  child: Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.blue.shade100),
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
        style: OneTheme.of(context).header.copyWith(fontSize: 26, color: OneColors.white),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
