// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/src/components/button/one_button_ar_view.dart';
import 'package:flutter_application_1/src/components/loading/one_cache_images.dart';
import 'package:flutter_application_1/src/components/one_colors.dart';
import 'package:flutter_application_1/src/components/one_images.dart';
import 'package:flutter_application_1/src/components/one_theme.dart';
import 'package:flutter_application_1/src/shared/app_scaffold.dart';
import 'package:native_ar_viewer/native_ar_viewer.dart';
import 'package:readmore/readmore.dart';
import 'dart:io' as io;

class ArtificialDetailScreen extends StatefulWidget {
  const ArtificialDetailScreen({Key? key, required this.argument, required this.color}) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  final argument;
  // ignore: prefer_typing_uninitialized_variables
  final color;

  @override
  State<ArtificialDetailScreen> createState() => _ArtificialDetailScreenState();
}

class _ArtificialDetailScreenState extends State<ArtificialDetailScreen> {
  double? sizeHeight;
  double? sizeWidth;
  String? image2DUrl;
  String? name;
  String? info;
  // ignore: prefer_typing_uninitialized_variables
  var otherInfo;

  @override
  Widget build(BuildContext context) {
    image2DUrl = widget.argument["images"]["image2DUrl"];
    String model3DUrl = widget.argument["images"]["image3DUrl"];
    name = widget.argument["name"];
    info = widget.argument["info"];
    List idname = widget.argument["idname"];
    sizeHeight = MediaQuery.of(context).size.height;
    sizeWidth = MediaQuery.of(context).size.width;
    otherInfo = widget.argument["otherInfo"];
    String launch_date = otherInfo["launch_date"];
    String speed = otherInfo["speed"];
    String orbital_altitude = otherInfo["orbital_altitude"];
    String speed_in_orbit = otherInfo["speed_in_orbit"];
    String launch_location = otherInfo["launch_location"];
    String manufacturer = otherInfo["manufacturer"];

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: OneColors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent, // Color for Android
        statusBarBrightness: Brightness.light, // Dark == white status bar -- for IOS.
      ),
    );
    return AppScaffold(
        appBar: AppBar(
          backgroundColor: OneColors.transparent,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: OneColors.white,
            ),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(OneImages.bg4),
              fit: BoxFit.cover,
            ),
          ),
          child: Scrollbar(
              child: CustomScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: <Widget>[
              // Build Image
              _buildImage(context),
              // Build name , tags, info
              _buildInfo(context, idname, model3DUrl),
              //Build tuổi, bán kính, mật độ, trọng lực, chu kỳ quay,
              _buildGridInfo(launch_date, speed, orbital_altitude, speed_in_orbit, launch_location, manufacturer)
            ],
          )),
        ));
  }

  Widget _buildGridInfo(String launch_date, String speed, String orbital_altitude, String speed_in_orbit, String launch_location, String manufacturer) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200.0,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 2.5,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          List<Icon> icons = [
            const Icon(Icons.history_toggle_off, color: OneColors.white),
            const Icon(Icons.open_in_full, color: OneColors.white),
            const Icon(Icons.drag_indicator, color: OneColors.white),
            const Icon(Icons.play_for_work, color: OneColors.white),
            const Icon(Icons.donut_large, color: OneColors.white),
            const Icon(Icons.settings_backup_restore, color: OneColors.white),
          ];
          List<String> titles = ["Ngày phóng", "Tốc độ tối đa", "Độ cao quỹ đạo", "Tốc độ quỹ đạo", "Địa điểm phóng", "Nhà sản xuất"];

          List<String> contents = [launch_date, speed, orbital_altitude, speed_in_orbit, launch_location, manufacturer];
          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    icons[index],
                    const SizedBox(width: 5),
                    Text(titles[index], style: OneTheme.of(context).title1.copyWith(color: OneColors.white, fontWeight: FontWeight.w400)),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  height: 40,
                  width: sizeWidth! - 60,
                  decoration: BoxDecoration(color: OneColors.transparent, borderRadius: BorderRadius.circular(15), border: Border.all(color: OneColors.white, width: 2)),
                  child: Center(
                    child: contents[index] != ""
                        ? Text(
                            contents[index],
                            style: OneTheme.of(context).title1.copyWith(color: OneColors.white),
                          )
                        : Text(
                            "Đang cập nhật",
                            style: OneTheme.of(context).title1.copyWith(color: OneColors.grey, fontSize: 12),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
        childCount: 6,
      ),
    );
  }

  SliverToBoxAdapter _buildInfo(BuildContext context, List<dynamic> idname, String model3DUrl) {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
                child: Text(
                  name!,
                  style: OneTheme.of(context).header.copyWith(fontSize: 30, color: OneColors.white),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          _launchAR(model3DUrl);
                        });
                      },
                      child: const one_button_ar_view())),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Row(
                children: idname.map((i) {
              return Container(
                margin: const EdgeInsets.only(right: 10),
                height: 20,
                decoration: BoxDecoration(color: widget.color, borderRadius: BorderRadius.circular(20)),
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      i,
                      style: OneTheme.of(context).body1.copyWith(color: OneColors.white, fontSize: 10),
                    ),
                  ),
                ),
              );
            }).toList()),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: ReadMoreText(
              info!,
              style: OneTheme.of(context).body2.copyWith(fontSize: 16, color: OneColors.white),
              trimLines: 5,
              textAlign: TextAlign.justify,
              trimMode: TrimMode.Line,
              trimCollapsedText: " Xem thêm",
              trimExpandedText: " ...Rút gọn",
              lessStyle: OneTheme.of(context).body1.copyWith(color: OneColors.yellow),
              moreStyle: OneTheme.of(context).body1.copyWith(color: OneColors.yellow),
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildImage(BuildContext context) {
    return SliverToBoxAdapter(
        child: Container(
      color: OneColors.transparent,
      height: sizeHeight! * 0.4,
      width: sizeWidth!,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -sizeHeight! * 0.4,
            right: -sizeWidth! * 0.4,
            child: Container(
              height: sizeHeight!,
              width: sizeWidth!,
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: widget.color.withOpacity(0.2), blurRadius: 50, spreadRadius: 50)],
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: -sizeWidth! * 0.2,
            child: Container(
                height: sizeHeight! * 0.35,
                color: OneColors.transparent,
                child: CachedImage(
                  imageUrl: image2DUrl ?? "",
                  fit: BoxFit.fitHeight,
                )),
          ),
        ],
      ),
    ));
  }

  _launchAR(String model3DUrl) async {
    if (io.Platform.isAndroid) {
      await NativeArViewer.launchAR(model3DUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Platform not supported')));
    }
  }
}
