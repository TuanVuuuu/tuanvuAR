import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/components/one_images.dart';
import 'package:flutter_application_1/src/shared/firestore_helper.dart';
import 'package:flutter_application_1/ui/pages/favorites_screen/favorites_screen.dart';
import 'package:flutter_application_1/ui/pages/profile_screen/rank_user_screen.dart';
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
  Map<String, dynamic>? _mapCurrentUser;

  @override
  void dispose() {
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
    _loadCurrentUser();
    getUserData().then((usersdata) {
      setState(() {
        isLoading = false;
        _usersdataDataList = usersdata;
      });
    });
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

    return Container(
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
            slivers: [
              _buildTitleWelcome(context),
              _buildHeader(context),
              _buildTitle(context, "Lối tắt"),
              _buildGridItems(context),
              _buildTitle(context, "Khác"),
              _buildListShotcut(context),
            ],
          ))),
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
                        const Icon(Icons.arrow_back_ios, color: OneColors.white),
                        const SizedBox(width: 10),
                        Text("Trở về", style: OneTheme.of(context).body1.copyWith(color: OneColors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  SliverToBoxAdapter _buildListShotcut(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          // _buildShotcutItems(context, "Giới thiệu", const Icon(Icons.book), () {
          //   // Get.to(
          //   //     () => MyWebView(
          //   //           url: url,
          //   //         ),
          //   //     curve: Curves.linear,
          //   //     transition: Transition.rightToLeft);

          //   // Get.to(() => const MyApp(argument: ,));
          // }),
          _buildShotcutItems(context, "Đổi mật khẩu", const Icon(Icons.lock_clock), () {
            Get.toNamed(AppRoutes.FORGOT_PASSWORD.name);
          }),
          _buildShotcutItems(context, "Đăng xuất", const Icon(Icons.logout), () {
            Get.toNamed(AppRoutes.SIGN_OUT.name);
          }),
        ],
      ),
    );
  }

  Widget _buildShotcutItems(BuildContext context, String title, dynamic icons, Function()? ontap) {
    return InkWell(
      onTap: ontap,
      child: Container(
        margin: const EdgeInsets.only(top: 13, right: 27, left: 27),
        height: 53,
        decoration: BoxDecoration(color: OneColors.white, borderRadius: BorderRadius.circular(33), boxShadow: const [
          BoxShadow(
            color: OneColors.grey,
            blurRadius: 2,
            offset: Offset(0, 0),
          )
        ]),
        child: Row(children: [
          Expanded(flex: 1, child: icons),
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: OneTheme.of(context).title1.copyWith(color: OneColors.black),
            ),
          ),
        ]),
      ),
    );
  }

  SliverToBoxAdapter _buildGridItems(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _buildItemsRow(
                  context,
                  "Tài khoản",
                  const Icon(Icons.person, color: OneColors.blue200),
                  () {
                    Get.toNamed(AppRoutes.USER_DETAIL_INFO.name);
                  },
                ),
                _buildItemsRow(context, "Tin tức", const Icon(Icons.book, color: OneColors.pink), () {
                  Get.toNamed(AppRoutes.TOP_NEWS.name);
                }),
              ],
            ),
            Row(
              children: [
                _buildItemsRow(
                  context,
                  "Bảng xếp hạng",
                  const Icon(Icons.military_tech, color: OneColors.amber),
                  () {
                    Get.to(
                        () => RankUserScreen(
                              usersdataDataList: _usersdataDataList,
                            ),
                        curve: Curves.linear,
                        transition: Transition.rightToLeft);
                  },
                ),
                _buildItemsRow(
                  context,
                  "Yêu thích",
                  const Icon(Icons.favorite_border_outlined, color: OneColors.red),
                  () {
                    Get.to(() => const FavoritesScreen(), curve: Curves.linear, transition: Transition.rightToLeft);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Expanded _buildItemsRow(BuildContext context, String title, dynamic icon, Function()? onTap) {
    return Expanded(
        flex: 1,
        child: InkWell(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(right: 20, left: 20),
            height: 90,
            decoration: BoxDecoration(color: OneColors.white, borderRadius: BorderRadius.circular(8), boxShadow: const [
              BoxShadow(
                color: OneColors.grey,
                blurRadius: 2,
              )
            ]),
            child: Padding(
              padding: const EdgeInsets.only(left: 17.0, top: 16, bottom: 19),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                icon,
                Text(
                  title,
                  style: OneTheme.of(context).title1.copyWith(color: OneColors.black),
                ),
              ]),
            ),
          ),
        ));
  }

  SliverToBoxAdapter _buildTitle(BuildContext context, String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 20),
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

  SliverToBoxAdapter _buildHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 40, left: 10, right: 10, bottom: 10),
        child: Container(
          decoration: BoxDecoration(color: OneColors.white, borderRadius: BorderRadius.circular(54), boxShadow: const [BoxShadow(color: OneColors.grey, blurRadius: 4, offset: Offset(0, 4))]),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 33, left: 20, bottom: 33),
                child: Row(
                  children: [
                    (_mapCurrentUser?["avatarUrl"] != null && _mapCurrentUser?["avatarUrl"] != "")
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                              _mapCurrentUser?["avatarUrl"],
                            ),
                            radius: 25,
                          )
                        : _buildAvatars(),
                    const SizedBox(
                      width: 15,
                    ),
                    // _buildAvatars(),
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
              Column(
                children: _usersdataDataList
                    .where((element) => element["email"] == users!.email)
                    .take(1)
                    .map(
                      (e) => Text(
                        "EXP : ${e["scores"]} điểm",
                        style: OneTheme.of(context).header.copyWith(color: OneColors.brandVNP, fontSize: 13),
                      ),
                    )
                    .toList(),
              )
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

  Future<void> _loadCurrentUser() async {
    final Map<String, dynamic> leaderboard = await getCurrentUser();
    setState(() {
      _mapCurrentUser = leaderboard;
    });
  }
}
