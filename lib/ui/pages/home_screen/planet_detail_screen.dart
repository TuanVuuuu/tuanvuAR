import 'package:babylonjs_viewer/babylonjs_viewer.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/src/components/one_colors.dart';
import 'package:flutter_application_1/src/components/one_theme.dart';
import 'package:flutter_application_1/src/components/one_thick_ness.dart';
import 'package:flutter_application_1/src/shared/app_scaffold.dart';
import 'package:flutter_application_1/src/widgets/example2.dart';
import 'package:flutter_application_1/src/widgets/planet_3D_view.dart';
import 'package:flutter_application_1/src/widgets/video_player/video_player.dart';
import 'package:readmore/readmore.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loadingProgressCheck;
    });
    _videoPlayerController = VideoPlayerController.network(widget.argument["videosIntro"]);
    _videoPlayerController!.initialize().then((_) {
      _chewieController = ChewieController(videoPlayerController: _videoPlayerController!, autoPlay: false, looping: true);
      setState(() {
        print("Video Player\'s Good to Go");
      });
    });
  }

  @override
  void dispose() {
    _videoPlayerController!.dispose();
    _chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
    String imageDetail = widget.argument["imageDetail"];
    String nameModel = widget.argument["name"];
    String infoModel = widget.argument["info"];
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
                _buildImage2DDetail(imageDetail, nameModel, context, widget.argument),
                // Thông tin về số vệ tinh, tuổi, nhiệt độ
                _buildInfoExpanded(infoOther, context),
                // Thông tin chi tiết của hành tinh
                _buildInfoPlanets(infoModel, context),
                // Trình phát video giới thiệu
                SliverToBoxAdapter(
                  child: Stack(children: [
                    Opacity(
                      opacity: 1,
                      child: Center(
                        child: _chewieVideoPlayer(),
                      ),
                    ),
                  ]),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 50)),
              ],
            ),
          ),
        ));
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

  SliverToBoxAdapter _buildImage2DDetail(String imageDetail, String nameModel, BuildContext context, dynamic widget) {
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
            child: Image.network(imageDetail,
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LocalAndWebObjectsWidget(
                            argument: widget,
                          )
                      // Planet3DView(
                      //       argument: widget,
                      //     )

                      ));
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
                    )
                  ],
                ),
              )),
            ),
          ),
        )
      ]),
    );
  }
}
