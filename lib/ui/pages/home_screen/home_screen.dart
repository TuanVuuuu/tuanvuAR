// ignore_for_file: unused_element

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
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg/bg2.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scrollbar(
          child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          const BuildHomeHeader(),
          SliverToBoxAdapter(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Các hành tinh", style: OneTheme.of(context).header.copyWith(fontSize: 28, color: OneColors.white)),
                    const SizedBox(height: 5),
                    Text("Cùng Astronomy tìm hiểu về chúng nào !", style: OneTheme.of(context).title2.copyWith(fontSize: 16, color: OneColors.white)),
                  ],
                )),
          ),
          _buildListPlanets(context),
          _buildPlanetsAnimate(context),
        ],
      )),
    ));
  }

  SliverToBoxAdapter _buildPlanetsAnimate(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
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
                              _buillStarsDiscovery(sizeHeight, context),
                              const SizedBox(width: 20),
                              // Nhân tạo
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  height: sizeHeight * 0.15,
                                  child: Stack(children: [
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
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
                                            "Nhân tạo",
                                            style: OneTheme.of(context).header.copyWith(color: OneColors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        color: OneColors.transparent,
                                        height: sizeHeight * 0.08,
                                        child: Image.asset("assets/images/rocket1.png"),
                                      ),
                                    ),
                                  ]),
                                ),
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
                                          Text(
                                            "Let's go!",
                                            textAlign: TextAlign.start,
                                            style: OneTheme.of(context).body1.copyWith(color: OneColors.brandVNP, fontSize: 14),
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
                      "assets/images/khampha.png",
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ]),
              ),
            ],
          )),
    );
  }

  Widget _buillStarsDiscovery(double sizeHeight, BuildContext context) {
    return Expanded(
      flex: 1,
      child: SizedBox(
        height: sizeHeight * 0.15,
        child: Stack(children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DiscoveryScreen()));
              },
              child: Container(
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
                    "Các vì sao",
                    style: OneTheme.of(context).header.copyWith(color: OneColors.white),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              color: OneColors.transparent,
              height: sizeHeight * 0.08,
              child: Image.asset("assets/images/saochoi.png"),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildCirclePlanets() {
    return Container(
      height: 300,
      width: 300,
      color: OneColors.transparent,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [SizedBox(height: 40, width: 45, child: Image.asset("assets/images/planets_animate/Earth.png"))],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 60, right: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 40, width: 45, child: Image.asset("assets/images/planets_animate/Mercury.png", fit: BoxFit.fitHeight)),
                SizedBox(height: 40, width: 45, child: Image.asset("assets/images/planets_animate/Mars.png", fit: BoxFit.fitHeight)),
              ],
            ),
          ),
          Row(
            children: [
              SizedBox(height: 40, width: 85, child: Image.asset("assets/images/planets_animate/saturn.png", fit: BoxFit.fitHeight)),
              const SizedBox(width: 15),
              SizedBox(height: 120, width: 120, child: Image.asset("assets/images/planets_animate/Sun.png", fit: BoxFit.fitHeight)),
              const SizedBox(width: 35),
              SizedBox(height: 40, width: 45, child: Image.asset("assets/images/planets_animate/Neptune-1.png", fit: BoxFit.fitHeight)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 60, right: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 40, width: 45, child: Image.asset("assets/images/planets_animate/Venus.png", fit: BoxFit.fitHeight)),
                SizedBox(height: 40, width: 45, child: Image.asset("assets/images/planets_animate/Neptune.png", fit: BoxFit.fitHeight)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [SizedBox(height: 40, width: 45, child: Image.asset("assets/images/planets_animate/Uranus.png"))],
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildListPlanets(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Container(
            color: OneColors.transparent,
            height: 330,
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder(
                stream: data.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {}
                  if (snapshot.hasData) {
                    return CarouselSlider.builder(
                      options: CarouselOptions(
                        height: 350,
                        autoPlay: false,
                        reverse: true,
                        viewportFraction: 0.5,
                        enlargeCenterPage: true,
                      ),
                      // physics: const BouncingScrollPhysics(parent: BouncingScrollPhysics()),
                      // padding: EdgeInsets.zero,
                      // scrollDirection: Axis.horizontal,
                      // shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index, realIndex) {
                        final DocumentSnapshot records = snapshot.data!.docs[index];

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
                                child: Container(
                                  height: 250,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                                    boxShadow: [
                                      BoxShadow(color: OneColors.grey.withOpacity(0.2), offset: const Offset(5.0, 5.0), blurRadius: 10.0, spreadRadius: 2.0), //BoxShadow
                                      BoxShadow(color: OneColors.grey.withOpacity(0.2), offset: const Offset(0.0, 0.0), blurRadius: 0.0, spreadRadius: 0.0), //BoxShadow
                                    ],
                                  ),

                                  // Card với màu gradient
                                  child: Opacity(
                                    opacity: 0.8,
                                    child: Container(
                                      height: 252,
                                      width: 171,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(int.parse(colorGradientBottom)),
                                            Color(
                                              int.parse(colorGradientTop),
                                            )
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
                                          child: Align(
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
                                                      textAlign: TextAlign.justify,
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 20),
                                                  ],
                                                ),
                                              )),
                                        ),
                                        //Button "Xem thêm"
                                        Padding(
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
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                //const LocalAndWebObjectsView()
                                                                PlanetDetailScreen(
                                                                  argument: records,
                                                                )));
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
                                            )),
                                      ]),
                                    ),
                                  ),
                                ),
                              ),

                              // IMAGE 2D của các hành tinh
                              _buildImagePlanets2D(colorModel, records, records["image2D"]["imageUrl"])
                            ],
                          )),
                        );
                      },
                    );
                  }
                  return Container();
                }),
          ),
        ],
      ),
    );
  }

  Container _buildImagePlanets2D(String colorModel, DocumentSnapshot<Object?> records, String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(
              int.parse(colorModel),
            ).withOpacity(0.4),
            offset: const Offset(5.0, 5.0),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          )
        ],
      ),
      child: CircleAvatar(
        backgroundColor: OneColors.transparent,
        radius: 60,
        child: Image.network(imageUrl,
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              // if (loadingProgress?.cumulativeBytesLoaded != null) {
              //   WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
              //         Future.delayed(const Duration(milliseconds: 1600), () {
              //           checkLoadImage = false;
              //         });
              //       }));
              // } else {}
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  color: OneColors.brandVNP,
                  value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => Image.asset("assets/images/not_found.png")),
      ),
    );
  }
}
