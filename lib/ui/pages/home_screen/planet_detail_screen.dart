// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_string_escapes, avoid_print

part of '../../../libary/one_libary.dart';

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
  final CollectionReference discoverydata = FirebaseFirestore.instance.collection("discoverdata");

  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool? loadingProgressCheck;

  String iosAssetPath = '';
  String taskId = '';
  String documentDirectoryPath = "";
  String? idmain;

  List<Map<String, dynamic>> _newsDataList = [];

  @override
  void initState() {
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
      setState(() {});
    });
    getHomeData().then((newsData) {
      setState(() {
        _newsDataList = newsData;
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
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: OneColors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: OneColors.transparent, // Color for Android
        statusBarBrightness: Brightness.light, // Dark == white status bar -- for IOS.
      ),
    );
    var infoOther = widget.argument["infoOther"];
    String idname = widget.argument["idName"] ?? "";
    String image2DUrl = widget.argument["image2D"]["imageUrl"];
    String nameModel = widget.argument["name"];
    String infoModel = widget.argument["info"];
    String satelliteNumber = infoOther["satelliteNumber"];
    String modelURL = widget.argument["image3D"]["imageARUrl"];
    var colors = widget.argument["image2D"]["colors"];
    String colorModel = colors["colorModel"];

    print(idname);

    idmain = idname;
    List<Widget> slivers = [
      if (_newsDataList.where((data) => data["tags"].contains(nameModel)).isNotEmpty) _buildNewsCard(nameModel, context),
    ];

    return AppScaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: OneColors.transparent,
          elevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: OneColors.white), onPressed: () => Navigator.pop(context)),
        ),
        backgroundColor: OneColors.white,
        body: Container(
          decoration: OneWidget.background_bg4,
          child: Scrollbar(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildImage2DDetail(nameModel, context, widget.argument, modelURL, sizeHeight, sizeWidth, image2DUrl, colorModel),

                _buildNamePlanets(nameModel, context, modelURL),
                // Thông tin về số vệ tinh, tuổi, nhiệt độ
                _buildInfoExpanded(infoOther, context),
                // Thông tin chi tiết của hành tinh
                _buildInfoPlanets(infoModel, context),
                // Thông tin về mật độ, Bán Kính , chu kì quay, trọng lực, khoảng cách với mặt trời, quỹ đạo
                _buildListInfo(infoOther, context),
                // Trình phát video giới thiệu
                _buildVideoPlayer(),
                _buildSatellite(nameModel, context, satelliteNumber, idname),
                // Thông tin vệ tinh của hành tinh
                satelliteNumber != "0" ? _buildDiscovery(sizeHeight, sizeWidth) : _buildNotifiNotSatellite(nameModel, context),
                slivers.isNotEmpty
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(
                              "Kiến thức liên quan : ",
                              style: OneTheme.of(context).title1.copyWith(color: OneColors.white),
                            ),
                            const SizedBox(height: 20),
                          ]),
                        ),
                      )
                    : const SliverToBoxAdapter(child: SizedBox()),
                _buildNewsCard(nameModel, context),

                const SliverToBoxAdapter(child: SizedBox(height: 50)),
              ],
            ),
          ),
        ));
  }

  SliverToBoxAdapter _buildNewsCard(String nameModel, BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: _newsDataList
            .where((data) => data["tags"].contains(nameModel))
            .take(3)
            .map((data) => InkWell(
                  onTap: (() => Get.to(() => DetailNewsScreen(argument: data), curve: Curves.linear, transition: Transition.rightToLeft)),
                  child: Container(
                    margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
                    decoration: BoxDecoration(
                      color: OneColors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data["title"],
                                  style: OneTheme.of(context).title1.copyWith(color: OneColors.white),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.justify,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  data["titleDisplay"],
                                  style: OneTheme.of(context).body2.copyWith(color: OneColors.white),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.justify,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  data["author"],
                                  style: OneTheme.of(context).body2.copyWith(color: OneColors.white),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
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
                            height: 90,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: data['content'][0]['images']['imageUrl'] != ""
                                  ? Image.network(
                                      data['content'][0]['images']['imageUrl'],
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
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildNamePlanets(String nameModel, BuildContext context, String modelURL) {
    return SliverToBoxAdapter(
      child: // Tên Hành tinh
          Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 24),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  nameModel.toUpperCase(),
                  style: OneTheme.of(context).header.copyWith(color: OneColors.white, letterSpacing: 5),
                )),
          ),
          InkWell(
            onTap: () {
              setState(() {
                _launchAR(modelURL);
              });
            },
            child: const one_button_ar_view(),
          ),
        ],
      ),
    );
  }

  Widget _buildNotifiNotSatellite(String nameModel, BuildContext context) {
    return SliverToBoxAdapter(
      child: Row(
        children: [
          Row(
            children: [
              SizedBox(
                height: 200,
                child: Image.asset(OneImages.novetinh), // Default: 2
              ),
              Text(
                "$nameModel không có vệ tinh nha!",
                style: OneTheme.of(context).title1.copyWith(color: OneColors.white),
              )
            ],
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildDiscovery(double sizeHeight, double sizeWidth) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                SizedBox(
                  child: StreamBuilder(
                      stream: discoverydata.snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {}
                        if (snapshot.hasData) {
                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot records = snapshot.data!.docs[index];
                              String? name = records["name"];
                              String? image2DUrl = records["images"]["image2DUrl"];
                              String? info = records["info"];
                              List tags = records["tags"];
                              return Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: Column(
                                    children: tags.map((i) {
                                  if (i == idmain) {
                                    return InkWell(
                                      onTap: () {
                                        Get.to(() => DiscoveryDetailScreen(argument: records, color: const Color.fromARGB(255, 197, 165, 247)),
                                            curve: Curves.linear, transition: Transition.rightToLeft);
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: sizeWidth - 20,
                                            height: sizeHeight * 0.1,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: SizedBox(height: sizeHeight * 0.1, child: CachedImage(imageUrl: image2DUrl ?? "") // Default: 2
                                                      ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 20),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          margin: const EdgeInsets.only(bottom: 10),
                                                          child: Text(
                                                            name ?? "",
                                                            style: OneTheme.of(context).body1.copyWith(color: OneColors.white, fontSize: 12),
                                                            maxLines: 3,
                                                          ),
                                                        ),
                                                        Text(
                                                          info ?? "",
                                                          style: OneTheme.of(context).body1.copyWith(color: OneColors.textGrey1, fontSize: 10),
                                                          maxLines: 4,
                                                          overflow: TextOverflow.ellipsis,
                                                          textAlign: TextAlign.justify,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(bottom: 30.0),
                                            child: OneThickNess(),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return Container();
                                }).toList()),
                              );
                            },
                          );
                        }

                        return Container();
                      }),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
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
                    child: (idname == "saohoa" || idname == "traidat" || idname == "saothuy" || idname == "saomoc") ? Image.asset("assets/images/planets_animate/2x/$idname.png") : const SizedBox(),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 50,
            ),
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
                Get.to(() => P3DView(argument: widget.argument), curve: Curves.linear, transition: Transition.rightToLeft);
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

  Widget _buildInfoExpanded(infoOther, BuildContext context) {
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
              color: OneColors.transparent,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [BoxShadow(color: OneColors.grey, blurRadius: 10)],
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
                  color: OneColors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
          );
  }

  SliverToBoxAdapter _buildImage2DDetail(String nameModel, BuildContext context, dynamic widget, String modelURL, double sizeHeight, double sizeWidth, String image2DUrl, String colorModel) {
    return SliverToBoxAdapter(
      child: Stack(clipBehavior: Clip.none, children: [
        Positioned(
          top: -sizeHeight * 0.4,
          right: -sizeWidth * 0.4,
          child: Container(
            height: sizeHeight,
            width: sizeWidth,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Color(
                      int.parse(colorModel),
                    ).withOpacity(0.4),
                    blurRadius: 100,
                    spreadRadius: 50)
              ],
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: -sizeWidth * 0.2,
          child: Container(
              height: sizeHeight * 0.35,
              color: OneColors.transparent,
              child: CachedImage(
                imageUrl: image2DUrl,
                fit: BoxFit.fitHeight,
              )),
        ),
        Positioned(
          top: sizeHeight * 0.25,
          right: 0,
          child: Container(
            height: sizeHeight * 0.25,
            color: OneColors.transparent,
            child: Image.asset(
              OneImages.rocket2,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        SizedBox(height: sizeHeight * 0.4),
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
