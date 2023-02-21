// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/components/loading/one_loading.dart';
import 'package:flutter_application_1/src/components/one_images.dart';

class OneCardNewsImage extends StatelessWidget {
  OneCardNewsImage({
    Key? key,
    required this.records,
    required this.dateFormat,
    this.checkimages,
  }) : super(key: key);

  final DocumentSnapshot<Object?> records;
  final String dateFormat;
  bool? checkimages;

  @override
  Widget build(BuildContext context) {
    final theme = OneTheme.of(context);
    final title = records['title'] ?? '';
    final author = records['author'] ?? '';
    final content = records['content'][0];
    final imageUrl = content['images']['imageUrl'] ?? '';

    DateTime now = DateTime.now();
    Timestamp time = records["date"];
    DateTime otherDateTime = DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);
    Duration difference = now.difference(otherDateTime);
    int seconds = difference.inSeconds;
    int minutes = difference.inMinutes;
    int hours = difference.inHours;
    int days = difference.inDays;
    int weeks = (difference.inDays / 7).floor();
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.title1.copyWith(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 17,
                          color: OneColors.white,
                        ),
                        maxLines: checkimages != false ? 2 : 1,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        records['titleDisplay'],
                        maxLines: 4,
                        textAlign: TextAlign.left,
                        style: theme.body2.copyWith(
                          overflow: TextOverflow.ellipsis,
                          color: OneColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              checkimages != false
                  ? Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: OneColors.white,
                              blurRadius: 3,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: imageUrl.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return OneLoading.space_loading;
                                  },
                                  errorBuilder: (context, error, stackTrace) => Image.asset(OneImages.not_found),
                                )
                              : const SizedBox(),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
          const SizedBox(height: 10),
          if (author.isNotEmpty)
            SizedBox(
              width: MediaQuery.of(context).size.width - 70,
              child: Row(
                children: [
                  Text(
                    '$author - ',
                    style: theme.body2.copyWith(
                      overflow: TextOverflow.clip,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: OneColors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  seconds < 60
                      ? Text(
                          '$seconds giây trước',
                          style: theme.body2.copyWith(
                            overflow: TextOverflow.clip,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: OneColors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        )
                      : (minutes < 60
                          ? Text(
                              '$minutes phút trước',
                              style: theme.body2.copyWith(
                                overflow: TextOverflow.clip,
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: OneColors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            )
                          : (hours < 24
                              ? Text(
                                  '$hours giờ trước',
                                  style: theme.body2.copyWith(
                                    overflow: TextOverflow.clip,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    color: OneColors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                )
                              : (days < 7
                                  ? Text(
                                      '$days ngày trước',
                                      style: theme.body2.copyWith(
                                        overflow: TextOverflow.clip,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                        color: OneColors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : Text(
                                      '$weeks tuần trước',
                                      style: theme.body2.copyWith(
                                        overflow: TextOverflow.clip,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                        color: OneColors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    )))),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
