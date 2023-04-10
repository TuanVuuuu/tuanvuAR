// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  final String url;
  const MyWebView({super.key, required this.url});

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OneColors.transparent,
      body: WebView(
        initialUrl: Uri.encodeFull(widget.url),
        debuggingEnabled: false,
        backgroundColor: OneColors.transparent,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }

  // Hàm
}
