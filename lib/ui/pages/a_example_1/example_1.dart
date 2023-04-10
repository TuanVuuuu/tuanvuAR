import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/components/loading/one_loading.dart';
import 'package:flutter_application_1/src/components/one_images.dart';
import 'package:flutter_application_1/src/shared/contant.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.argumentScan}) : super(key: key);

  final String argumentScan;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;

  bool isButtonVisible = true;
  bool isContainerPressed = false; //Thêm biến flag để theo dõi sự kiện bấm vào container

// Sử dụng hàm kiểm tra camera đã được mở hay chưa

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 35), () {
      setState(() {
        // Cập nhật trạng thái của widget ở đây
        isButtonVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    AppContants.init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: OneColors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
          Positioned(
            // top: - AppContants.sizeHeight * 0.6,
            child: GestureDetector(
              onTap: () {},
              child: widget.argumentScan != ""
                  ? SizedBox(
                      height: AppContants.sizeHeight,
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
                    )
                  : const SizedBox(),
            ),
          ),

          isButtonVisible == true
              ? Container(
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
                )
              : const SizedBox()
          // Sử dụng GestureDetector để xác định sự kiện bấm vào container

          // Positioned(
          //   bottom: 140,
          //   child: GestureDetector(
          //     onTap: () {
          //       setState(() {
          //         isContainerPressed = true; // Cập nhật giá trị của biến flag khi container được bấm
          //       });
          //     }, // Gọi hàm _handleContainerTap() khi container được bấm
          //     child: Container(
          //       margin: const EdgeInsets.symmetric(horizontal: 50),
          //       height: 100,
          //       width: AppContants.sizeWidth - 100,
          //       decoration: BoxDecoration(
          //         color: OneColors.amber,
          //         borderRadius: BorderRadius.circular(50),
          //         boxShadow: const [
          //           BoxShadow(color: OneColors.grey, blurRadius: 4),
          //         ],
          //       ),
          //       child: Padding(
          //         padding: const EdgeInsets.all(10),
          //         child: Center(
          //           child: Text(
          //             "Bắt đầu",
          //             style: OneTheme.of(context).header.copyWith(color: OneColors.black, fontSize: 30),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
