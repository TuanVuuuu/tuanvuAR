import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/components/one_colors.dart';
import 'package:flutter_application_1/src/components/one_theme.dart';

class OneCardNewsNoImage extends StatelessWidget {
  const OneCardNewsNoImage({
    Key? key,
    required this.records,
    required this.dateFormat,
  }) : super(key: key);

  final DocumentSnapshot<Object?> records;
  final String dateFormat;

  @override
  Widget build(BuildContext context) {
    String author = records["author"];
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    "${records["title"] ?? ""}",
                    style: OneTheme.of(context).title1.copyWith(overflow: TextOverflow.ellipsis, fontSize: 17, color: OneColors.white),
                  ),
                  const SizedBox(height: 10),
                  Text("${records["content"][0]["contents"] ?? ""}", maxLines: 3, textAlign: TextAlign.justify, style: OneTheme.of(context).body2.copyWith(overflow: TextOverflow.ellipsis, color: OneColors.white)),
                  // Text("${records["content"] ?? ""}", maxLines: 3, textAlign: TextAlign.justify, style: OneTheme.of(context).body2.copyWith(overflow: TextOverflow.ellipsis)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          (dateFormat != "" && author != "")
                              ? SizedBox(
                                  width: MediaQuery.of(context).size.width - 70,
                                  child: Text(
                                    "$author - $dateFormat",
                                    style: OneTheme.of(context).body2.copyWith(
                                          overflow: TextOverflow.clip,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                          color: OneColors.white
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              : const SizedBox()
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
