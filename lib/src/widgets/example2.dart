import 'dart:convert';
import 'dart:io';

import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/src/components/one_colors.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vector_math/vector_math_64.dart';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LocalAndWebObjectsWidget extends StatefulWidget {
  LocalAndWebObjectsWidget({
    Key? key,
    required this.argument,
  }) : super(key: key);

  final argument;
  @override
  _LocalAndWebObjectsWidgetState createState() => _LocalAndWebObjectsWidgetState();
}

class _LocalAndWebObjectsWidgetState extends State<LocalAndWebObjectsWidget> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  //String localObjectReference;
  ARNode? localObjectNode;
  //String webObjectReference;
  ARNode? webObjectNode;
  ARNode? fileSystemNode;
  HttpClient? httpClient;

  double scale = 0.2;
  double newRotationAmount = 0;

  @override
  void dispose() {
    super.dispose();
    arSessionManager!.dispose();
  }

  void _subScale() {
    if (scale >= 0.02) {
      scale = scale - 0.02;
    }
  }

  void _addScale() {
    scale = scale + 0.02;
  }

  void _subAmount() {
    newRotationAmount = newRotationAmount - 0.2;
  }

  void _addAmount() {
    newRotationAmount = newRotationAmount + 0.2;
  }

  @override
  Widget build(BuildContext context) {
    String imageARUrl = widget.argument["image3D"]["imageARUrl"];
    print(imageARUrl);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: OneColors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: Container(
            child: Stack(children: [
          ARView(
            onARViewCreated: onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          ),
          Align(
              alignment: FractionalOffset.bottomCenter,
              child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //ElevatedButton(onPressed: onFileSystemObjectAtOriginButtonPressed, child: Text("Add/Remove Filesystem\nObject at Origin")),
                    ElevatedButton(onPressed: onTakeScreenshot, child: const Text("Take Screenshot"))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //ElevatedButton(onPressed: onLocalObjectAtOriginButtonPressed, child: Text("Add/Remove Local\nObject at Origin")),
                    ElevatedButton(
                        onPressed: () {
                          onWebButton(imageARUrl);
                        },
                        child: const Text("Add/Remove Web\nObject at Origin")),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //ElevatedButton(onPressed: onLocalObjectShuffleButtonPressed, child: Text("Shuffle Local\nobject at Origin")),
                    ElevatedButton(
                        onPressed: () {
                          if (webObjectNode != null) {
                            setState(() {
                              _subScale();
                            });

                            final newTransform = Matrix4.identity();
                            newTransform.scale(scale);
                            webObjectNode!.transform = newTransform;
                          }
                        },
                        child: const Text("Scale - 0.2")),
                    ElevatedButton(
                        onPressed: () {
                          if (webObjectNode != null) {
                            setState(() {
                              _addScale();
                            });
                            final newTransform = Matrix4.identity();
                            newTransform.scale(scale);
                            webObjectNode!.transform = newTransform;
                          }
                        },
                        child: const Text("Scale + 0.2")),
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          if (webObjectNode != null) {
                            setState(() {
                              _subAmount();
                            });
                            //var newRotationAxisIndex = Random().nextInt(3);
                            //var newRotationAmount = Random().nextDouble();
                            var newRotationAxis = Vector3(0, 0, 0);
                            newRotationAxis[1] = 1.0;
                            final newTransform = Matrix4.identity();

                            newTransform.rotate(newRotationAxis, newRotationAmount);
                            newTransform.scale(scale);

                            webObjectNode!.transform = newTransform;
                          }
                        },
                        child: const Text("newRotationAmount - 0.2")),
                    ElevatedButton(
                        onPressed: () {
                          if (webObjectNode != null) {
                            setState(() {
                              _addAmount();
                            });
                            var newRotationAxis = Vector3(0, 0, 0);
                            newRotationAxis[1] = 1.0;
                            final newTransform = Matrix4.identity();

                            newTransform.rotate(newRotationAxis, newRotationAmount);
                            newTransform.scale(scale);

                            webObjectNode!.transform = newTransform;
                          }
                        },
                        child: const Text("newRotationAmount + 0.2")),
                  ],
                )
              ]))
        ])));
  }

  void onARViewCreated(ARSessionManager arSessionManager, ARObjectManager arObjectManager, ARAnchorManager arAnchorManager, ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;

    this.arSessionManager!.onInitialize(
          showFeaturePoints: false,
          showPlanes: true,
          customPlaneTexturePath: "assets/triangle.png",
          showWorldOrigin: true,
          handleTaps: false,
        );
    this.arObjectManager!.onInitialize();

    //Download model to file system
    // httpClient = new HttpClient();
    // _downloadFile(widget.argument["image3D"]["imageARUrl"], "LocalDuck.glb");

    // Alternative to use type fileSystemAppFolderGLTF2:
    //_downloadAndUnpack(
    //    "https://drive.google.com/uc?export=download&id=1fng7yiK0DIR0uem7XkV2nlPSGH9PysUs",
    //    "Chicken_01.zip");
  }

  Future<void> onTakeScreenshot() async {
    var image = await arSessionManager!.snapshot();

    await showDialog(
        context: context,
        builder: (_) => Dialog(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(image: DecorationImage(image: image, fit: BoxFit.cover)),
              ),
            ));
  }

  // Future<File> _downloadFile(String url, String filename) async {
  //   var request = await httpClient!.getUrl(Uri.parse(url));
  //   var response = await request.close();
  //   var bytes = await consolidateHttpClientResponseBytes(response);
  //   String dir = (await getApplicationDocumentsDirectory()).path;
  //   File file = new File('$dir/$filename');
  //   await file.writeAsBytes(bytes);
  //   print("Downloading finished, path: " + '$dir/$filename');
  //   return file;
  // }

  Future<void> _downloadAndUnpack(String url, String filename) async {
    var request = await httpClient!.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    print("Downloading finished, path: " + '$dir/$filename');

    // To print all files in the directory: print(Directory(dir).listSync());
    try {
      await ZipFile.extractToDirectory(zipFile: File('$dir/$filename'), destinationDir: Directory(dir));
      print("Unzipping successful");
    } catch (e) {
      print("Unzipping failed: " + e.toString());
    }
  }

  Future<void> onLocalObjectAtOriginButtonPressed() async {
    if (localObjectNode != null) {
      arObjectManager!.removeNode(localObjectNode!);
      localObjectNode = null;
    } else {
      var newNode = ARNode(type: NodeType.localGLTF2, uri: "assets/localModel/scene.gltf", scale: Vector3(0.2, 0.2, 0.2), position: Vector3(0.0, 0.0, 0.0), rotation: Vector4(1.0, 0.0, 0.0, 0.0));
      bool? didAddLocalNode = await arObjectManager!.addNode(newNode);
      localObjectNode = (didAddLocalNode!) ? newNode : null;
    }
  }

  Future<void>? onWebButton(String imageARUrl) async {
    if (webObjectNode != null) {
      arObjectManager!.removeNode(webObjectNode!);
      webObjectNode = null;
    } else {
      httpClient = new HttpClient();
      var newNode = ARNode(type: NodeType.webGLB, uri: "https://github.com/KhronosGroup/glTF-Sample-Models/blob/master/2.0/Duck/glTF-Binary/Duck.glb?raw=true", scale: Vector3(0.2, 0.2, 0.2));
      bool? didAddWebNode = await arObjectManager!.addNode(newNode);
      webObjectNode = (didAddWebNode!) ? newNode : null;
    }
  }

  Future<void> onFileSystemObjectAtOriginButtonPressed() async {
    if (fileSystemNode != null) {
      arObjectManager!.removeNode(fileSystemNode!);
      fileSystemNode = null;
    } else {
      var newNode = ARNode(type: NodeType.fileSystemAppFolderGLB, uri: "LocalDuck.glb", scale: Vector3(0.2, 0.2, 0.2));
      //Alternative to use type fileSystemAppFolderGLTF2:
      //var newNode = ARNode(
      //    type: NodeType.fileSystemAppFolderGLTF2,
      //    uri: "Chicken_01.gltf",
      //    scale: Vector3(0.2, 0.2, 0.2));
      bool? didAddFileSystemNode = await arObjectManager!.addNode(newNode);
      fileSystemNode = (didAddFileSystemNode!) ? newNode : null;
    }
  }

  Future<void> onLocalObjectShuffleButtonPressed() async {
    if (localObjectNode != null) {
      var newScale = Random().nextDouble() / 3;
      //var newScale = scale + 1;
      var newTranslationAxis = Random().nextInt(3);
      var newTranslationAmount = Random().nextDouble() / 3;
      var newTranslation = Vector3(0, 0, 0);
      newTranslation[newTranslationAxis] = newTranslationAmount;
      var newRotationAxisIndex = Random().nextInt(3);
      var newRotationAmount = Random().nextDouble();
      var newRotationAxis = Vector3(0, 0, 0);
      newRotationAxis[newRotationAxisIndex] = 1.0;

      final newTransform = Matrix4.identity();

      //newTransform.setTranslation(newTranslation);
      //newTransform.rotate(newRotationAxis, newRotationAmount);
      newTransform.scale(newScale);

      localObjectNode!.transform = newTransform;
    }
  }

  Future<void> onWebObjectShuffleButtonPressed(bool? sub, bool? add) async {
    if (webObjectNode != null) {
      // var newScale = Random().nextDouble() / 3;
      // var newTranslationAxis = Random().nextInt(3);
      // var newTranslationAmount = Random().nextDouble() / 3;
      // var newTranslation = Vector3(0, 0, 0);
      // newTranslation[newTranslationAxis] = newTranslationAmount;
      // var newRotationAxisIndex = Random().nextInt(3);
      // var newRotationAmount = Random().nextDouble();
      // var newRotationAxis = Vector3(0, 0, 0);
      // newRotationAxis[newRotationAxisIndex] = 1.0;

      final newTransform = Matrix4.identity();

      // newTransform.setTranslation(newTranslation);
      // newTransform.rotate(newRotationAxis, newRotationAmount);
      newTransform.scale(scale);

      webObjectNode!.transform = newTransform;
    }
  }
}
