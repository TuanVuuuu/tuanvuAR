// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/components/loading/one_loading.dart';
import 'package:flutter_application_1/src/components/one_images.dart';
import 'package:flutter_application_1/src/shared/firestore_helper.dart';
import 'package:flutter_application_1/src/widgets/search_button.dart';
import 'package:flutter_application_1/ui/pages/scan_ar_screen.dart/my_scan_ar_app.dart';
import 'package:get/get.dart';
import 'package:native_ar_viewer/native_ar_viewer.dart';
import 'dart:io' as io;

class ArScreen extends StatefulWidget {
  const ArScreen({super.key, this.isScan});

  final bool? isScan;

  @override
  State<ArScreen> createState() => _ArScreenState();
}

class _ArScreenState extends State<ArScreen> {
  List<Map<String, dynamic>> _discoverDataList = [];
  List<Map<String, dynamic>> _artificialDataList = [];
  List<Map<String, dynamic>> _filteredDataList = [];
  final scrollController = ScrollController();
  bool isSearchBar = false;
  final TextEditingController _searchTextController = TextEditingController();
  bool _isCleared = false;

  List islandImageList = [
    OneImages.ground,
    OneImages.flying_islands,
    OneImages.red_islands,
  ];

  @override
  void initState() {
    super.initState();
    getDiscoverData().then((discoverData) {
      setState(() {
        _discoverDataList = discoverData;
        _filteredDataList.addAll(_discoverDataList);
      });
    });
    getArtificialData().then((artificialData) {
      setState(() {
        _artificialDataList = artificialData;
        _filteredDataList.addAll(_artificialDataList);

        _filteredDataList = _filteredDataList.toSet().toList();
        // Sắp xếp các phần tử theo tên
        _filteredDataList.sort((a, b) => a["name"].compareTo(b["name"]));
      });
    });
  }

  void updateFilteredDataList(String searchTerm) {
    setState(() {
      if (searchTerm.isEmpty) {
        _filteredDataList = _discoverDataList + _artificialDataList;
        _filteredDataList.sort((a, b) => a["name"].compareTo(b["name"]));
      } else {
        _filteredDataList = (_discoverDataList + _artificialDataList).where((item) => item["name"].toLowerCase().contains(searchTerm.toLowerCase())).toList();
        _filteredDataList.sort((a, b) => a["name"].compareTo(b["name"]));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _filteredDataList.sort((a, b) => a["name"].compareTo(b["name"]));
    print("_filteredDataList.length : ${_filteredDataList.length}");
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: OneColors.transparent,
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
        floatingActionButton: OneFloatToTop(scrollController: scrollController),
        body: (_discoverDataList.isEmpty) ? _buildLoadingView(context, scrollController) : _buildDiscoverListView(context, scrollController, widget.isScan),
      ),
    );
  }

  Widget _buildDiscoverListView(BuildContext context, ScrollController scrollController, bool? isScan) {
    final size = MediaQuery.of(context).size;
    return Scrollbar(
      child: CustomScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: <Widget>[
          buildDiscoverHeader(context),
          !isSearchBar ? const SliverToBoxAdapter(child: SizedBox()) : _buildSearchField(context),
          const SliverToBoxAdapter(
            child: SizedBox(height: 15),
          ),
          SliverGrid.count(
            crossAxisCount: 2,
            children: List.generate(_filteredDataList.length, (index) {
              var records = _filteredDataList[index];
              String? name = records["name"];
              String? image2DUrl = records["images"]["image2DUrl"];
              String model3DScan = records["images"]["imageScan3D"];
              String model3DUrl = records["images"]["image3DUrl"];
              int ilandsId = records["ilandsId"];
              return InkWell(
                onTap: () {
                  // Xử lý khi người dùng nhấp vào item
                  isScan == true
                      ? model3DScan != ""
                          ? Get.to(() => MyScanARApp(
                                argumentScan: model3DScan,
                              ))
                          : {}
                      : {
                          setState(() {
                            _launchAR(model3DUrl);
                          })
                        };
                },
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 120,
                        width: 150,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            //color: Color.fromARGB(255, 115, 43, 156),
                            // borderRadius: BorderRadius.all(Radius.circular(23)),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: OneColors.grey,
                            //     blurRadius: 4,
                            //     offset: Offset(0, 4),
                            //   )
                            // ],
                            image: DecorationImage(
                                image: AssetImage(
                                  islandImageList[ilandsId].toString(),
                                ),
                                fit: BoxFit.fitWidth)),
                      ),
                    ),
                    Align(alignment: Alignment.bottomCenter, child: _buildName(name, context)),
                    Align(
                      alignment: Alignment.topCenter,
                      child: _buildImages(size.height, image2DUrl),
                    ),
                  ],
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  Align _buildName(String? name, BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0, top: 10),
        child: Text(
          "$name",
          style: OneTheme.of(context).caption1.copyWith(color: OneColors.white, fontSize: 16, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildImages(double sizeHeight, String? image2DUrl) {
    return Stack(
      children: [
        Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 30),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF5fcafe).withOpacity(0.5),
                    offset: const Offset(0.0, 50.0),
                    blurRadius: 40,
                    spreadRadius: 2.0,
                  )
                ],
              ),
              child: SizedBox(
                height: 80,
                child: CachedImage(
                  imageUrl: image2DUrl ?? "",
                  fit: BoxFit.scaleDown,
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildLoadingView(BuildContext context, ScrollController scrollController) {
    return Scrollbar(
      child: CustomScrollView(controller: scrollController, slivers: <Widget>[
        buildDiscoverHeader(context),
        SliverToBoxAdapter(
          child: Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Column(
                children: [
                  OneLoading.space_loading_larget,
                  Text(
                    "Đang tải dữ liệu",
                    style: OneTheme.of(context).header.copyWith(color: OneColors.white),
                  )
                ],
              )),
        ),
      ]),
    );
  }

  SliverToBoxAdapter buildDiscoverHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: OneColors.white,
              ),
            ),
            Text(
              "Danh sách",
              style: OneTheme.of(context).header.copyWith(color: OneColors.white),
            ),
            SearchButton(
              color: OneColors.white,
              isSearchBar: isSearchBar,
              onPressed: () {
                setState(() {
                  isSearchBar = !isSearchBar;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSearchField(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: const BorderRadius.all(
                Radius.circular(20.0),
              ),
              border: Border.all(color: OneColors.white, width: 1)),
          child: TextField(
            maxLength: 28,
            controller: _searchTextController,
            cursorColor: OneColors.white,
            style: OneTheme.of(context).title2.copyWith(color: OneColors.white),
            decoration: InputDecoration(
              counterText: "",
              hintText: "Search",
              hintStyle: OneTheme.of(context).title2.copyWith(color: OneColors.white, letterSpacing: 5),
              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              border: InputBorder.none,
              fillColor: OneColors.transparent,
              filled: true,
              suffixIconColor: OneColors.white,
              suffixIcon: IconButton(
                icon: _isCleared ? const Icon(Icons.close) : const Icon(Icons.close),
                onPressed: () {
                  if (_isCleared) {
                    _searchTextController.clear();
                    setState(() {
                      _isCleared = false;
                    });
                  }
                },
              ),
            ),
            onChanged: (text) {
              updateFilteredDataList(text);
              if (text.isNotEmpty) {
                setState(() {
                  _isCleared = true;
                });
              } else {
                setState(() {
                  _isCleared = false;
                });
              }
            },
          ),
        ),
      ),
    );
  }

  _launchAR(String model3DUrl) async {
    if (io.Platform.isAndroid) {
      await NativeArViewer.launchAR(model3DUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Platform not supported')));
    }
  }
}
