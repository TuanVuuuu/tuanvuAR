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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _newsDataDataList.sort((a, b) => b["date"].compareTo(a["date"]));
    return AppScaffold(
        body: Scrollbar(
            child: CustomScrollView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        _buildTitle(context),
        _buildListPlanets(context),
        _buildItems(context),
        _buildTopNewsCard(context),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    )));
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
                style: OneTheme.of(context).header.copyWith(fontSize: 23),
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
          "${formatViews(data["views"])} lượt xem",
          style: OneTheme.of(context).body2.copyWith(
                overflow: TextOverflow.clip,
                fontSize: 8,
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
      style: theme.body2.copyWith(overflow: TextOverflow.clip, fontSize: 8, fontWeight: FontWeight.w300, color: OneColors.white),
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
      padding: const EdgeInsets.only(right: 10.0, left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data["title"],
            style: OneTheme.of(context).title1.copyWith(color: OneColors.white, fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 10),
          Text(
            data["titleDisplay"],
            style: OneTheme.of(context).body2.copyWith(color: OneColors.white, fontSize: 9),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAuthorCard(data, context),
              _buildViewCountCard(formatViews, data, context),
            ],
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildItems(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 24, right: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCardItems(context, OneImages.card_solar_system, "Hệ mặt\n trời", null),
              _buildCardItems(context, OneImages.card_galaxy, "Dải ngân\n hà", null),
              _buildCardItems(context, OneImages.saturn, "Vệ tinh\n tự nhiên", () {
                Get.to(
                  () => const DiscoveryScreen(),
                  transition: Transition.rightToLeft,
                  duration: const Duration(milliseconds: 200),
                );
              }),
              _buildCardItems(context, OneImages.Rocket, "Công nghệ\n vũ trụ", () {
                Get.to(
                  () => const ArtificialScreen(),
                  transition: Transition.rightToLeft,
                  duration: const Duration(milliseconds: 200),
                );
              }),
            ],
          )),
    );
  }

  InkWell _buildCardItems(BuildContext context, String images, String label, dynamic ontap) {
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
        height: 100,
        width: 67,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                images,
              ),
              Text(
                label,
                style: OneTheme.of(context).header.copyWith(fontSize: 10, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
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
                        (e) => Text(
                          "Hi, ${e["name"]}",
                          style: OneTheme.of(context).header.copyWith(fontSize: 19),
                        ),
                      )
                      .toList(),
                ),
                Text(
                  "Khám phá vũ trụ nào!",
                  style: OneTheme.of(context).header.copyWith(fontSize: 23),
                ),
              ],
            )),
      ),
    );
  }

  SliverToBoxAdapter _buildListPlanets(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          SizedBox(
            height: 230,
            width: MediaQuery.of(context).size.width,
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
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      scrollDirection: Axis.horizontal,
      itemCount: planets.length,
      itemBuilder: (context, index) {
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
                  _buildImagePlanets2D(colorModel, records, records["image2D"]["imageUrl"])
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
          color: OneColors.white,
          borderRadius: BorderRadius.all(Radius.circular(23)),
          boxShadow: [
            BoxShadow(
              color: OneColors.grey,
              blurRadius: 4,
              offset: Offset(0, 4),
            )
          ],
        ),

        // Info Planets + "Xem thêm" Button
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Expanded(flex: 8, child: SizedBox()),
              Expanded(
                flex: 9,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    name.toUpperCase(),
                    style: OneTheme.of(context).header.copyWith(fontSize: 19),
                  ),
                ),
              ),
            ],
          ),
          Text(
            records["info"],
            style: OneTheme.of(context).header.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
            textAlign: TextAlign.justify,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
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
            color: (idName != "saotho")
                ? Color(
                    int.parse(colorModel),
                  ).withOpacity(0.4)
                : Color(
                    int.parse(colorModel),
                  ).withOpacity(0.1),
            offset: const Offset(5.0, 5.0),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          )
        ],
      ),
      child: CircleAvatar(
        backgroundColor: OneColors.transparent,
        radius: (idName != "saotho") ? 60 : 80,
        child: CachedImage(imageUrl: imageUrl),
      ),
    );
  }
}
