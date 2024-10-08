import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/widgets/one_news_widget/card_with_tags.dart';
import 'package:flutter_application_1/ui/views/sliver_appbar_delegate.dart';

class MySearch extends StatelessWidget {
  const MySearch({
    Key? key,
    required this.list,
  }) : super(key: key);

  final List list;

  @override
  Widget build(BuildContext context) {
    final CollectionReference homedata = FirebaseFirestore.instance.collection("homedata");
    return AppScaffold(
        body: Scrollbar(
            child: CustomScrollView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        SliverPersistentHeader(
          pinned: false,
          floating: false,
          delegate: SliverAppBarDelegate(
            child: Container(
              color: OneColors.transparent,
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 20, right: 24),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: OneColors.black,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Row(
                            children: [
                              Text(
                                "Tìm kiếm với từ khoá :  ",
                                style: OneTheme.of(context).title1.copyWith(color: OneColors.black),
                              ),
                              _buildTagsSearch(context),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            minHeight: MediaQuery.of(context).padding.top + 70,
            maxHeight: MediaQuery.of(context).padding.top + 70,
          ),
        ),
        CardNewsWithTags(data: homedata, tagsButton: list[0])
      ],
    )));
  }

  Container _buildTagsSearch(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: OneColors.blue100, borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          "${list[0]}",
          style: OneTheme.of(context).title2.copyWith(color: OneColors.brandVNP),
          maxLines: 2,
          overflow: TextOverflow.clip,
        ),
      ),
    );
  }
}
