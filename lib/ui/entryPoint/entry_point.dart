// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/shared/firestore_helper.dart';
import 'package:flutter_application_1/ui/pages/artificial_screen/artificial_screen.dart';
import 'package:flutter_application_1/ui/pages/auth_screen/forgot_password_screen.dart';
import 'package:flutter_application_1/ui/pages/auth_screen/sign_out.dart';
import 'package:flutter_application_1/ui/pages/auth_screen/user_detail_info_screen.dart';
import 'package:flutter_application_1/ui/pages/profile_screen/profile_screen.dart';
import 'package:flutter_application_1/ui/pages/quiz_manager_screen/quiz_manager_screen.dart';
import 'package:get/get.dart';
import 'dart:io' as io;

import 'package:native_ar_viewer/native_ar_viewer.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({Key? key}) : super(key: key);

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
          PageView(
            controller: _pageController,
            onPageChanged: (int index) {
              setState(() {
                _pageIndex = index;
              });
            },
            children: _tabList,
          ),
          _buildBottomBar(),
          _buildButtonOpenSideBar(context)
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
          Text(
            "Astronomy",
            style: OneTheme.of(context).header.copyWith(color: OneColors.white),
          )
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
              color: OneColors.grey,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.person,
              size: 50,
            ),
          ),
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
          _pageController.animateToPage(_pageIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
          Scaffold.of(context).closeEndDrawer();
        }),
        _itemsSideBar(context, "Khám phá", Icons.support, null, () {
          setState(() {
            _pageIndex = 1;
          });
          _pageController.animateToPage(_pageIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
          Scaffold.of(context).closeEndDrawer();
        }),
        _itemsSideBar(context, "Trò chơi", Icons.extension, null, () {
          Get.to(() => QuizManagerScreen(), curve: Curves.linear, transition: Transition.rightToLeft, duration: const Duration(milliseconds: 200));

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
            Container(
              height: 50,
              width: 50,
              margin: const EdgeInsets.only(top: 70, right: 20),
              decoration: const BoxDecoration(color: OneColors.white, shape: BoxShape.circle, boxShadow: [
                BoxShadow(
                  color: OneColors.grey,
                  blurRadius: 5,
                )
              ]),
              child: IconButton(
                icon: const Icon(Icons.segment),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
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
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedIconTheme: const IconThemeData(color: Color(0xffC1EF00)),
            showSelectedLabels: true,
            showUnselectedLabels: false,
            fixedColor: Colors.white,
            backgroundColor: Colors.black.withOpacity(0.7),
            unselectedItemColor: Colors.white,
            currentIndex: _pageIndex,
            onTap: (int index) {
              setState(() {
                _pageIndex = index;
              });
              _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Trang chủ",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Khám Phá",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Hồ sơ",
              ),
            ],
          ),
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
