// ignore_for_file: unused_element, unused_field

part of '../../../libary/one_libary.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference data = FirebaseFirestore.instance.collection("modeldata");
  final User? user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> _usersdataDataList = [];

  List<Map<String, dynamic>> _newsDataDataList = [];
  bool isLoading = true;

  @override
  void initState() {
    setState(() {});
    super.initState();
    getUserData().then((usersdata) {
      setState(() {
        isLoading = false;
        _usersdataDataList = usersdata;
      });
    });
    getHomeData().then((newssdata) {
      setState(() {
        _newsDataDataList = newssdata;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    AppContants.init(context);
    _newsDataDataList.sort((a, b) => b["date"].compareTo(a["date"]));
    return WillPopScope(
      onWillPop: () async {
        bool shouldExit = await showDialog(
          context: context,
          builder: (context) => const ExitConfirmationDialog(),
        );
        return shouldExit;
      },
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  OneImages.bg3,
                ),
                fit: BoxFit.fill)),
        child: AppScaffold(
            backgroundColor: OneColors.transparent,
            body: Scrollbar(
                child: CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: <Widget>[
                _buildTitle(context),
                _buildARBanner(context),
                _buildListPlanets(context),
                _buildItems(context),
                _buildTopNewsCard(context),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ))),
      ),
    );
  }

  SliverToBoxAdapter _buildARBanner(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: AppContants.sizeHeight * 0.25,
        margin: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [BoxShadow(color: OneColors.grey, blurRadius: 4)],
            color: OneColors.white,
            image: const DecorationImage(image: AssetImage(OneImages.bg_future_ar), fit: BoxFit.cover)),
        child: Stack(
          children: [
            Container(
              alignment: Alignment.topRight,
              margin: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
              child: Opacity(
                opacity: 0.7,
                child: Container(
                    alignment: Alignment.center,
                    height: AppContants.sizeHeight * 0.2,
                    width: 100,
                    child: Image.asset(
                      OneImages.augmented_reality,
                      fit: BoxFit.cover,
                    )),
              ),
            ),
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
                                _itemARCatagory(
                                  context,
                                  () {
                                    Navigator.pop(context); // Đóng modal
                                    Get.to(() => const ArScreen(
                                          isScan: true,
                                        ));
                                    // Get.toNamed(AppRoutes.ARTIFICIAL_SCREEN.name);
                                    // Get.toNamed(AppRoutes.MULTIPLE_AUGMENTED_IMAGES.name);
                                  },
                                  OneImages.icons_ar_scan,
                                  "Quét hình ảnh trong không gian thực",
                                ),
                                _itemARCatagory(
                                  context,
                                  () {
                                    // Get.toNamed(AppRoutes.DISCOVERY_SCREEN.name);
                                    Navigator.pop(context); // Đóng modal
                                    Get.to(() => const ArScreen());
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
              child: Container(
                alignment: Alignment.bottomRight,
                margin: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
                child: Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: 100,
                  decoration: BoxDecoration(color: OneColors.black.withOpacity(1), borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    "Khám Phá",
                    style: OneTheme.of(context).header.copyWith(fontSize: 13, color: OneColors.white),
                  ),
                ),
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

  SliverToBoxAdapter _buildTopNewsCard(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dành cho bạn",
                style: OneTheme.of(context).header.copyWith(fontSize: 18, color: OneColors.white),
              ),
              const SizedBox(height: 10),
              SizedBox(height: 163, child: _buildNewsCard(context)),
            ],
          )),
    );
  }

  Widget _buildNewsCard(BuildContext context) {
    return Column(
      children: _newsDataDataList
          .take(1)
          .map((data) => InkWell(
                onTap: (() {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(animation),
                          child: child,
                        );
                      },
                      pageBuilder: (context, animation, secondaryAnimation) => DetailNewsScreen(argument: data, viewscheck: false),
                    ),
                  );
                }),
                child: Container(
                  decoration: BoxDecoration(color: OneColors.bgButton, borderRadius: BorderRadius.circular(14), boxShadow: const [
                    BoxShadow(
                      color: OneColors.grey,
                      blurRadius: 4,
                    )
                  ]),
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: _buildImageCard(data)),
                      Expanded(
                          flex: 1,
                          child: SizedBox(
                            child: _buildTitleCard(data, context),
                          )),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }

  Row _buildViewCountCard(String Function(int views) formatViews, Map<String, dynamic> data, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Icon(
          Icons.visibility,
          color: OneColors.white,
          size: 10,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          "${formatViews(data["views"])} views",
          style: OneTheme.of(context).body2.copyWith(
                overflow: TextOverflow.clip,
                fontSize: 10,
                fontWeight: FontWeight.w300,
                color: OneColors.white,
              ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Row _buildAuthorCard(Map<String, dynamic> data, BuildContext context) {
    DateTime now = DateTime.now();
    Timestamp time = data["date"];
    DateTime otherDateTime = DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);
    Duration difference = now.difference(otherDateTime);
    int seconds = difference.inSeconds;
    int minutes = difference.inMinutes;
    int hours = difference.inHours;
    int days = difference.inDays;
    int weeks = (difference.inDays / 7).floor();
    var theme = OneTheme.of(context);
    return Row(
      children: [
        const Icon(
          Icons.date_range_outlined,
          color: OneColors.white,
          size: 10,
        ),
        const SizedBox(
          width: 5,
        ),
        Column(
          children: [
            // Text(
            //   "${data["author"]}",
            //   style: OneTheme.of(context).body2.copyWith(color: OneColors.white, fontSize: 5),
            //   maxLines: 1,
            //   overflow: TextOverflow.ellipsis,
            //   textAlign: TextAlign.justify,
            // ),
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
    );
  }

  Text _buildTimeCard(int seconds, OneThemeData theme, String time) {
    return Text(
      time,
      style: theme.body2.copyWith(overflow: TextOverflow.clip, fontSize: 10, fontWeight: FontWeight.w300, color: OneColors.white),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildImageCard(Map<String, dynamic> data) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: OneColors.white,
            blurRadius: 3,
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      height: 163,
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
    );
  }

  Widget _buildTitleCard(Map<String, dynamic> data, BuildContext context) {
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

    return Padding(
      padding: const EdgeInsets.only(right: 10.0, left: 10, top: 10, bottom: 10),
      child: SizedBox(
        height: 143,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              data["title"],
              style: OneTheme.of(context).title1.copyWith(color: OneColors.white, fontSize: 15),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.justify,
            ),
            // Text(
            //   data["titleDisplay"],
            //   style: OneTheme.of(context).body2.copyWith(color: OneColors.white, fontSize: 9),
            //   maxLines: 5,
            //   overflow: TextOverflow.ellipsis,
            //   textAlign: TextAlign.justify,
            // ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data["author"],
                  style: OneTheme.of(context).title1.copyWith(color: OneColors.white, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildAuthorCard(data, context),
                    _buildViewCountCard(formatViews, data, context),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildItems(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Lối tắt",
                style: OneTheme.of(context).header.copyWith(fontSize: 18, color: OneColors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // _buildCardItems(context, OneImages.card_solar_system, "Hệ mặt\n trời", null),
                    // _buildCardItems(context, OneImages.card_galaxy, "Dải ngân\n hà", null),
                    _buildCardItems(context, OneImages.saturn, "Vệ tinh\n tự nhiên", () {
                      Get.toNamed(AppRoutes.DISCOVERY_SCREEN.name);
                    }),
                    _buildCardItems(context, OneImages.Rocket, "Công nghệ\n vũ trụ", () {
                      Get.toNamed(AppRoutes.ARTIFICIAL_SCREEN.name);
                    }),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // _buildCardItems(context, OneImages.card_solar_system, "Hệ mặt\n trời", null),
                  // _buildCardItems(context, OneImages.card_galaxy, "Dải ngân\n hà", null),
                  _buildCardItems(context, OneImages.logo_quiz_game, "Trò chơi", () {
                    Get.to(() => const BottomNavigationBarWidget(setIndex: 3), curve: Curves.linear, transition: Transition.rightToLeft);
                  }),
                  _buildCardItems(context, OneImages.icons_person, "Tài khoản", () {
                    Get.to(() => const BottomNavigationBarWidget(setIndex: 4), curve: Curves.linear, transition: Transition.rightToLeft);
                  }),
                ],
              ),
            ],
          )),
    );
  }

  InkWell _buildCardItems(BuildContext context, String images, String label, dynamic ontap) {
    AppContants.init(context);
    return InkWell(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          color: OneColors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: OneColors.grey,
              blurRadius: 4,
              offset: Offset(0, 4),
            )
          ],
        ),
        height: 67,
        width: AppContants.sizeWidth * 0.4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  images,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  label,
                  style: OneTheme.of(context).header.copyWith(fontSize: 12, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 90 + 22,
      leading: const SizedBox(),
      floating: false,
      pinned: true,
      backgroundColor: OneColors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Padding(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: _usersdataDataList
                      .where((element) => element["email"] == user?.email)
                      .take(1)
                      .map(
                        (e) => Row(
                          children: [
                            (e["avatarUrl"] != null && e["avatarUrl"] != "")
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      e["avatarUrl"],
                                    ),
                                    radius: 25,
                                  )
                                : Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: OneColors.blue300,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Image.asset(OneImages.avatars),
                                    )),
                            const SizedBox(width: 15),
                            Text(
                              "Hi, ${e["name"]}",
                              style: OneTheme.of(context).header.copyWith(fontSize: 19, color: OneColors.white),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),

                // Text(
                //   "Khám phá vũ trụ nào!",
                //   style: OneTheme.of(context).header.copyWith(fontSize: 23),
                // ),
              ],
            )),
      ),
    );
  }

  SliverToBoxAdapter _buildListPlanets(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 24, right: 24),
            child: Text(
              "Các hành tinh",
              style: OneTheme.of(context).header.copyWith(fontSize: 18, color: OneColors.white),
            ),
          ),
          SizedBox(
            height: 230,
            width: AppContants.sizeWidth,
            child: FutureBuilder<List<DocumentSnapshot>>(
              future: _getPlanetData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: OneLoading.space_loading_larget,
                  );
                }
                if (snapshot.hasData) {
                  return _buildPlanetCarousel(snapshot.data!);
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<DocumentSnapshot>> _getPlanetData() async {
    QuerySnapshot querySnapshot = await data.get();
    return querySnapshot.docs;
  }

  Widget _buildPlanetCarousel(List<DocumentSnapshot> planets) {
    return CarouselSlider.builder(
      options:
          CarouselOptions(height: 230, enlargeCenterPage: true, enlargeStrategy: CenterPageEnlargeStrategy.height, autoPlay: true, viewportFraction: 0.7, autoPlayInterval: const Duration(seconds: 5)),
      // physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      // shrinkWrap: true,
      // padding: EdgeInsets.zero,
      // scrollDirection: Axis.horizontal,
      itemCount: planets.length,
      itemBuilder: (context, index, realIndex) {
        final DocumentSnapshot records = planets[index];

        // Image colors
        var colors = records["image2D"]["colors"];
        String colorModel = colors["colorModel"];
        String colorGradientTop = colors["colorGradient"]["top"];
        String colorGradientBottom = colors["colorGradient"]["bottom"];

        return Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 10, left: 10, bottom: 10),
          child: InkWell(
            onTap: (() {
              Get.to(
                  () => PlanetDetailScreen(
                        argument: records,
                      ),
                  curve: Curves.linear,
                  transition: Transition.rightToLeft);
            }),
            child: SizedBox(
              child: Stack(
                children: [
                  // Tên + giới thiệu vắn tắt
                  Padding(
                    padding: const EdgeInsets.only(top: 45.0, left: 17),
                    // INFO IMAGE
                    child: _buildPlanetInfoCard(colorGradientBottom, colorGradientTop, records, context),
                  ),

                  // IMAGE 2D của các hành tinh
                  Align(alignment: Alignment.topCenter, child: _buildImagePlanets2D(colorModel, records, records["image2D"]["imageUrl"]))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  SizedBox _buildPlanetInfoCard(String colorGradientBottom, String colorGradientTop, DocumentSnapshot<Object?> records, BuildContext context) {
    String name = records["name"];
    return SizedBox(
      height: 170,

      // Card với màu gradient
      child: Container(
        padding: const EdgeInsets.all(15),
        width: 222,
        decoration: const BoxDecoration(
            color: Color(0xFF010D5B),
            borderRadius: BorderRadius.all(Radius.circular(23)),
            boxShadow: [
              BoxShadow(
                color: OneColors.grey,
                blurRadius: 4,
                offset: Offset(0, 4),
              )
            ],
            image: DecorationImage(
                image: AssetImage(
                  OneImages.cracked_ground,
                ),
                fit: BoxFit.cover)),

        // Info Planets + "Xem thêm" Button
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              name.toUpperCase(),
              style: OneTheme.of(context).header.copyWith(fontSize: 19, color: OneColors.white),
            ),
          ),
          // Text(
          //   records["info"],
          //   style: OneTheme.of(context).header.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
          //   textAlign: TextAlign.justify,
          //   maxLines: 4,
          //   overflow: TextOverflow.ellipsis,
          // ),
        ]),
      ),
    );
  }

  Container _buildImagePlanets2D(String colorModel, DocumentSnapshot<Object?> records, String imageUrl) {
    String idName = records["idName"];
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5fcafe).withOpacity(0.7),
            offset: const Offset(0.0, 50.0),
            blurRadius: (() {
              if (idName == "saotho") {
                return 60.0;
              }
              if (idName == "saokim") {
                return 80.0;
              }
              return 60.0;
            })(),
            spreadRadius: 2.0,
          )
        ],
      ),
      child: SizedBox(
        height: (() {
          if (idName == "saokim") {
            return 130.0;
          }
          return 120.0;
        })(),
      
        // backgroundColor: OneColors.transparent,
        // radius: (() {
        //   if (idName == "saotho") {
        //     return 100.0;
        //   }
        //   if (idName == "saokim") {
        //     return 75.0;
        //   }
        //   return 60.0;
        // })(),
        child: CachedImage(
          imageUrl: imageUrl,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}
