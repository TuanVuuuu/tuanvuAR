import 'dart:math';
import 'dart:ui';
import 'dart:io' as io;
import 'package:babylonjs_viewer/babylonjs_viewer.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_shadow_image/drop_shadow_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/src/components/one_colors.dart';
import 'package:flutter_application_1/src/components/one_theme.dart';
import 'package:flutter_application_1/src/components/one_thick_ness.dart';
import 'package:flutter_application_1/src/shared/app_scaffold.dart';
import 'package:flutter_application_1/ui/pages/ar_screen.dart';
import 'package:flutter_application_1/src/widgets/example/3d_view.dart';
import 'package:flutter_application_1/ui/pages/planet_3D_view.dart';
import 'package:flutter_application_1/src/widgets/video_player/video_player.dart';
import 'package:readmore/readmore.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:native_ar_viewer/native_ar_viewer.dart';

import 'package:path_provider/path_provider.dart';

class PlanetDetailScreen extends StatefulWidget {
  const PlanetDetailScreen({
    Key? key,
    required this.argument,
  }) : super(key: key);

  final argument;

  @override
  State<PlanetDetailScreen> createState() => _PlanetDetailScreenState();
}

class _PlanetDetailScreenState extends State<PlanetDetailScreen> {
  final CollectionReference homedata = FirebaseFirestore.instance.collection("modeldata");

  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool? loadingProgressCheck;

  String iosAssetPath = '';
  String taskId = '';
  String documentDirectoryPath = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loadingProgressCheck;
    });

    _videoPlayerController = VideoPlayerController.network(widget.argument["videosIntro"]);
    _videoPlayerController!.initialize().then((_) {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: true,
        showControlsOnInitialize: false,
        showControls: false,
      );
      setState(() {
        print("Video Player\'s Good to Go");
      });
    });
  }

  @override
  void dispose() {
    _videoPlayerController!.dispose();
    if (_chewieController != null) {
      _chewieController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String modelURL = widget.argument["image3D"]["imageARUrl"];
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent, // Color for Android
        statusBarBrightness: Brightness.light, // Dark == white status bar -- for IOS.
      ),
    );
    var infoOther = widget.argument["infoOther"];
    String idname = widget.argument["idName"] ?? "";
    String imageDetail = widget.argument["imageDetail"];
    String nameModel = widget.argument["name"];
    String infoModel = widget.argument["info"];
    String satelliteNumber = infoOther["satelliteNumber"];
    print(infoOther["density"]);
    return AppScaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
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
              slivers: [
                _buildImage2DDetail(imageDetail, nameModel, context, widget.argument, modelURL),
                // Thông tin về số vệ tinh, tuổi, nhiệt độ
                _buildInfoExpanded(infoOther, context),
                // Thông tin chi tiết của hành tinh
                _buildInfoPlanets(infoModel, context),
                // Thông tin về mật độ, Bán Kính , chu kì quay, trọng lực, khoảng cách với mặt trời, quỹ đạo
                _buildListInfo(infoOther, context),

                // Trình phát video giới thiệu
                _buildVideoPlayer(),
                // Thông tin vệ tinh của hành tinh
                _buildSatellite(nameModel, context, satelliteNumber, idname),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 50,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  SliverToBoxAdapter _buildListInfo(infoOther, BuildContext context) {
    return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 024.0, bottom: 20),
                  child: Column(
                    children: [
                      (infoOther["density"] != "")
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                children: [
                                  Text("Mật độ: ", style: OneTheme.of(context).body1.copyWith(color: OneColors.white)),
                                  Text(" ${infoOther["density"]}\u00B3", style: OneTheme.of(context).body1.copyWith(color: OneColors.white)),
                                ],
                              ),
                            )
                          : const SizedBox(),
                      (infoOther["radius"] != "")
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                children: [
                                  Text("Bán kính: ", style: OneTheme.of(context).body1.copyWith(color: OneColors.white)),
                                  Text(" ${infoOther["radius"]}", style: OneTheme.of(context).body1.copyWith(color: OneColors.white)),
                                ],
                              ),
                            )
                          : const SizedBox(),
                      (infoOther["acreage"] != "")
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                children: [
                                  Text("Diện tích: ", style: OneTheme.of(context).body1.copyWith(color: OneColors.white)),
                                  Text(" ${infoOther["acreage"]}\u00B2", style: OneTheme.of(context).body1.copyWith(color: OneColors.white)),
                                ],
                              ),
                            )
                          : const SizedBox(),
                      (infoOther["cycle"] != "")
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                children: [
                                  Text("Chu kỳ quay: ", style: OneTheme.of(context).body1.copyWith(color: OneColors.white)),
                                  Text(" ${infoOther["cycle"]}", style: OneTheme.of(context).body1.copyWith(color: OneColors.white)),
                                ],
                              ),
                            )
                          : const SizedBox(),
                      (infoOther["gravitation"] != "")
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                children: [
                                  Text("Trọng lực: ", style: OneTheme.of(context).body1.copyWith(color: OneColors.white)),
                                  Text(" ${infoOther["gravitation"]}\u00B2", style: OneTheme.of(context).body1.copyWith(color: OneColors.white)),
                                ],
                              ),
                            )
                          : const SizedBox(),
                      (infoOther["distance"] != "")
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                children: [
                                  Text("Khoảng cách từ ${infoOther["trajectory"]} : ", style: OneTheme.of(context).body1.copyWith(color: OneColors.white)),
                                  Text(" ${infoOther["distance"]}", style: OneTheme.of(context).body1.copyWith(color: OneColors.white)),
                                ],
                              ),
                            )
                          : const SizedBox(),
                      (infoOther["trajectory"] != "")
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                children: [
                                  Text("Quỹ đạo: ", style: OneTheme.of(context).body1.copyWith(color: OneColors.white)),
                                  Text(" ${infoOther["trajectory"]}", style: OneTheme.of(context).body1.copyWith(color: OneColors.white)),
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              );
  }

  SliverToBoxAdapter _buildSatellite(String nameModel, BuildContext context, String satelliteNumber, String idname) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 00.0, top: 30),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Vệ tinh của $nameModel",
                          style: OneTheme.of(context).header.copyWith(color: OneColors.white),
                        ),
                        const SizedBox(height: 10),
                        satelliteNumber != "0"
                            ? Text(
                                "$nameModel có $satelliteNumber vệ tinh",
                                style: OneTheme.of(context).body1.copyWith(color: OneColors.white),
                              )
                            : const Text(""),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 100,
                    child: (idname == "saohoa" || idname == "traidat" || idname == "saothuy") ? Image.asset("assets/images/planets_animate/2x/$idname.png") : const SizedBox(),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                widget.argument["infoOther"]["satelliteNumber"] != "0"
                    ? Column(
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(parent: BouncingScrollPhysics()),
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: widget.argument["infoOther"]["satelliteInfo"].length,
                                itemBuilder: (context, index) {
                                  String name = widget.argument["infoOther"]["satelliteInfo"][index]["name"];
                                  String imageUrl = widget.argument["infoOther"]["satelliteInfo"][index]["imageUrl"];
                                  String introduction = widget.argument["infoOther"]["satelliteInfo"][index]["introduction"];
                                  return Padding(
                                      padding: EdgeInsets.zero,
                                      child: Container(
                                          color: Colors.transparent,
                                          width: 200,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Container(
                                                    height: 100,
                                                    width: MediaQuery.of(context).size.width * 0.2,
                                                    color: Colors.transparent,
                                                    child: SimpleShadow(
                                                      opacity: 0.6, // Default: 0.5
                                                      color: Colors.white, // Default: Black
                                                      offset: const Offset(0, 0), // Default: Offset(2, 2)
                                                      sigma: 7, child: Image.network(imageUrl),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 100,
                                                    width: MediaQuery.of(context).size.width * 0.7,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          name,
                                                          style: OneTheme.of(context).caption1.copyWith(color: OneColors.white, fontWeight: FontWeight.w500),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          introduction,
                                                          style: OneTheme.of(context).caption1.copyWith(color: OneColors.textGrey1, fontWeight: FontWeight.w500),
                                                          maxLines: 4,
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.only(bottom: 30.0),
                                                child: OneThickNess(),
                                              ),
                                            ],
                                          )));
                                },
                              )),
                        ],
                      )
                    : Row(
                        children: [
                          SizedBox(
                              height: 200,
                              child: SimpleShadow(
                                opacity: 0.6, // Default: 0.5
                                color: Colors.blue, // Default: Black
                                offset: const Offset(5, 5), // Default: Offset(2, 2)
                                sigma: 7,
                                child: Image.asset('assets/images/novetinh.png'), // Default: 2
                              )),
                          Text(
                            "$nameModel không có vệ tinh nha!",
                            style: OneTheme.of(context).title1.copyWith(color: OneColors.white),
                          )
                        ],
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildVideoPlayer() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Stack(children: [
            Opacity(
              opacity: 1,
              child: Center(
                child: _chewieVideoPlayer(),
              ),
            ),
          ]),
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => P3DView(argument: widget.argument)));
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(color: const Color(0xff202124), border: Border.all(color: OneColors.grey, width: 2), borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.view_in_ar,
                        color: OneColors.white,
                        size: 16,
                      ),
                      Text(
                        "Xem ở chế độ 3D",
                        style: OneTheme.of(context).caption1.copyWith(color: OneColors.white, fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildInfoPlanets(String infoModel, BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(children: [
          ReadMoreText(
            infoModel,
            style: OneTheme.of(context).body2.copyWith(fontSize: 16, color: OneColors.white),
            trimLines: 5,
            textAlign: TextAlign.justify,
            trimMode: TrimMode.Line,
            trimCollapsedText: " Xem thêm",
            trimExpandedText: " ...Rút gọn",
            lessStyle: OneTheme.of(context).body1.copyWith(color: OneColors.yellow),
            moreStyle: OneTheme.of(context).body1.copyWith(color: OneColors.yellow),
          ),
        ]),
      ),
    );
  }

  SliverToBoxAdapter _buildInfoExpanded(infoOther, BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                InkWell(onTap: () {}, child: const Icon(Icons.nightlight_rounded, color: OneColors.white)),
                Text(" ${infoOther["satelliteNumber"]}", style: OneTheme.of(context).body1.copyWith(color: OneColors.white)),
              ],
            ),
            Row(
              children: [
                Text("Tuổi : ", style: OneTheme.of(context).body1.copyWith(color: OneColors.white)),
                Text("${infoOther["age"]}", style: OneTheme.of(context).body1.copyWith(color: OneColors.white)),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.device_thermostat, color: OneColors.white),
                Text("${infoOther["temperature"]} \u00B0C", style: OneTheme.of(context).body1.copyWith(color: OneColors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chewieVideoPlayer() {
    return _chewieController != null && _videoPlayerController != null
        ? Container(
            margin: const EdgeInsets.only(top: 10),
            height: MediaQuery.of(context).size.width * 0.45,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 10)],
            ),
            child: ClipRRect(borderRadius: BorderRadius.circular(30), child: Chewie(controller: _chewieController!)))
        : Opacity(
            opacity: 0.2,
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                height: MediaQuery.of(context).size.width * 0.45,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
          );
  }

  SliverToBoxAdapter _buildImage2DDetail(String imageDetail, String nameModel, BuildContext context, dynamic widget, String modelURL) {
    return SliverToBoxAdapter(
      child: Stack(children: [
        // Hình ảnh 2D của hành tinh
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(100),
              bottomRight: Radius.circular(100),
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: Colors.transparent,
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4), blurRadius: 15)],
          ),
          height: 370,
          width: MediaQuery.of(context).size.width,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(100), bottomRight: Radius.circular(100), topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            child:
                // Image.asset(
                //   "assets/2D_model/Mars.jpg",
                //   fit: BoxFit.fitWidth,
                // )
                Image.network(imageDetail,
                    fit: BoxFit.fitWidth,
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
        ),

        // Tên Hành tinh
        Padding(
          padding: const EdgeInsets.only(top: 320),
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                nameModel.toUpperCase(),
                style: OneTheme.of(context).header.copyWith(color: OneColors.white, letterSpacing: 5),
              )),
        ),
        // Button Xem ở chế độ 3D
        Align(
          alignment: Alignment.bottomLeft,
          child: InkWell(
            onTap: () {
              setState(() {
                _launchAR(modelURL);
              });
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => LocalAndWebObjectsWidget(
              //                 argument: widget,
              //               )
              //           // Planet3DView(
              //           //       argument: widget,
              //           //     )
              //           ));
            },
            child: Container(
              margin: const EdgeInsets.only(top: 320),
              height: 60,
              width: 80,
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(15), boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.4),
                  blurRadius: 10,
                )
              ]),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Icon(
                      Icons.view_in_ar,
                      color: Colors.white,
                      size: 40,
                    ),
                    Text(
                      "AR",
                      style: OneTheme.of(context).title1.copyWith(color: OneColors.white),
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     setState(() {
                    //       _launchAR(modelURL);
                    //     });
                    //   },
                    //   child: const Text(
                    //     'Launch AR',
                    //   ),
                    // ),
                  ],
                ),
              )),
            ),
          ),
        )
      ]),
    );
  }

  _launchAR(String modelURL) async {
    if (io.Platform.isAndroid) {
      await NativeArViewer.launchAR(modelURL);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Platform not supported')));
    }
  }
}
