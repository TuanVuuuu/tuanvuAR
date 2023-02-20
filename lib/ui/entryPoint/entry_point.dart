// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/ui/pages/profile_screen/profile_screen.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({Key? key}) : super(key: key);

  @override
  _BottomNavigationBarWidgetState createState() => _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  late PageController _pageController;
  int _pageIndex = 0;
  final List<Widget> _tabList = [
    const HomeScreen(),
    const TopNewsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Padding(
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
                      icon: Icon(Icons.calendar_month),
                      label: "Trò chơi",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
