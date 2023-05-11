// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_string_escapes, avoid_print, unused_field

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

  String iosAssetPath = '';
  String taskId = '';
  String documentDirectoryPath = "";
  String? idmain;

  List<Map<String, dynamic>> _newsDataList = [];
  Map<String, dynamic>? _mapCurrentUser;

  bool checkstate = false;
  bool readmore = false;
  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.network(widget.argument["videosIntro"]);
    _videoPlayerController!.initialize().then((_) {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: true,
        showControlsOnInitialize: false,
        showControls: true,
      );
      setState(() {});
    });
    getHomeData().then((newsData) {
      setState(() {
        _newsDataList = newsData;
      });
    });
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final Map<String, dynamic> leaderboard = await getCurrentUser();
    setState(() {
      _mapCurrentUser = leaderboard;
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
    AppContants.init(context);

    double sizeHeight = AppContants.sizeHeight;
    double sizeWidth = AppContants.sizeWidth;
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
    String model3DScan = widget.argument["image3D"]["imageScan3D"];
    var colors = widget.argument["image2D"]["colors"];
    String colorModel = colors["colorModel"];

    final currentUser = FirebaseAuth.instance.currentUser;

    idmain = idname;

    print(checkstate);
    return AppScaffold(
      backgroundColor: OneColors.white,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Scrollbar(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildImage2DDetail(
                  nameModel,
                  context,
                  widget.argument,
                  modelURL,
                  sizeHeight,
                  sizeWidth,
                  image2DUrl,
                  colorModel,
                  currentUser,
                  idname,
                ),
                // Thông tin về số vệ tinh, tuổi, nhiệt độ
                _buildInfoExpanded(infoOther, context),
                // Thông tin chi tiết của hành tinh
                _buildInfoPlanets(infoModel, context),
                // Thông tin về mật độ, Bán Kính , chu kì quay, trọng lực, khoảng cách với mặt trời, quỹ đạo
                // _buildListInfo(infoOther, context),
                // Trình phát video giới thiệu
                checkstate == false ? _buildVideoPlayer() : const SliverToBoxAdapter(child: SizedBox()),
                // _buildSatellite(nameModel, context, satelliteNumber, idname),

                checkstate == false
                    ? const SliverToBoxAdapter(child: SizedBox())
                    : const SliverToBoxAdapter(
                        child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: OneThickNess(),
                      )),

                // Thông tin về mật độ, Bán Kính , chu kì quay, trọng lực, khoảng cách với mặt trời, quỹ đạo
                checkstate != false ? _buildListInfo(infoOther, context, readmore) : const SliverToBoxAdapter(child: SizedBox()),

                checkstate == false ? const SliverToBoxAdapter(child: SizedBox()) : _buildReadmoreInfoExpanded(context),

                // Thông tin vệ tinh của hành tinh
                // satelliteNumber != "0" ? _buildDiscovery(sizeHeight, sizeWidth) : _buildNotifiNotSatellite(nameModel, context),
                // slivers.isNotEmpty ? _buildTitleOtherNews(context) : const SliverToBoxAdapter(child: SizedBox()),
                // _buildNewsCard(nameModel, context),
                checkstate != false
                    ? satelliteNumber != "0"
                        ? SliverToBoxAdapter(
                            child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Vệ tinh",
                              style: OneTheme.of(context).title1.copyWith(color: OneColors.black, fontSize: 30, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.right,
                            ),
                          ))
                        : const SliverToBoxAdapter(child: SizedBox())
                    : const SliverToBoxAdapter(child: SizedBox()),

                checkstate != false
                    ? satelliteNumber != "0"
                        ? _buildDiscovery(sizeHeight, sizeWidth)
                        : const SliverToBoxAdapter(child: SizedBox())
                    : const SliverToBoxAdapter(child: SizedBox()),

                const SliverToBoxAdapter(child: SizedBox(height: 200)),
              ],
            ),
          ),
          _buildBottomBar(sizeWidth, context, checkstate, modelURL, model3DScan),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildReadmoreInfoExpanded(BuildContext context) {
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 1,
            width: AppContants.sizeWidth * 0.35,
            color: OneColors.textGrey2,
          ),
          TextButton(
            onPressed: () {
              setState(() {
                if (readmore == false) {
                  readmore = true;
                } else {
                  readmore = false;
                }
              });
            },
            child: Text(readmore == false ? "Xem thêm" : "Rút gọn", style: OneTheme.of(context).body1.copyWith(color: OneColors.grey, fontSize: 12)),
          ),
          Container(
            height: 1,
            width: AppContants.sizeWidth * 0.35,
            color: OneColors.textGrey2,
          ),
        ],
      ),
    ));
  }

  Positioned _buildBottomBar(double sizeWidth, BuildContext context, bool checkState, String modelURL, String model3DScan) {
    return Positioned(
      bottom: 10,
      left: sizeWidth * 0.05,
      child: SizedBox(
        height: 128,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 102,
                width: sizeWidth * 0.9,
                decoration: BoxDecoration(
                    color: OneColors.white,
                    boxShadow: const [
                      BoxShadow(blurRadius: 10, color: OneColors.grey),
                    ],
                    borderRadius: BorderRadius.circular(44)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: OneColors.transparent, elevation: 0),
                                onPressed: () {
                                  setState(() {
                                    if (checkstate == false) {
                                      checkstate = true;
                                    } else {
                                      checkstate = false;
                                    }
                                  });
                                },
                                child: const Icon(Icons.info_outline, size: 30, color: OneColors.black)),
                            Text(
                              "Chi tiết",
                              style: OneTheme.of(context).title1.copyWith(color: OneColors.black, fontSize: 15, fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.view_in_ar, size: 30),
                              onPressed: () {
                                Get.to(() => P3DView(argument: widget.argument), curve: Curves.linear, transition: Transition.rightToLeft);
                              }),
                          Text(
                            "Mô hình 3D",
                            style: OneTheme.of(context).title1.copyWith(color: OneColors.black, fontSize: 15, fontWeight: FontWeight.w400),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 115,
              width: sizeWidth * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          enableDrag: false,
                          backgroundColor: OneColors.transparent,
                          elevation: 0,
                          builder: (BuildContext context) {
                            return Center(
                              child: Container(
                                height: 400,
                                width: AppContants.sizeWidth - 50,
                                decoration: BoxDecoration(color: OneColors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [
                                  BoxShadow(
                                    color: OneColors.grey,
                                    blurRadius: 4,
                                  )
                                ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Center(
                                        child: Text(
                                          "Lựa chọn chế độ xem!",
                                          style: OneTheme.of(context).header.copyWith(color: OneColors.black),
                                        ),
                                      ),
                                      model3DScan != ""
                                          ? _itemARCatagory(
                                              context,
                                              () {
                                                Get.to(() => MyScanARApp(
                                                      argumentScan: model3DScan,
                                                    ));
                                                // Get.toNamed(AppRoutes.MULTIPLE_AUGMENTED_IMAGES.name);
                                              },
                                              OneImages.icons_ar_scan,
                                              "Quét hình ảnh trong không gian thực",
                                            )
                                          : const SizedBox(),
                                      _itemARCatagory(
                                        context,
                                        () {
                                          setState(() {
                                            _launchAR(modelURL);
                                          });
                                        },
                                        OneImages.icons_ar_launch_arcore,
                                        "Đặt mô hình trong không gian thực",
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(color: const Color.fromARGB(255, 0, 183, 255), borderRadius: BorderRadius.circular(10), boxShadow: const [
                                                BoxShadow(color: OneColors.grey, blurRadius: 4),
                                              ]),
                                              child: Center(
                                                child: Text(
                                                  "Đóng",
                                                  style: OneTheme.of(context).body1,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    // onTap: () {
                    //   _launchAR(modelURL);
                    // },
                    child: Container(
                      height: 81,
                      width: 81,
                      decoration: BoxDecoration(
                        color: OneColors.bgButton,
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: OneColors.grey,
                            blurRadius: 4,
                          ),
                        ],
                        border: Border.all(color: OneColors.white, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: SvgPicture.asset(OneImages.icons_ar_view),
                      ),
                    ),
                  ),
                  Text(
                    "AR",
                    style: OneTheme.of(context).title1.copyWith(color: OneColors.black, fontSize: 25, fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemARCatagory(BuildContext context, var onTap, String imageIcon, String title) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        height: 80,
        width: AppContants.sizeWidth - 100,
        decoration: BoxDecoration(color: OneColors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [
          BoxShadow(color: OneColors.grey, blurRadius: 4),
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 40,
              child: Image.asset(
                imageIcon,
                fit: BoxFit.fitHeight,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
                child: Text(
              title,
              style: OneTheme.of(context).body2.copyWith(color: OneColors.black),
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildNamePlanets(
    String nameModel,
    BuildContext context,
    String modelURL,
    var currentUser,
    String idName,
  ) {
    return // Tên Hành tinh
        Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: (idName != "saotho") ? 20 : 30, left: 24),
          child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                nameModel.toUpperCase(),
                style: OneTheme.of(context).header.copyWith(color: OneColors.black, letterSpacing: 5, fontSize: 35),
              )),
        ),
      ],
    );
  }

  SliverToBoxAdapter _buildDiscovery(double sizeHeight, double sizeWidth) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 70,
              child: StreamBuilder(
                  stream: discoverydata.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {}
                    if (snapshot.hasData) {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot records = snapshot.data!.docs[index];
                          String? name = records["name"];
                          String? image2DUrl = records["images"]["image2DUrl"];
                          List tags = records["tags"];
                          return _buildCardItemsSatellite(tags, records, name, context, image2DUrl);
                        },
                      );
                    }

                    return Container();
                  }),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Padding _buildCardItemsSatellite(List<dynamic> tags, DocumentSnapshot<Object?> records, String? name, BuildContext context, String? image2DUrl) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: tags.map((i) {
            if (i == idmain) {
              return InkWell(
                onTap: () {
                  Get.to(() => DiscoveryDetailScreen(argument: records, color: const Color.fromARGB(255, 197, 165, 247)), curve: Curves.linear, transition: Transition.rightToLeft);
                },
                child: SizedBox(
                  height: 70,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(color: OneColors.white, borderRadius: BorderRadius.circular(15), boxShadow: const [
                                BoxShadow(
                                  color: OneColors.grey,
                                  blurRadius: 4,
                                )
                              ]),
                              width: 170,
                              height: 62,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  const SizedBox(height: 50, width: 50 // Default: 2
                                      ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      name ?? "",
                                      style: OneTheme.of(context).body1.copyWith(color: OneColors.black, fontSize: 12),
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: BlurFilter(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: AppContants.sizeHeight * 0.06,
                              child: CachedImage(
                                color: OneColors.grey,
                                imageUrl: image2DUrl ?? "",
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SizedBox(height: 50, child: CachedImage(imageUrl: image2DUrl ?? "")),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Container();
          }).toList()),
    );
  }

  SliverToBoxAdapter _buildListInfo(infoOther, BuildContext context, bool readmore) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 0, top: 20),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              (infoOther["density"] != "") ? _buildItemsInfoOther(context, infoOther, "MẬT ĐỘ", "${infoOther["density"]}\u00B3") : const SizedBox(),
              (infoOther["radius"] != "") ? _buildItemsInfoOther(context, infoOther, "BÁN KÍNH", "${infoOther["radius"]}") : const SizedBox(),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              (infoOther["acreage"] != "") ? _buildItemsInfoOther(context, infoOther, "DIỆN TÍCH", "${infoOther["acreage"]}\u00B2") : const SizedBox(),
              (infoOther["cycle"] != "") ? _buildItemsInfoOther(context, infoOther, "CHU KỲ QUAY", "${infoOther["cycle"]}") : const SizedBox(),
            ]),
            readmore == true
                ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    (infoOther["gravitation"] != "") ? _buildItemsInfoOther(context, infoOther, "TRỌNG LỰC", "${infoOther["gravitation"]}\u00B2") : const SizedBox(),
                    (infoOther["distance"] != "") ? _buildItemsInfoOther(context, infoOther, "KHOẢNG CÁCH", "${infoOther["distance"]}") : const SizedBox(),
                  ])
                : const SizedBox(),
            readmore == true
                ? (infoOther["trajectory"] != "")
                    ? _buildItemsInfoOther(context, infoOther, "QUỸ ĐẠO", "${infoOther["trajectory"]}")
                    : const SizedBox()
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Padding _buildItemsInfoOther(BuildContext context, infoOther, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: OneTheme.of(context).body1.copyWith(color: OneColors.grey, fontSize: 12)),
          const SizedBox(height: 5),
          Container(
            height: 51,
            width: 153,
            decoration: BoxDecoration(
              border: Border.all(color: OneColors.grey, width: 1),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Center(child: Text(subtitle, style: OneTheme.of(context).body1.copyWith(color: OneColors.black))),
          )
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildVideoPlayer() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Stack(children: [
            Center(
              child: _chewieVideoPlayer(),
            ),
          ]),
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
            style: OneTheme.of(context).body2.copyWith(fontSize: 16, color: OneColors.black),
            trimLines: 3,
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
                InkWell(onTap: () {}, child: const Icon(Icons.nightlight_rounded, color: OneColors.black)),
                Text(" ${infoOther["satelliteNumber"]}", style: OneTheme.of(context).body1.copyWith(color: OneColors.black)),
              ],
            ),
            Row(
              children: [
                Text("Tuổi : ", style: OneTheme.of(context).body1.copyWith(color: OneColors.black)),
                Text("${infoOther["age"]}", style: OneTheme.of(context).body1.copyWith(color: OneColors.black)),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.device_thermostat, color: OneColors.black),
                Text("${infoOther["temperature"]} \u00B0C", style: OneTheme.of(context).body1.copyWith(color: OneColors.black)),
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
            height: AppContants.sizeWidth * 0.45,
            width: AppContants.sizeWidth * 0.8,
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
                height: AppContants.sizeWidth * 0.45,
                width: AppContants.sizeWidth * 0.8,
                decoration: BoxDecoration(
                  color: OneColors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
          );
  }

  SliverToBoxAdapter _buildImage2DDetail(
    String nameModel,
    BuildContext context,
    dynamic widget,
    String modelURL,
    double sizeHeight,
    double sizeWidth,
    String image2DUrl,
    String colorModel,
    var currentUser,
    String idName,
  ) {
    return SliverToBoxAdapter(
      child: Hero(
        tag: 'planets',
        child: Stack(clipBehavior: Clip.none, children: [
          if (checkstate == false)
            Positioned(
                top: 15,
                right: -sizeWidth * 0.2 + 10,
                child: SizedBox(
                  height: sizeHeight * 0.35 + 5,
                  child: BlurFilter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CachedImage(
                        color: Color(int.parse(colorModel)),
                        imageUrl: image2DUrl,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ))
          else
            const SizedBox(),
          if (checkstate == false)
            Positioned(
              top: 0,
              right: -sizeWidth * 0.2,
              child: SizedBox(
                  height: sizeHeight * 0.35,
                  child: CachedImage(
                    imageUrl: image2DUrl,
                    fit: BoxFit.fitHeight,
                  )),
            )
          else
            const SizedBox(),
          checkstate == false
              ? Positioned(
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
                )
              : const SizedBox(),
          Positioned(
            top: 70,
            left: 20,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                    color: OneColors.bgButton,
                    boxShadow: const [
                      BoxShadow(
                        color: OneColors.grey,
                        blurRadius: 4,
                      ),
                    ],
                    border: Border.all(color: OneColors.white, width: 1),
                    borderRadius: BorderRadius.circular(30)),
                child: const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Icon(Icons.arrow_back_ios, color: OneColors.white),
                ),
              ),
            ),
          ),
          checkstate == false
              ? Positioned(
                  top: sizeHeight * 0.3,
                  left: 0,
                  child: Container(
                    height: sizeHeight * 0.25,
                    color: OneColors.transparent,
                    child: _buildNamePlanets(nameModel, context, modelURL, currentUser, idName),
                  ),
                )
              : Positioned(
                  top: 70,
                  right: 20,
                  child: Container(
                    height: sizeHeight * 0.25,
                    color: OneColors.transparent,
                    child: _buildNamePlanets(nameModel, context, modelURL, currentUser, idName),
                  ),
                ),
          SizedBox(height: checkstate == false ? sizeHeight * 0.4 : 140),
        ]),
      ),
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
