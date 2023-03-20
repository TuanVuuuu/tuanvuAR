// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/components/one_images.dart';
import 'package:flutter_application_1/src/shared/firestore_helper.dart';
import 'package:flutter_application_1/ui/pages/a_example_1/example_1.dart';
// import 'package:flutter_application_1/ui/pages/a_example_2/arscreen3.dart';
import 'package:flutter_application_1/ui/pages/a_example_2/arscreen4.dart';
import 'package:flutter_application_1/ui/pages/a_example_3/arscreen5.dart';
// import 'package:flutter_application_1/ui/pages/a_example_1/example.dart';
import 'package:flutter_application_1/ui/pages/artificial_screen/artificial_screen.dart';
import 'package:flutter_application_1/ui/pages/auth_screen/forgot_password_screen.dart';
import 'package:flutter_application_1/ui/pages/auth_screen/sign_out.dart';
import 'package:flutter_application_1/ui/pages/auth_screen/user_detail_info_screen.dart';
import 'package:flutter_application_1/ui/pages/profile_screen/profile_screen.dart';
import 'package:flutter_application_1/ui/pages/quiz_manager_screen/quiz_manager_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' as io;

import 'package:native_ar_viewer/native_ar_viewer.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({
    Key? key,
    this.setIndex,
  }) : super(key: key);

  final int? setIndex;

  @override
  _BottomNavigationBarWidgetState createState() => _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  final User? user = FirebaseAuth.instance.currentUser;
  late PageController _pageController;
  int _pageIndex = 0;
  final List<Widget> _tabList = [
    const HomeScreen(),
    const TopNewsScreen(),
    const TopNewsScreen(),
    QuizManagerScreen(),
    const ProfileScreen(),
  ];

  List<Map<String, dynamic>> _usersdataDataList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
    getUserData().then((usersdata) {
      setState(() {
        isLoading = false;
        _usersdataDataList = usersdata;
      });
    });
    if (widget.setIndex != null) {
      _pageIndex = widget.setIndex!;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        backgroundColor: OneColors.transparent,
        shadowColor: OneColors.white,
        child: _buildSideBar(context, user),
      ),
      body: Stack(
        children: [
          _tabList.elementAt(_pageIndex),
          _buildBottomBar(),
          _buildButtonOpenSideBar(context),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                Get.to(
                  () => const MultipleAugmentedImagesPage(),
                  transition: Transition.rightToLeft,
                  duration: const Duration(milliseconds: 200),
                );
              },
              child: Container(
                height: 80,
                width: 80,
                margin: const EdgeInsets.only(bottom: 30),
                decoration: BoxDecoration(
                    color: OneColors.bgButton,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: OneColors.grey,
                        blurRadius: 5,
                      ),
                    ],
                    border: Border.all(color: OneColors.white, width: 1)),
                child: SvgPicture.asset(
                  OneImages.icons_ar_view,
                  height: 24,
                  width: 24,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              "AR",
              style: GoogleFonts.aBeeZee(
                fontWeight: FontWeight.w400,
                fontSize: 24,
                color: OneColors.black,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSideBar(BuildContext context, User? user) {
    return Builder(
      builder: (context) => Container(
        width: MediaQuery.of(context).size.width * 2 / 3,
        decoration: const BoxDecoration(
            color: OneColors.black50,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            )),
        // Nội dung của sidebar ở đây
        child: Column(
          children: [
            _buildHeaderSideBar(context),
            _buildHelloUser(context, user!),
            const SizedBox(height: 10),
            const OneThickNess(),
            _buildMenu(context),
            const OneThickNess(),
            const SizedBox(height: 10),
            _buildSetupAccount(context),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Padding _buildHeaderSideBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70, left: 0, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(50)),
              color: OneColors.white,
            ),
            child: IconButton(
              onPressed: () {
                Scaffold.of(context).closeEndDrawer();
              },
              icon: const Icon(
                Icons.double_arrow,
                color: OneColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildHelloUser(BuildContext context, User user) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10, right: 30),
      child: Row(
        children: [
          Container(
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
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Xin chào!",
                style: OneTheme.of(context).body1.copyWith(color: OneColors.white),
              ),
              Column(
                children: _usersdataDataList
                    .where((element) => element["email"] == user.email)
                    .take(1)
                    .map(
                      (e) => Text(
                        e["name"],
                        style: OneTheme.of(context).header.copyWith(color: OneColors.white),
                      ),
                    )
                    .toList(),
              ),
            ],
          )
        ],
      ),
    );
  }

  Column _buildMenu(BuildContext context) {
    return Column(
      children: [
        _itemsSideBar(context, "Trang chủ", Icons.home_filled, null, () {
          setState(() {
            _pageIndex = 0;
          });

          Scaffold.of(context).closeEndDrawer();
        }),
        _itemsSideBar(context, "Khám phá", Icons.support, null, () {
          setState(() {
            _pageIndex = 1;
          });

          Scaffold.of(context).closeEndDrawer();
        }),
        _itemsSideBar(context, "Trò chơi", Icons.extension, null, () {
          setState(() {
            _pageIndex = 3;
          });

          Scaffold.of(context).closeEndDrawer();
        }),
        _itemsSideBar(context, "Yêu thích", Icons.favorite, true, () {}),
        _itemsSideBar(context, "Vệ tinh nhân tạo", Icons.satellite_alt, null, () {
          Get.to(() => const ArtificialScreen(), curve: Curves.linear, transition: Transition.rightToLeft, duration: const Duration(milliseconds: 200));
        }),
        _itemsSideBar(context, "Chế độ xem thực tế ảo", Icons.view_in_ar, null, () {
          _launchAR(
            "https://firebasestorage.googleapis.com/v0/b/flutter-crud-33350.appspot.com/o/3D%20model%20Astronomy%2Fsolar_system.glb?alt=media&token=19d54abe-1789-4e43-8a62-8e287f10e7a9",
          );
        }),
      ],
    );
  }

  Column _buildSetupAccount(BuildContext context) {
    return Column(
      children: [
        _itemsSideBar(context, "Cài đặt tài khoản", null, null, () {}),
        _itemsSideBar(context, "Thông tin tài khoản", Icons.person, null, () {
          Get.to(
            () => const UserDetailInfoScreen(),
            curve: Curves.linear,
            transition: Transition.rightToLeft,
            duration: const Duration(milliseconds: 200),
          );
        }),
        _itemsSideBar(context, "Quên mật khẩu", Icons.lock_clock, null, () {
          Get.to(() => const ForgotPasswordScreen(), curve: Curves.linear, transition: Transition.rightToLeft, duration: const Duration(milliseconds: 200));
        }),
        _itemsSideBar(context, "Đăng xuất", Icons.logout, null, () {
          Get.to(() => SignOutScreen(), curve: Curves.linear, transition: Transition.rightToLeft, duration: const Duration(milliseconds: 200));
        }),
        _itemsSideBar(context, "Ar Screen", Icons.logout, null, () {
          //Get.to(() => const MySplashScreen(), curve: Curves.linear, transition: Transition.rightToLeft, duration: const Duration(milliseconds: 200));
          Get.to(() => const MultipleAugmentedImagesPage(), curve: Curves.linear, transition: Transition.rightToLeft, duration: const Duration(milliseconds: 200));
        }),
      ],
    );
  }

  Padding _itemsSideBar(BuildContext context, String title, IconData? icons, bool? checkUpdate, Function()? ontap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: ontap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                icons != null
                    ? Icon(
                        icons,
                        color: OneColors.white,
                      )
                    : const SizedBox(),
                icons != null
                    ? const SizedBox(
                        width: 15,
                      )
                    : const SizedBox(),
                Text(
                  title,
                  style: OneTheme.of(context).body1.copyWith(color: OneColors.white),
                )
              ],
            ),
            checkUpdate == true
                ? Text(
                    "Sắp có!",
                    style: OneTheme.of(context).body1.copyWith(color: OneColors.textOrange),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonOpenSideBar(BuildContext context) {
    return Builder(
      builder: (context) => Align(
        alignment: Alignment.topRight,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Scaffold.of(context).openEndDrawer();
              },
              child: Container(
                height: 55,
                width: 55,
                margin: const EdgeInsets.only(top: 70, right: 20),
                decoration: BoxDecoration(
                    color: OneColors.bgButton,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: OneColors.grey,
                        blurRadius: 5,
                      ),
                    ],
                    border: Border.all(color: OneColors.white, width: 1)),
                child: SvgPicture.asset(
                  OneImages.icons_chart,
                  height: 24,
                  width: 24,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.only(right: 0.0, left: 0),
      child: Align(
        alignment: const Alignment(0.0, 1.0),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          fixedColor: OneColors.black,
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.black,
          currentIndex: _pageIndex,
          onTap: (int index) {
            setState(() {
              _pageIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(OneImages.icons_home),
              label: "HOME",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(OneImages.icons_discover),
              label: "DISCOVER",
            ),
            const BottomNavigationBarItem(
              icon: SizedBox(
                height: 30,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(OneImages.icons_game),
              label: "GAME",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(OneImages.icons_personalcard),
              label: "PROFILE",
            ),
          ],
        ),
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
