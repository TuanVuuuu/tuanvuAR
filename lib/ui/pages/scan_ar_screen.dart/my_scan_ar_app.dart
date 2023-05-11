import 'package:flutter/material.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/components/loading/one_loading.dart';
import 'package:flutter_application_1/src/components/one_images.dart';
import 'package:flutter_application_1/src/shared/contant.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MyScanARApp extends StatefulWidget {
  const MyScanARApp({Key? key, required this.argumentScan}) : super(key: key);

  final String argumentScan;

  @override
  State<MyScanARApp> createState() => _MyScanARAppState();
}

class _MyScanARAppState extends State<MyScanARApp> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;

  bool isButtonVisible = true;
  bool isContainerPressed = false; //Thêm biến flag để theo dõi sự kiện bấm vào container

// Sử dụng hàm kiểm tra camera đã được mở hay chưa

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 15), () {
      setState(() {
        // Cập nhật trạng thái của widget ở đây
        isButtonVisible = false;
      });
    });
  }

  @override
  void dispose(){
    super.dispose();
    isButtonVisible;
    isButtonVisible;
    webViewController;
    webViewKey;
  }

  @override
  Widget build(BuildContext context) {
    AppContants.init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: OneColors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: OneColors.white), onPressed: () => Navigator.pop(context)),
      ),
      backgroundColor: OneColors.white,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // BabylonJSViewer(
          //   src: imageUrl,
          // ),
          Positioned(
            top: -300,
            child: SizedBox(
              height: AppContants.sizeHeight + 600,
              width: AppContants.sizeWidth,
              child: InAppWebView(
                key: webViewKey,
                initialUrlRequest: URLRequest(
                  url: Uri.parse(widget.argumentScan),
                ),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    mediaPlaybackRequiresUserGesture: false,
                  ),
                ),
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                androidOnPermissionRequest: (InAppWebViewController controller, String origin, List<String> resources) async {
                  return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
                },
              ),
              // WebView(
              //   initialUrl: Uri.encodeFull(imageUrl),
              //   debuggingEnabled: false,
              //   backgroundColor: OneColors.transparent,
              //   javascriptMode: JavascriptMode.unrestricted,
              // ),
            ),
          ),
          isButtonVisible == true
              ? IgnorePointer(
                  child: Container(
                    height: AppContants.sizeHeight,
                    width: AppContants.sizeWidth,
                    decoration: const BoxDecoration(
                      color: OneColors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 200,
                          child: Image.asset(
                            OneImages.icons_ar_scan,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        //
                        SizedBox(
                          height: 200,
                          child: OneLoading.space_loading,
                        ),
                        Text(
                          "Đang tải dữ liệu! Vui lòng chờ...",
                          style: OneTheme.of(context).title1.copyWith(color: OneColors.black),
                        )
                      ],
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
