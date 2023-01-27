import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/components/one_theme.dart';

class OneCardNewsImage extends StatelessWidget {
  const OneCardNewsImage({
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
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Column(
                    children: [
                      Text(
                        "${records["title"] ?? ""}",
                        style: OneTheme.of(context).title1.copyWith(overflow: TextOverflow.ellipsis, fontSize: 17),
                        maxLines: 2,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 10),
                      Text("${records["content"][0]["contents"] ?? ""}", maxLines: 4, textAlign: TextAlign.left, style: OneTheme.of(context).body2.copyWith(overflow: TextOverflow.ellipsis)),
                      //Text("${records["content"] ?? ""}", maxLines: 4, textAlign: TextAlign.justify, style: OneTheme.of(context).body2.copyWith(overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(records["content"][0]["images"]["imageUrl"],
                          fit: BoxFit.cover,
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
                  )),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              (dateFormat != "" && author != "")
                  ? Container(
                      width: MediaQuery.of(context).size.width - 70,
                      child: Text(
                        "$author - $dateFormat",
                        style: OneTheme.of(context).body2.copyWith(
                              overflow: TextOverflow.clip,
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ],
      ),
    );
  }
}
