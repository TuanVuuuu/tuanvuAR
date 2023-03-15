// ignore_for_file: library_private_types_in_public_api, unused_field, unused_local_variable, non_constant_identifier_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/components/loading/one_loading.dart';
import 'package:flutter_application_1/src/models/one_list_colors.dart';
import 'package:flutter_application_1/src/shared/firestore_helper.dart';
import 'package:flutter_application_1/src/widgets/search_button.dart';
import 'package:flutter_application_1/ui/pages/discovery_screen/discovery_detail_screen.dart';
import 'package:get/get.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  _DiscoveryScreenState createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  List<Map<String, dynamic>> _discoverDataList = [];
  List<Map<String, dynamic>> _filteredDataList = [];
  bool isLoading = true;
  final TextEditingController _searchTextController = TextEditingController();
  bool _isCleared = false;
  bool isSearchBar = false;
  @override
  void initState() {
    super.initState();
    getDiscoverData().then((discoverData) {
      setState(() {
        isLoading = false;
        _discoverDataList = discoverData;
        _filteredDataList = discoverData;
      });
    });
  }

  void searchData(String searchTerm) {
    setState(() {
      _filteredDataList = _discoverDataList.where((item) => item["name"].toLowerCase().contains(searchTerm.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: OneColors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent, // Color for Android
        statusBarBrightness: Brightness.light, // Dark == white status bar -- for IOS.
      ),
    );

    final size = MediaQuery.of(context).size;
    final scrollController = ScrollController();
    final random = Random();

    return AppScaffold(
      floatingActionButton: OneFloatToTop(scrollController: scrollController),
      body: _discoverDataList.isEmpty ? _buildLoadingView(context, scrollController) : _buildDiscoverListView(context, size, scrollController, random),
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
                    style: OneTheme.of(context).header.copyWith(color: OneColors.black),
                  )
                ],
              )),
        ),
      ]),
    );
  }

  Widget _buildDiscoverListView(BuildContext context, Size size, ScrollController scrollController, Random random) {
    return Scrollbar(
      child: CustomScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: <Widget>[
          buildDiscoverHeader(context),
          !isSearchBar ? const SliverToBoxAdapter(child: SizedBox()) : _buildSearchField(context),
          SliverList(
            delegate: SliverChildBuilderDelegate(childCount: _filteredDataList.length, (context, index) {
              var records = _filteredDataList[index];
              String? name = records["name"];
              String? image2DUrl = records["images"]["image2DUrl"];
              String? info = records["info"];
              List tags = records["tags"];
              int indexRandom = random.nextInt(OneColorRamdom.colors.length);
              return InkWell(
                onTap: () {
                  Get.to(
                      () => DiscoveryDetailScreen(
                            argument: records,
                            color: OneColorRamdom.colors[indexRandom],
                          ),
                      curve: Curves.linear,
                      transition: Transition.rightToLeft);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(color: OneColors.white, boxShadow: [BoxShadow(color: OneColors.grey, blurRadius: 4, offset: Offset(0, 5))]),
                  child: Row(
                    children: [
                      Container(
                        height: size.height * 0.16,
                        width: size.width - 40,
                        decoration: const BoxDecoration(color: OneColors.white),
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              _buildImages(size.height, image2DUrl),
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
            }),
          )
        ],
      ),
    );
  }

  Expanded _buildImages(double sizeHeight, String? image2DUrl) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: SizedBox(
          height: sizeHeight * 0.10,
          child: CachedImage(imageUrl: image2DUrl ?? ""),
        ),
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

  SliverToBoxAdapter buildDiscoverHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 50, bottom: 10, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: OneColors.black,
              ),
            ),
            Text(
              "Các vì sao",
              style: OneTheme.of(context).header.copyWith(color: OneColors.black),
            ),
            SearchButton(
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: const BorderRadius.all(
                Radius.circular(20.0),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
              border: Border.all(color: OneColors.black, width: 1)),
          child: TextField(
            // inputFormatters: [
            //   //FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z ]')),
            // ],
            maxLength: 28,
            controller: _searchTextController,
            cursorColor: OneColors.black,
            style: OneTheme.of(context).title2.copyWith(color: OneColors.black),
            decoration: InputDecoration(
              counterText: "",
              hintText: "Search",
              hintStyle: OneTheme.of(context).title2.copyWith(color: OneColors.grey, letterSpacing: 5),
              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              border: InputBorder.none,
              fillColor: OneColors.transparent,
              filled: true,
              suffixIconColor: OneColors.grey,
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
              searchData(text);
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
}
