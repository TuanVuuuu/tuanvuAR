import 'package:babylonjs_viewer/babylonjs_viewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/src/components/one_colors.dart';
import 'package:flutter_application_1/src/components/one_theme.dart';
import 'package:flutter_application_1/src/components/one_thick_ness.dart';
import 'package:flutter_application_1/src/shared/app_scaffold.dart';
import 'package:flutter_application_1/src/widgets/ar_screen.dart';
import 'package:flutter_application_1/src/widgets/local_ar_web_view.dart';
import 'package:readmore/readmore.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Planet3DView extends StatefulWidget {
  const Planet3DView({
    Key? key,
    required this.argument,
  }) : super(key: key);

  final argument;

  @override
  State<Planet3DView> createState() => _Planet3DViewState();
}

class _Planet3DViewState extends State<Planet3DView> {
  final CollectionReference homedata = FirebaseFirestore.instance.collection("modeldata");
  List<String> url = [
    "https://firebasestorage.googleapis.com/v0/b/flutter-crud-33350.appspot.com/o/3D%20model%20Astronomy%2Fboombox.glb?alt=media&token=e907c5fb-dedf-4c0b-ae6f-501256de0683",
    "https://elegant-tanuki-0787ed.netlify.app/",
    "https://webar.cartmagician.com/7979_vũ/p24180c4840/489988/boombox.glb",
    "https://overbits.herokuapp.com/fbxgltf/",
    "https://webar.cartmagician.com/7979_vũ/p24182c4841/489992/mars.glb", // Mars AR
    "https://cartmagician.com/arview/v1?asset=5858ff3c-b8a3-4a5d-b9be-ec21c293da88&ar=off", // Earth 3D
    "https://cartmagician.com/arview/v1?asset=d949c66e-40ae-431f-9618-109c1e12c8ae&ar=off", // Mercury 3D
    "https://webar.cartmagician.com/7979_vũ/p24190c4843/490360/mercury.glb", // Mercury AR
    "https://ar-code.com/blog/video-tutorial-how-to-compress-reduce-the-file-size-of-a-3d-model-on-blender-glb-gltf-dae-fbx-obj", // link hướng dẫn chuyển đổi mô hình 3d glb sang gltf
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent, // Color for Android
        statusBarBrightness: Brightness.light, // Dark == white status bar -- for IOS.
      ),
    );

    String nameModel = (widget.argument["name"]);
    String infoModel = widget.argument["info"];
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 40),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LocalAndWebObjectsWidget(argument: widget.argument,)
                          //LocalAndWebObjectsView(argument: widget.argument),
                          ));
                },
                child: const Icon(Icons.add, color: Colors.transparent, size: 30),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            _build3DModel(nameModel),
          ],
        ));
  }

  Widget _buildBody(String nameModel, BuildContext context, String infoModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Column(
        children: [
          // Name Model Planet
          // _buildNamePlanet(nameModel, context),
          // INFO Model Planet
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: OneColors.grey,
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    // info Model
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        infoModel,
                        style: OneTheme.of(context).body2.copyWith(fontSize: 16),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                      ),
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

  Padding _build3DModel(String nameModel) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Stack(children: [
        // Chế độ hiển thị mô hình 3D
        Column(
          children: [
            Container(
              constraints: const BoxConstraints(
                maxHeight: 420,
              ),
              decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.zero,
              child:
                  //  BabylonJSViewer(
                  //   src: url[4],
                  // )
                  ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: WebView(
                  initialUrl: Uri.encodeFull(widget.argument["image3D"]["imageUrl"]),
                  debuggingEnabled: false,
                  backgroundColor: Colors.transparent,
                  javascriptMode: JavascriptMode.unrestricted,
                ),
              ),
            ),
          ],
        ),
        _build3DButton(),
      ]),
    );
  }

  Widget _build3DButton() {
    return Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: (() {
            Navigator.pop(context);
          }),
          child: Container(
            height: 70,
            width: 70,
            margin: const EdgeInsets.only(top: 10, right: 10),
            decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(20)),
            child: const Align(
                alignment: Alignment.bottomLeft,
                child: SizedBox(
                  height: 60,
                  width: 60,
                  //child: Image.asset("assets/images/3d_logo.png"),
                )),
          ),
        ));
  }
}
