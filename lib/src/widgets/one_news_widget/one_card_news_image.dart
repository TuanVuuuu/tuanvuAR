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
    this.style,
  }) : super(key: key);

  final DocumentSnapshot<Object?> records;
  final String dateFormat;
  bool? checkimages;
  bool? style;

  @override
  Widget build(BuildContext context) {
    final theme = OneTheme.of(context);
    final title = records['title'] ?? '';
    final author = records['author'] ?? '';
    final content = records['content'][0];
    final imageUrl = content['images']['imageUrl'] ?? '';
    final views = records['views'] ?? '';

    DateTime now = DateTime.now();
    Timestamp time = records["date"];
    DateTime otherDateTime = DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);
    Duration difference = now.difference(otherDateTime);
    int seconds = difference.inSeconds;
    int minutes = difference.inMinutes;
    int hours = difference.inHours;
    int days = difference.inDays;
    int weeks = (difference.inDays / 7).floor();

    String formatViews(int views) {
      if (views < 1000) {
        return '$views';
      } else if (views >= 1000 && views < 1000000) {
        double viewsInK = views / 1000;
        return '${viewsInK.toStringAsFixed(1)}K';
      } else if (views >= 1000000 && views < 1000000000) {
        double viewsInM = views / 1000000;
        return '${viewsInM.toStringAsFixed(1)}M';
      } else {
        double viewsInB = views / 1000000000;
        return '${viewsInB.toStringAsFixed(1)}B';
      }
    }

    return SizedBox(
      height: (checkimages != false) ? 163 + 7 : 104 + 14 + 30,
      child: Row(
        children: [
          if (checkimages != false) Expanded(flex: 1, child: _buildImages(imageUrl)) else const SizedBox(),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTitle(title, theme),
                  checkimages == false ? _buildTitleDisplay(theme) : const SizedBox(),
                  const SizedBox(height: 10),
                  if (author.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildTimes(author, theme, seconds, minutes, hours, days, weeks, context),
                        _buildViewCounter(formatViews, views, theme),
                      ],
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildViewCounter(String Function(int views) formatViews, views, OneThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Icon(
          Icons.visibility,
          color: OneColors.grey,
          size: 10,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          "${formatViews(views)} lượt xem",
          style: theme.body2.copyWith(
            overflow: TextOverflow.clip,
            fontSize: 10,
            fontWeight: FontWeight.w300,
            color: OneColors.black,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Expanded _buildTimes(author, OneThemeData theme, int seconds, int minutes, int hours, int days, int weeks, BuildContext context) {
    return Expanded(
        flex: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$author",
              style: OneTheme.of(context).body2.copyWith(color: OneColors.black, fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.justify,
            ),
            Row(
              children: [
                const Icon(
                  Icons.date_range_outlined,
                  color: OneColors.black,
                  size: 10,
                ),
                const SizedBox(
                  width: 5,
                ),
                seconds < 60
                    ? _buildTimeCard(seconds, theme, '$seconds giây trước')
                    : (minutes < 60
                        ? _buildTimeCard(seconds, theme, '$minutes phút trước')
                        : (hours < 24
                            ? _buildTimeCard(seconds, theme, '$hours giờ trước')
                            : (days < 7 ? _buildTimeCard(seconds, theme, '$days ngày trước') : _buildTimeCard(seconds, theme, '$weeks tuần trước'))))
              ],
            ),
          ],
        ));
  }

  Text _buildTimeCard(int seconds, OneThemeData theme, String time) {
    return Text(
      time,
      style: theme.body2.copyWith(overflow: TextOverflow.clip, fontSize: 10, fontWeight: FontWeight.w300, color: OneColors.black),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildImages(imageUrl) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: OneColors.black,
            blurRadius: 3,
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      height: 163,
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
    );
  }

  Text _buildTitleDisplay(OneThemeData theme) {
    return Text(
      records['titleDisplay'],
      maxLines: (checkimages != false) ? 5 : 2,
      textAlign: TextAlign.left,
      style: theme.body2.copyWith(
        overflow: TextOverflow.ellipsis,
        color: OneColors.black,
        fontSize: 13,
      ),
    );
  }

  Text _buildTitle(title, OneThemeData theme) {
    return Text(
      title,
      style: theme.title1.copyWith(
        overflow: TextOverflow.ellipsis,
        fontSize: 15,
        color: OneColors.black,
      ),
      maxLines: checkimages != false ? 4 : 2,
      textAlign: TextAlign.left,
    );
  }
}
