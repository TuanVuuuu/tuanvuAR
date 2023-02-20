// ignore_for_file: prefer_typing_uninitialized_variables

part of '../../../libary/one_libary.dart';

class LocalAndWebObjectsView extends StatefulWidget {
  const LocalAndWebObjectsView({
    Key? key,
    required this.argument,
  }) : super(key: key);

  final argument;

  @override
  State<LocalAndWebObjectsView> createState() => _LocalAndWebObjectsViewState();
}

class _LocalAndWebObjectsViewState extends State<LocalAndWebObjectsView> {
  List localModelList = [
    "assets/localModel2/scene.gltf",
    "assets/Chicken_01/3D_Planets/earth_day/scene.gltf",
    "assets/Chicken_01/3D_Planets/mars/scene.gltf",
  ];
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;

  //String localObjectReference;
  ARNode? localObjectNode;

  //String webObjectReference;
  ARNode? webObjectNode;

  @override
  void dispose() {
    arSessionManager.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 1,
                    child: ARView(
                      onARViewCreated: onARViewCreated,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.9),
                    child: Row(
                      children: [
                        // Expanded(
                        //   child: ElevatedButton(onPressed: onLocalObjectButtonPressed, child: const Text("Add / Remove Local Object")),
                        // ),
                        // const SizedBox(
                        //   width: 10,
                        // ),
                        _arButton(
                          context, true, widget.argument,
                          //widget.argument["image3D"]["imageARUrl"],
                        )
                      ],
                    ),
                  ),
                  _buildBackButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildBackButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1, left: 15),
      child: Row(
        children: [
          InkWell(
              onTap: (() {
                Navigator.pop(context);
              }),
              child: Row(
                children: [
                  Opacity(
                    opacity: 0.4,
                    child: Container(
                        decoration: BoxDecoration(
                          color: OneColors.grey,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Padding(padding: EdgeInsets.all(7), child: Icon(Icons.arrow_back_ios, color: OneColors.white))),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Expanded _arButton(BuildContext context, bool? label, String argument) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 70),
        child: Column(
          children: [
            Opacity(
              opacity: 0.4,
              child: InkWell(
                onTap: (() async {
                  // if (webObjectNode != null) {
                  //   arObjectManager.removeNode(webObjectNode!);
                  //   webObjectNode = null;
                  // } else {
                  //   var newNode = ARNode(type: NodeType.webGLB, uri: argument, scale: Vector3(1, 1, 1));
                  //   bool? didAddWebNode = await arObjectManager.addNode(newNode);
                  //   webObjectNode = (didAddWebNode!) ? newNode : null;
                  // }
                }),
                child: Container(
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                    color: OneColors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Image.asset(OneImages.arkit),
                      Text(
                        "AR",
                        style: OneTheme.of(context).title1.copyWith(color: OneColors.black),
                      )
                    ]),
                  ),
                ),
              ),
            ),
            label != true
                ? ElevatedButton(
                    child: const Text("Khởi chạy mô hình"),
                    onPressed: () {},
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  void onARViewCreated(ARSessionManager arSessionManager, ARObjectManager arObjectManager, ARAnchorManager arAnchorManager, ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;

    this.arSessionManager.onInitialize(
          showFeaturePoints: true,
          showPlanes: true,
          customPlaneTexturePath: "assets/triangle.png",
          showWorldOrigin: true,
          handleTaps: false,
          handleRotation: true,
          showAnimatedGuide: false,
        );
    setState(() {
      onLocalObjectButtonPressed(
        widget.argument,
        // widget.argument["image3D"]["imageARLocal"],
      );
    });

    this.arObjectManager.onInitialize();
  }

  Future<void> onLocalObjectButtonPressed(String uri) async {
    List<String> url = [
      "assets/localModel2/scene.gltf", //y
      "assets/Chicken_01/3D_Planets/earth_day/scene.gltf", //n
      "assets/Chicken_01/3D_Planets/mars/scene.gltf", //n
      "assets/Chicken_01/3D_Planets/jupiter/scene.gltf", //n
      "assets/Chicken_01/3D_Planets/moon/scene.gltf", //n
      "assets/Chicken_01/3D_Planets/saturn/scene.gltf", //n
      "assets/Chicken_01/3D_Planets/solar_system/scene.gltf", //n
      "assets/Chicken_01/3D_Planets/solar_system_animation/scene.gltf", //n
      "assets/Chicken_01/3D_Planets/venus_v1.1/scene.gltf",
    ];
    if (localObjectNode != null) {
      arObjectManager.removeNode(localObjectNode!);
      localObjectNode = null;
    } else {
      var newNode = ARNode(type: NodeType.localGLTF2, uri: url[0], scale: Vector3(0.02, 0.02, 0.02), position: Vector3(0.0, 0.0, 0.0), rotation: Vector4(1.0, 0.0, 0.0, 0.0));
      bool? didAddLocalNode = await arObjectManager.addNode(newNode);
      localObjectNode = (didAddLocalNode!) ? newNode : null;
    }
  }

  Future<void> onWebObjectAtButtonPressed(String argument) async {
    if (webObjectNode != null) {
      arObjectManager.removeNode(webObjectNode!);
      webObjectNode = null;
    } else {
      var newNode = ARNode(type: NodeType.webGLB, uri: argument, scale: Vector3(1, 1, 1));
      bool? didAddWebNode = await arObjectManager.addNode(newNode);
      webObjectNode = (didAddWebNode!) ? newNode : null;
    }
  }
}
