// ignore_for_file: file_names, prefer_typing_uninitialized_variables, must_be_immutable

part of '../../../libary/one_libary.dart';

class Planet3DView extends StatelessWidget {
  Planet3DView({
    Key? key,
    required this.argument,
  }) : super(key: key);

  final argument;

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
        statusBarColor: OneColors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: OneColors.transparent, // Color for Android
        statusBarBrightness: Brightness.light, // Dark == white status bar -- for IOS.
      ),
    );

    String nameModel = (argument["name"]);
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: OneColors.transparent,
          elevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: OneColors.black), onPressed: () => Navigator.pop(context)),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 40),
              child: InkWell(
                onTap: () {
                  // Get.to(
                  //     () => LocalAndWebObjectsWidget(
                  //           // argument: argument,
                  //         ),
                  //     curve: Curves.linear,
                  //     transition: Transition.rightToLeft);
                },
                child: const Icon(Icons.add, color: OneColors.transparent, size: 30),
              ),
            ),
          ],
        ),
        backgroundColor: OneColors.white,
        body: Column(
          children: [
            _build3DModel(nameModel),
          ],
        ));
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
              decoration: BoxDecoration(color: OneColors.transparent, borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.zero,
              child:
                  //  BabylonJSViewer(
                  //   src: url[4],
                  // )
                  ClipRRect(
                borderRadius: BorderRadius.circular(100),
                // child: WebView(
                //   initialUrl: Uri.encodeFull(argument["image3D"]["imageUrl"]),
                //   debuggingEnabled: false,
                //   backgroundColor: OneColors.transparent,
                //   javascriptMode: JavascriptMode.unrestricted,
                // ),
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
            Navigator.pop;
          }),
          child: Container(
            height: 70,
            width: 70,
            margin: const EdgeInsets.only(top: 10, right: 10),
            decoration: BoxDecoration(color: OneColors.transparent, borderRadius: BorderRadius.circular(20)),
            child: const Align(
                alignment: Alignment.bottomLeft,
                child: SizedBox(
                  height: 60,
                  width: 60,
                )),
          ),
        ));
  }
}
