import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_shadow_image/drop_shadow_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/src/components/button/one_button.dart';
import 'package:flutter_application_1/src/components/one_colors.dart';
import 'package:flutter_application_1/src/components/one_theme.dart';
import 'package:flutter_application_1/src/shared/app_scaffold.dart';
import 'package:flutter_application_1/src/widgets/one_news_widget/card_news.dart';
import 'package:flutter_application_1/src/widgets/one_news_widget/card_with_tags.dart';
import 'package:flutter_application_1/ui/pages/home_screen/planet_detail_screen.dart';
import 'package:flutter_application_1/ui/views/home_header.dart';
import 'dart:math' as math;

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
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent, // Color for Android
        statusBarBrightness: Brightness.light, // Dark == white status bar -- for IOS.
      ),
    );
    return AppScaffold(
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
        slivers: <Widget>[
          const BuildHomeHeader(),
          SliverToBoxAdapter(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Các hành tinh", style: OneTheme.of(context).header.copyWith(fontSize: 28, color: Colors.white)),
                    const SizedBox(height: 5),
                    Text("Cùng Astronomy tìm hiểu về chúng nào !", style: OneTheme.of(context).title2.copyWith(fontSize: 16, color: Colors.white)),
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
    return SliverToBoxAdapter(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Các hành tinh trong hệ mặt trời", style: OneTheme.of(context).header.copyWith(fontSize: 28, color: Colors.white)),
              const SizedBox(height: 20),
              Center(
                  child: Container(
                height: 300,
                width: 300,
                color: Colors.transparent,
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
                        SizedBox(height: 40, width: 45, child: Image.asset("assets/images/planets_animate/Mars.png", fit: BoxFit.fitHeight)),
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
              ))
            ],
          )),
    );
  }

  SliverToBoxAdapter _buildListPlanets(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder(
                stream: data.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    const Center(child: CircularProgressIndicator(color: Colors.blue));
                  }
                  if (snapshot.hasData) {
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(parent: BouncingScrollPhysics()),
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot records = snapshot.data!.docs[index];

                        // Image colors
                        var colors = records["image2D"]["colors"];
                        String colorModel = colors["colorModel"];
                        String colorGradientTop = colors["colorGradient"]["top"];
                        String colorGradientBottom = colors["colorGradient"]["bottom"];

                        return Padding(
                          padding: const EdgeInsets.only(top: 10.0, right: 10, left: 10),
                          child: SizedBox(
                              width: 188,
                              child: Stack(
                                children: [
                                  // Tên + giới thiệu vắn tắt
                                  Padding(
                                    padding: const EdgeInsets.only(top: 48.0, left: 17),
                                    // INFO IMAGE
                                    child: Container(
                                      height: 230,
                                      width: 171,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: const BorderRadius.all(Radius.circular(40)),
                                        boxShadow: [
                                          BoxShadow(color: Colors.grey.withOpacity(0.2), offset: const Offset(5.0, 5.0), blurRadius: 10.0, spreadRadius: 2.0), //BoxShadow
                                          BoxShadow(color: Colors.grey.withOpacity(0.2), offset: const Offset(0.0, 0.0), blurRadius: 0.0, spreadRadius: 0.0), //BoxShadow
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
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(20),
                                                    topRight: Radius.circular(20),
                                                    bottomLeft: Radius.circular(30),
                                                    bottomRight: Radius.circular(30),
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black,
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
                                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black,
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
                                                          color: Colors.amber,
                                                        ),
                                                        child: const Center(
                                                          child: Icon(
                                                            Icons.arrow_forward,
                                                            color: Colors.white,
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
        backgroundColor: Colors.transparent,
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
                  color: Colors.blue,
                  value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => Image.asset("assets/images/not_found.png")),
      ),
    );
  }
}
