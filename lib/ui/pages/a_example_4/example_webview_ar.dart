import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MyWebView extends StatefulWidget {
  final String url;
  MyWebView({required this.url});

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  late WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
        },
        onPageStarted: (String url) async {
          if (await _requiresCameraPermission(url)) {
            _requestCameraPermission();
          }
        },
      ),
    );
  }

  // Hàm này kiểm tra xem trang web yêu cầu quyền truy cập camera hay không
  Future<bool> _requiresCameraPermission(String url) async {
    // Thay đổi đoạn mã này để phù hợp với yêu cầu truy cập máy ảnh của trang web của bạn
    return url.contains('/camera');
  }

  // Hàm này sẽ yêu cầu quyền truy cập camera
  void _requestCameraPermission() async {
    final status = await Permission.camera.request();
    final microphoneStatus = await Permission.microphone.request(); // Thêm dòng này
    if (status.isGranted && microphoneStatus.isGranted) {
      print('Camera permission granted');
    } else {
      print('Camera permission denied');
    }

    
  }
}
