// ignore_for_file: unused_field, prefer_final_fields, avoid_print

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/components/loading/one_loading.dart';
import 'package:flutter_application_1/src/components/widget/one_blur.dart';
import 'package:flutter_application_1/src/models/one_list_colors.dart';
import 'package:flutter_application_1/src/shared/contant.dart';
import 'package:flutter_application_1/src/shared/firestore_helper.dart';
import 'package:flutter_application_1/ui/pages/discovery_screen/discovery_detail_screen.dart';
import 'package:get/get.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final User? users = FirebaseAuth.instance.currentUser;
  final CollectionReference data = FirebaseFirestore.instance.collection("users");
  final random = Random();
  Map<String, dynamic>? _mapCurrentUser;
  List<Map<String, dynamic>> _usersdataDataList = [];
  List<Map<String, dynamic>> _discoverDataList = [];

  List<Map<String, dynamic>> _favoriteItem = [];

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    getUserData().then((usersdata) {
      setState(() {
        _usersdataDataList = usersdata;
      });
    });
    getDiscoverData().then((discoverData) {
      setState(() {
        _discoverDataList = discoverData;
      });
      _printMatchingFavorites(); // Gọi hàm ở đây
    });
  }

  @override
  void dispose() {
    super.dispose();
    _mapCurrentUser;
    _printMatchingFavorites();
  }

  Future<void> _loadCurrentUser() async {
    final Map<String, dynamic> leaderboard = await getCurrentUser();
    setState(() {
      _mapCurrentUser = leaderboard;
    });
  }

  Future<void> _printMatchingFavorites() async {
    if (_mapCurrentUser == null || _discoverDataList.isEmpty) {
      return;
    }
    final List<String> favoriteIds = List<String>.from(_mapCurrentUser?["favorites"] ?? []);
    for (int i = 0; i < favoriteIds.length; i++) {
      final String id = favoriteIds[i];
      final Map<String, dynamic> matchingItem = _discoverDataList.firstWhere(
        (item) => item["idnew"] == id,
        orElse: () => {},
      );
      print("Matching item found: $matchingItem");
      _favoriteItem.add(matchingItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppContants.init(context);
    return AppScaffold(
      body: Scrollbar(
          child: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          _buildTitleWelcome(context),
          _mapCurrentUser?["favorites"].length != 0
              ? SliverToBoxAdapter(
                  child: SizedBox(
                      height: AppContants.sizeHeight,
                      child: (_mapCurrentUser?["favorites"].length == 0 || _favoriteItem.isEmpty)
                          ? Center(child: OneLoading.space_loading)
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                              itemCount: _favoriteItem.length,
                              itemBuilder: (context, index) {
                                String name = _favoriteItem[index]["name"] ?? "";
                                String image2DUrl = _favoriteItem[index]["images"]["image2DUrl"] ?? "";
                                String info = _favoriteItem[index]["info"] ?? "";
                                List tags = _favoriteItem[index]["tags"];
                                int indexRandom = random.nextInt(OneColorRamdom.colors.length);
                                return InkWell(
                                  onTap: () {
                                    Get.to(
                                        () => DiscoveryDetailScreen(
                                              argument: _favoriteItem[index],
                                              color: OneColorRamdom.colors[indexRandom],
                                            ),
                                        curve: Curves.linear,
                                        transition: Transition.rightToLeft);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 20, right: 20),
                                    decoration: const BoxDecoration(color: OneColors.white, boxShadow: [BoxShadow(color: OneColors.grey, blurRadius: 4, offset: Offset(0, 5))]),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: AppContants.sizeHeight * 0.16,
                                          width: AppContants.sizeWidth - 40,
                                          decoration: const BoxDecoration(color: OneColors.white),
                                          child: Container(
                                            margin: const EdgeInsets.all(8),
                                            child: Row(
                                              children: [
                                                _buildImages(AppContants.sizeHeight, image2DUrl),
                                                Expanded(
                                                  flex: 2,
                                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                    // Tên ngôi sao
                                                    _buildName(name, context),
                                                    // thông tin ngôi sao
                                                    _buildInfo(info, context),
                                                    // tags
                                                    _buildListTags(tags, context),
                                                    const OneThickNess()
                                                  ]),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )),
                )
              : SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: AppContants.sizeHeight * 0.45),
                    child: Center(
                      child: Text(
                        "Không có mô hình yêu thích",
                        style: OneTheme.of(context).title1.copyWith(color: OneColors.black),
                      ),
                    ),
                  ),
                ),
        ],
      )),
    );
  }

  Widget _buildTitleWelcome(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 70,
      leading: const SizedBox(),
      floating: false,
      pinned: true,
      backgroundColor: OneColors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Padding(
            padding: const EdgeInsets.only(top: 60, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.HOMESCREEN.name);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.arrow_back_ios, color: OneColors.black),
                        Expanded(child: Center(child: Text("Yêu thích", style: OneTheme.of(context).body1.copyWith(color: OneColors.black, fontSize: 20)))),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Row _buildListTags(List<dynamic> tags, BuildContext context) {
    return Row(
        children: tags.map((i) {
      return Container(
        margin: const EdgeInsets.only(left: 5),
        height: 20,
        decoration: BoxDecoration(color: OneColors.brandVNP.withOpacity(0.4), borderRadius: BorderRadius.circular(5)),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              i,
              style: OneTheme.of(context).body1.copyWith(color: OneColors.white, fontSize: 10),
            ),
          ),
        ),
      );
    }).toList());
  }

  Align _buildName(String? name, BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0),
        child: Text(
          "$name",
          style: OneTheme.of(context).caption1.copyWith(color: OneColors.black, fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Center _buildInfo(String? info, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          "$info",
          style: OneTheme.of(context).caption1.copyWith(
                color: OneColors.black,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
          maxLines: 3,
          textAlign: TextAlign.justify,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Expanded _buildImages(double sizeHeight, String? image2DUrl) {
    return Expanded(
      flex: 1,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: BlurFilter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: sizeHeight * 0.08,
                  child: CachedImage(
                    color: Colors.grey,
                    imageUrl: image2DUrl ?? "",
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SizedBox(
                height: sizeHeight * 0.1,
                child: CachedImage(imageUrl: image2DUrl ?? ""),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
