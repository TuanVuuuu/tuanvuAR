import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/src/components/one_colors.dart';
import 'package:flutter_application_1/src/components/one_theme.dart';
import 'package:flutter_application_1/src/shared/app_scaffold.dart';
import 'package:readmore/readmore.dart';

class DiscoveryDetailScreen extends StatefulWidget {
  const DiscoveryDetailScreen({Key? key, required this.argument, required this.color}) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  final argument;
  // ignore: prefer_typing_uninitialized_variables
  final color;

  @override
  State<DiscoveryDetailScreen> createState() => _DiscoveryDetailScreenState();
}

class _DiscoveryDetailScreenState extends State<DiscoveryDetailScreen> {
  double? sizeHeight;
  double? sizeWidth;
  String? image2DUrl;
  String? name;
  String? info;

  @override
  Widget build(BuildContext context) {
    image2DUrl = widget.argument["images"]["image2DUrl"];
    name = widget.argument["name"];
    info = widget.argument["info"];
    List idname = widget.argument["idname"];
    sizeHeight = MediaQuery.of(context).size.height;
    sizeWidth = MediaQuery.of(context).size.width;

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
        appBar: AppBar(
          backgroundColor: OneColors.transparent,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: OneColors.white,
            ),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg/bg4.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Scrollbar(
              child: CustomScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: <Widget>[
              _buildImage(context),
              SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
                      child: Text(
                        name!,
                        style: OneTheme.of(context).header.copyWith(fontSize: 30, color: OneColors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: Row(
                          children: idname.map((i) {
                        return Container(
                          margin: const EdgeInsets.only(right: 10),
                          height: 20,
                          decoration: BoxDecoration(color: widget.color, borderRadius: BorderRadius.circular(20)),
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
                      }).toList()),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: ReadMoreText(
                        info!,
                        style: OneTheme.of(context).body2.copyWith(fontSize: 16, color: OneColors.white),
                        trimLines: 5,
                        textAlign: TextAlign.justify,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: " Xem thêm",
                        trimExpandedText: " ...Rút gọn",
                        lessStyle: OneTheme.of(context).body1.copyWith(color: OneColors.yellow),
                        moreStyle: OneTheme.of(context).body1.copyWith(color: OneColors.yellow),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
        ));
  }

  SliverToBoxAdapter _buildImage(BuildContext context) {
    return SliverToBoxAdapter(
        child: Container(
      color: OneColors.transparent,
      height: sizeHeight! * 0.4,
      width: sizeWidth!,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -sizeHeight! * 0.4,
            right: -sizeWidth! * 0.4,
            child: Container(
              height: sizeHeight!,
              width: sizeWidth!,
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: widget.color.withOpacity(0.2), blurRadius: 50, spreadRadius: 50)],
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: -sizeWidth! * 0.2,
            child: Container(
              height: sizeHeight! * 0.35,
              color: Colors.transparent,
              child: Image.network(
                image2DUrl ?? "",
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Positioned(
            top: sizeHeight! * 0.25,
            right: 0,
            child: Container(
              height: sizeHeight! * 0.25,
              color: Colors.transparent,
              child: Image.asset(
                "assets/images/rocket2.png",
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ],
      ),
    ));
  }
}