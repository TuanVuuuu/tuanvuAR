import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/components/one_card.dart';
import 'package:flutter_application_1/src/components/one_colors.dart';
import 'package:flutter_application_1/src/components/one_theme.dart';
import 'package:flutter_application_1/src/shared/app_scaffold.dart';
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
      //physics: const BouncingScrollPhysics(parent: ),
      slivers: <Widget>[
        SliverPersistentHeader(
          pinned: true,
          floating: false,
          delegate: SliverAppBarDelegate(
            child: OneCard(
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
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Row(
                            children: [
                              Text(
                                "Tìm kiếm với từ khoá :  ",
                                style: OneTheme.of(context).title1,
                              ),
                              Container(
                                decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    "${list[0]}",
                                    style: OneTheme.of(context).title2.copyWith(color: OneColors.brandVNP),
                                    maxLines: 2,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
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
}
