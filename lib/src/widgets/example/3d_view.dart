// ignore_for_file: file_names, duplicate_ignore, prefer_typing_uninitialized_variables

part of '../../../libary/one_libary.dart';

class P3DView extends StatefulWidget {
  const P3DView({
    Key? key,
    required this.argument,
  }) : super(key: key);

  final argument;

  @override
  State<P3DView> createState() => _P3DViewState();
}

class _P3DViewState extends State<P3DView> {
  final CollectionReference modeldata = FirebaseFirestore.instance.collection("modeldata");
  List<String> url = [
    "https://onedrive.live.com/?cid=22B8A031B559C726&id=22B8A031B559C726%21510&parId=22B8A031B559C726%21509&o=OneUp",
    "https://elegant-tanuki-0787ed.netlify.app/",
    "https://webar.cartmagician.com/7979_vũ/p24180c4840/489988/boombox.glb",
    "https://overbits.herokuapp.com/fbxgltf/",
    "https://cartmagician.com/arview/v1?asset=13e592b9-ce12-407d-a82f-525294c4503f&ar=off", // Sao Mộc 3D
    "https://webar.cartmagician.com/7979_vũ/p24182c4841/489992/mars.glb", // Mars AR
    "https://cartmagician.com/arview/v1?asset=5858ff3c-b8a3-4a5d-b9be-ec21c293da88&ar=off", // Earth 3D
    "https://cartmagician.com/arview/v1?asset=d949c66e-40ae-431f-9618-109c1e12c8ae&ar=off", // Mercury 3D
    "https://webar.cartmagician.com/7979_vũ/p24190c4843/490360/mercury.glb", // Mercury AR
    "https://ar-code.com/blog/video-tutorial-how-to-compress-reduce-the-file-size-of-a-3d-model-on-blender-glb-gltf-dae-fbx-obj", // link hướng dẫn chuyển đổi mô hình 3d glb sang gltf
  ];
  bool _delayCheck = false;

  void delay() {
    Future.delayed(const Duration(milliseconds: 7000), (() {
      if (_delayCheck != true) {
        if (mounted) {
          setState(() {
            _delayCheck = true;
          });
        }
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    delay();
    String imageUrl = widget.argument["image3D"]["imageUrl"];
    String idName = widget.argument["idName"];
    //String imageUrl = "https://webar.cartmagician.com/7979_vũ/p24183c4842/489996/earth.glb";
    //String imageUrl = url[0];
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: OneColors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: OneColors.transparent, // Color for Android
        statusBarBrightness: Brightness.light, // Dark == white status bar -- for IOS.
      ),
    );

    return Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          title: Text(
            widget.argument["name"],
            style: OneTheme.of(context).header.copyWith(color: OneColors.black),
          ),
          centerTitle: true,
          backgroundColor: OneColors.white,
          elevation: 2,
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: OneColors.black), onPressed: () => Navigator.pop(context)),
        ),
        backgroundColor: OneColors.white,
        body: Stack(
          children: [
            _build3DModel(imageUrl),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.only(top: 10, right: 15),
                height: 70,
                width: 70,
                decoration: const BoxDecoration(color: OneColors.white, shape: BoxShape.circle),
                child: const Icon(
                  Icons.view_in_ar,
                  size: 30,
                ),
              ),
            ),
            _buildMoreModel(context, idName),
          ],
        ));
  }

  Container _buildMoreModel(BuildContext context, String idName) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.48),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: OneColors.brandVNP,
            blurRadius: 10,
          )
        ],
        image: DecorationImage(
            image: AssetImage(
              OneImages.bg3,
            ),
            fit: BoxFit.fitWidth),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10),
              child: Container(
                height: 53,
                color: OneColors.transparent,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "Mọi người cũng tìm \nkiếm",
                              style: OneTheme.of(context).header.copyWith(color: OneColors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "Xem thêm hơn 10 mục khác",
                          style: OneTheme.of(context).caption1.copyWith(color: OneColors.white, fontWeight: FontWeight.w400),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          CardPlanets(
            data: modeldata,
            currentPlanets: idName,
          )
        ],
      ),
    );
  }

  SingleChildScrollView _build3DModel(String imageUrl) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.zero,
        child: Stack(children: [
          // Chế độ hiển thị mô hình 3D

          Column(
            children: [
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                // child: BabylonJSViewer(
                //   src: imageUrl,
                // ),
                child: Center(
                  child: WebView(
                    initialUrl: Uri.encodeFull(imageUrl),
                    debuggingEnabled: false,
                    backgroundColor: OneColors.white,
                    javascriptMode: JavascriptMode.unrestricted,
                    gestureNavigationEnabled: false,
                  ),
                ),
              ),
            ],
          ),

          _delayCheck != true
              ? Column(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.5,
                        maxWidth: MediaQuery.of(context).size.width,
                      ),
                      // BabylonJSViewer(
                      //   src: urlAR,
                      // ),
                      child: Center(child: OneLoading.space_loading),
                    ),
                  ],
                )
              : const SizedBox(),
        ]),
      ),
    );
  }
}
