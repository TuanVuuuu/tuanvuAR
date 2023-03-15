// ignore_for_file: must_be_immutable, unused_element
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/components/one_images.dart';
import 'package:flutter_application_1/src/shared/firestore_helper.dart';
import 'package:flutter_application_1/src/widgets/one_news_widget/card_with_tags.dart';
import 'package:flutter_application_1/ui/pages/artificial_screen/artificial_screen.dart';
import 'package:flutter_application_1/ui/pages/auth_screen/user_detail_info_screen.dart';
import 'package:flutter_application_1/ui/pages/discovery_screen/discovery_screen.dart';
import 'package:flutter_application_1/ui/pages/quiz_manager_screen/quiz_manager_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String tagsButton = "";
  final User? users = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> _usersdataDataList = [];
  bool isLoading = true;
  bool _isFetching = false;
  StreamSubscription<int>? _subscription;

  @override
  void dispose() {
    _subscription?.cancel();
    _isFetching = false;
    super.dispose();
  }

  Future<void> fetchData() async {
    _isFetching = true;
    List<Map<String, dynamic>> fetchedData = await getUserData();
    if (_isFetching) {
      setState(() {
        _usersdataDataList = fetchedData;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    _subscription = Stream<int>.periodic(const Duration(seconds: 0)).listen((_) => fetchData());
    getUserData().then((usersdata) {
      setState(() {
        isLoading = false;
        _usersdataDataList = usersdata;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference data = FirebaseFirestore.instance.collection("homedata");
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent, // Color for Android
        statusBarBrightness: Brightness.light, // Dark == white status bar -- for IOS.
      ),
    );

    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
    return AppScaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(OneImages.bg3),
          fit: BoxFit.cover,
        ),
      ),
      child: Scrollbar(
          child: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          _buildHeader(context),
          _buildListItems(sizeWidth),
          _buildGame(context, sizeHeight),
          _buildTitle(context, "Dành cho bạn"),
          _buildGridViews(),
          _buildTitle(context, "Mới nhất"),
          CardNewsWithTags(
            data: data,
            tagsButton: tagsButton,
            cardLength: 1,
            style: true,
          )
        ],
      )),
    ));
  }

  SliverToBoxAdapter _buildTitle(BuildContext context, String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: OneTheme.of(context).title1.copyWith(color: OneColors.white),
            ),
          ],
        ),
      ),
    );
  }

  SliverGrid _buildGridViews() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          List title = ["Vệ tinh", "Nhân tạo", "Hệ Mặt trời", "Ngân Hà", "Sao chổi", "Ngày tận thế"];
          List items = [OneImages.Mercury, OneImages.rocket1, OneImages.solar_system, OneImages.galaxy, OneImages.saochoi, OneImages.doomsday];
          List ontap = [
            () {
              Get.to(() => const DiscoveryScreen(), curve: Curves.linear, transition: Transition.rightToLeft, duration: const Duration(milliseconds: 200));
            },
            () {
              Get.to(() => const ArtificialScreen(), curve: Curves.linear, transition: Transition.rightToLeft, duration: const Duration(milliseconds: 200));
            },
            () {},
            () {},
            () {},
            () {},
          ];
          return InkWell(
            onTap: ontap[index],
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 30),
              child: Container(
                decoration: BoxDecoration(
                  color: OneColors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(height: 60, width: 60, child: Image.asset(items[index])),
                      Text(title[index], style: OneTheme.of(context).body2.copyWith(color: OneColors.black)),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        childCount: 6,
      ),
    );
  }

  SliverToBoxAdapter _buildGame(BuildContext context, double sizeHeight) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Trò chơi",
              style: OneTheme.of(context).title1.copyWith(color: OneColors.white),
            ),
            InkWell(
                onTap: () {
                  Get.to(() => QuizManagerScreen(), curve: Curves.linear, transition: Transition.rightToLeft, duration: const Duration(milliseconds: 200));
                },
                child: _buildCardTitle(sizeHeight, context)),
          ],
        ),
      ),
    );
  }

  Column _buildCardTitle(double sizeHeight, BuildContext context) {
    return Column(
      children: [
        Container(
          height: sizeHeight * 0.2,
          margin: const EdgeInsets.only(top: 10, bottom: 20),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            color: OneColors.textOrange,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Expanded(
              flex: 1,
              child: Text(
                "Các Hành tinh trong hệ Mặt Trời",
                style: OneTheme.of(context).header.copyWith(color: OneColors.white),
              ),
            ),
            Expanded(
              flex: 1,
              child: SvgPicture.asset(OneImages.questions_undraw),
            ),
          ]),
        ),
      ],
    );
  }

  SliverToBoxAdapter _buildListItems(double sizeWidth) {
    return SliverToBoxAdapter(
        child: SizedBox(
      width: sizeWidth,
      height: 60,
      child: ListView.builder(
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          List itemsTitle = [
            Text("Tài khoản", style: OneTheme.of(context).body2),
            Text("Yêu thích", style: OneTheme.of(context).body2),
            Text("Cài đặt", style: OneTheme.of(context).body2),
            Text("Hỗ trợ", style: OneTheme.of(context).body2),
          ];
          List items = [
            const Icon(
              Icons.contact_page,
              color: OneColors.blue300,
            ),
            const Icon(
              Icons.favorite,
              color: OneColors.pink,
            ),
            const Icon(
              Icons.build,
              color: OneColors.black,
            ),
            const Icon(
              Icons.contact_support,
              color: OneColors.blue200,
            ),
          ];
          List ontap = [
            () {
              Get.to(() => const UserDetailInfoScreen(), curve: Curves.linear, transition: Transition.rightToLeft, duration: const Duration(milliseconds: 200));
            },
            () {},
            () {},
            () {},
          ];
          return InkWell(
            onTap: ontap[index],
            child: Container(
              height: 60,
              width: 80,
              margin: EdgeInsets.only(left: (sizeWidth - 80 * 4) / 5),
              decoration: BoxDecoration(color: OneColors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  items[index],
                  itemsTitle[index],
                ],
              ),
            ),
          );
        },
      ),
    ));
  }

  SliverToBoxAdapter _buildHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
        child: Container(
          decoration: BoxDecoration(color: OneColors.white, borderRadius: BorderRadius.circular(25)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 20, bottom: 40),
                child: Row(
                  children: [
                    _buildAvatars(),
                    _buildNameAndEmail(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildNameAndEmail(BuildContext context) {
    return isLoading == false
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserName(
                context,
                "name",
                OneTheme.of(context).body1.copyWith(color: OneColors.black),
              ),
              _buildUserName(
                context,
                "email",
                OneTheme.of(context).body2.copyWith(color: OneColors.black),
              ),
            ],
          )
        : Column(
            children: [
              Text(
                "Xin chào",
                style: OneTheme.of(context).body1.copyWith(color: OneColors.black),
              ),
            ],
          );
  }

  Container _buildAvatars() {
    return Container(
      height: 50,
      width: 50,
      margin: const EdgeInsets.only(right: 15),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: OneColors.blue300,
      ),
      child: Image.asset(OneImages.avatars),
    );
  }

  Column _buildUserName(BuildContext context, String feild, style) {
    return Column(
      children: _usersdataDataList
          .where((element) => element["email"] == users!.email)
          .take(1)
          .map(
            (e) => Text(
              "${e[feild]}",
              style: style ?? OneTheme.of(context).header.copyWith(color: OneColors.white),
            ),
          )
          .toList(),
    );
  }
}
