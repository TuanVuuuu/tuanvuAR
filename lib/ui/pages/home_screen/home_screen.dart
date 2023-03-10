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

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: OneColors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: OneColors.transparent, // Color for Android
        statusBarBrightness: Brightness.light, // Dark == white status bar -- for IOS.
      ),
    );
    return AppScaffold(
        body: Container(
      decoration: OneWidget.background_bg2,
      child: Scrollbar(
          child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          _buildTitle(context),
          _buildListPlanets(context),
          _buildPlanetsAnimate(context),
        ],
      )),
    ));
  }

  Widget _buildTitle(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.165,
      leading: const SizedBox(),
      floating: false,
      pinned: true,
      backgroundColor: OneColors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1, left: 20, right: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Các hành tinh", style: OneTheme.of(context).header.copyWith(fontSize: 28, color: OneColors.white)),
                const SizedBox(height: 5),
                Text("Cùng Astronomy tìm hiểu về chúng nào !", style: OneTheme.of(context).title2.copyWith(fontSize: 16, color: OneColors.white)),
              ],
            )),
      ),
    );
  }

  SliverToBoxAdapter _buildPlanetsAnimate(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double sizeHeight = size.height;
    final double sizeWidth = size.width;
    return SliverToBoxAdapter(
      child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 10, top: 20, bottom: 70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text("Khám phá", style: OneTheme.of(context).header.copyWith(fontSize: 28, color: OneColors.white)),
              ),
              const SizedBox(height: 20),
              Center(
                child: Stack(children: [
                  Container(
                    width: sizeWidth * 0.9,
                    color: OneColors.transparent,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: [
                          SizedBox(
                            height: sizeHeight * 0.11,
                          ),
                          Container(
                            height: sizeHeight * 0.2,
                            width: sizeWidth * 0.9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xff00B2FF).withOpacity(0.8),
                                  const Color(0xff0AA9FA).withOpacity(0.8),
                                  const Color(0xff4670DA).withOpacity(0.8),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 30.0, left: 20, right: 20),
                                        child: Text(
                                          "Ngoài vũ trụ rộng lớn luôn có những điều mới lạ!",
                                          style: OneTheme.of(context).title1.copyWith(
                                                color: OneColors.white,
                                                fontSize: 18,
                                              ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              // Các vì sao
                              _buillStarsDiscovery(
                                sizeHeight,
                                context,
                                "Các vì sao",
                                Image.asset(OneImages.saochoi),
                              ),
                              const SizedBox(width: 20),
                              _buillStarsArtificial(
                                sizeHeight,
                                context,
                                "Nhân tạo",
                                Image.asset(OneImages.rocket1),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: sizeHeight * 0.10,
                            child: Stack(children: [
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: sizeHeight * 0.07,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(0xFF081C2D).withOpacity(0.4),
                                        const Color(0xFF0A3A5C).withOpacity(0.4),
                                        const Color(0xFF0C5B8D).withOpacity(0.4),
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Khám phá ngay thôi nào!",
                                            textAlign: TextAlign.start,
                                            style: OneTheme.of(context).body1.copyWith(color: OneColors.textGrey1, fontSize: 14),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Get.to(
                                                  () => const LocalAndWebObjectsWidget(
                                                      argument: "https://github.com/TuanVuuuu/tuanvu_assets/blob/tuanvu_03022023/assets/3d_images/satellite/animated_moon.glb?raw=true"),
                                                  curve: Curves.linear,
                                                  transition: Transition.rightToLeft,
                                                  duration: const Duration(milliseconds: 200));
                                            },
                                            child: Text(
                                              "Let's go!",
                                              textAlign: TextAlign.start,
                                              style: OneTheme.of(context).body1.copyWith(color: OneColors.brandVNP, fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: OneColors.transparent,
                    height: sizeHeight * 0.2,
                    width: sizeWidth * 0.9,
                    child: Image.asset(
                      OneImages.khampha,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ]),
              ),
            ],
          )),
    );
  }

  Widget _buillStarsArtificial(double sizeHeight, BuildContext context, String title, Image images) {
    return Expanded(
      flex: 1,
      child: SizedBox(
        height: sizeHeight * 0.15,
        child: Stack(children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                Get.to(() => const ArtificialScreen(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 200));
              },
              child: _gradientBox(sizeHeight, title, context),
            ),
          ),
          _alignTopRightImage(sizeHeight, images),
        ]),
      ),
    );
  }

  Align _alignTopRightImage(double sizeHeight, Image images) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        color: OneColors.transparent,
        height: sizeHeight * 0.08,
        child: images,
      ),
    );
  }

  Container _gradientBox(double sizeHeight, String title, BuildContext context) {
    return Container(
      height: sizeHeight * 0.12,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        gradient: LinearGradient(
          colors: [
            const Color(0xff00B2FF).withOpacity(0.4),
            const Color(0xff0AA9FA).withOpacity(0.4),
            const Color(0xff4670DA).withOpacity(0.4),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: OneTheme.of(context).header.copyWith(color: OneColors.white),
        ),
      ),
    );
  }

  Widget _buillStarsDiscovery(double sizeHeight, BuildContext context, String title, Image images) {
    return Expanded(
      flex: 1,
      child: SizedBox(
        height: sizeHeight * 0.15,
        child: Stack(children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                Get.to(() => const DiscoveryScreen(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 200));
              },
              child: _gradientBox(sizeHeight, title, context),
            ),
          ),
          _alignTopRightImage(sizeHeight, images),
        ]),
      ),
    );
  }

  SliverToBoxAdapter _buildListPlanets(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          SizedBox(
            height: 330,
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
    return CarouselSlider.builder(
      options: CarouselOptions(
        height: 350,
        autoPlay: false,
        reverse: true,
        viewportFraction: 0.5,
        enlargeCenterPage: true,
      ),
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
          child: SizedBox(
            child: Stack(
              children: [
                // Tên + giới thiệu vắn tắt
                Padding(
                  padding: const EdgeInsets.only(top: 48.0, left: 17),
                  // INFO IMAGE
                  child: _buildPlanetInfoCard(colorGradientBottom, colorGradientTop, records, context),
                ),

                // IMAGE 2D của các hành tinh
                _buildImagePlanets2D(colorModel, records, records["image2D"]["imageUrl"])
              ],
            ),
          ),
        );
      },
    );
  }

  Container _buildPlanetInfoCard(String colorGradientBottom, String colorGradientTop, DocumentSnapshot<Object?> records, BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(40)),
        boxShadow: [
          OneWidget.boxshadow_offset_5, //BoxShadow
          OneWidget.boxshadow_offset_0, //BoxShadow
        ],
      ),

      // Card với màu gradient
      child: Container(
        height: 252,
        width: 171,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(int.parse(colorGradientBottom)),
              Color(int.parse(colorGradientTop)),
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(40)),
        ),

        // Info Planets + "Xem thêm" Button
        child: Stack(children: [
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 90, bottom: 30),
            decoration: const BoxDecoration(
                color: OneColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: OneColors.black,
                    offset: Offset(0.0, 3.0),
                    blurRadius: 5.0,
                    spreadRadius: 0.5,
                  )
                ]),
            // Name and Info planets
            child: _buildNameAndInfo(records, context),
          ),
          //Button "Xem thêm"
          _buildMoreButton(records),
        ]),
      ),
    );
  }

  Padding _buildMoreButton(DocumentSnapshot<Object?> records) {
    return Padding(
        padding: const EdgeInsets.only(top: 170),
        child: Center(
          child: Container(
            decoration: const BoxDecoration(shape: BoxShape.circle, color: OneColors.white, boxShadow: [
              BoxShadow(
                color: OneColors.black,
                offset: Offset(0.0, 5.0),
                blurRadius: 5.0,
                spreadRadius: 0.5,
              )
            ]),
            height: 40,
            width: 40,
            child: InkWell(
              onTap: (() {
                Get.to(
                    () => PlanetDetailScreen(
                          argument: records,
                        ),
                    curve: Curves.linear,
                    transition: Transition.rightToLeft);
              }),
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: OneColors.amber,
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_forward,
                    color: OneColors.white,
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Align _buildNameAndInfo(DocumentSnapshot<Object?> records, BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                records["name"] ?? "Trái đất",
                style: OneTheme.of(context).body1,
              ),
              const SizedBox(height: 5),
              Text(
                records["info"] ?? "Trái đất, hay còn được gọi là Địa cầu (Tiếng Anh : Earth, Tiếng Hán : ...",
                style: OneTheme.of(context).body1.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
                textAlign: TextAlign.justify,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ));
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
