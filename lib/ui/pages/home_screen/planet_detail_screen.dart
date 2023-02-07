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

    idmain = idname;
    return AppScaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: OneColors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: OneColors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: OneColors.white,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg/bg4.png"),
              fit: BoxFit.cover,
            ),
          ),
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

  SliverToBoxAdapter _buildNamePlanets(String nameModel, BuildContext context, String modelURL) {
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
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(color: OneColors.white.withOpacity(0.4), borderRadius: BorderRadius.circular(15)),
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.view_in_ar,
                      color: OneColors.white,
                      size: 40,
                    ),
                    Text(
                      "AR",
                      style: OneTheme.of(context).title1.copyWith(color: OneColors.white),
                    ),
                  ],
                ),
              ),
            ),
          )
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
                child: Image.asset('assets/images/novetinh.png'), // Default: 2
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
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => DiscoveryDetailScreen(argument: records, color: const Color.fromARGB(255, 197, 165, 247))));
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
                                                  child: SizedBox(
                                                    height: sizeHeight * 0.1,

                                                    child: Image.network(image2DUrl ?? ""), // Default: 2
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
                    child: (idname == "saohoa" || idname == "traidat" || idname == "saothuy") ? Image.asset("assets/images/planets_animate/2x/$idname.png") : const SizedBox(),
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
            child: Image.network(
              image2DUrl,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        Positioned(
          top: sizeHeight * 0.25,
          right: 0,
          child: Container(
            height: sizeHeight * 0.25,
            color: OneColors.transparent,
            child: Image.asset(
              "assets/images/rocket2.png",
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
