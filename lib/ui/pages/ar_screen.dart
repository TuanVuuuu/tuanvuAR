// ignore_for_file: library_private_types_in_public_api, prefer_typing_uninitialized_variables, depend_on_referenced_packages

import 'dart:io';
import 'dart:math';

import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/components/one_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class LocalAndWebObjectsWidget extends StatefulWidget {
  const LocalAndWebObjectsWidget({
    Key? key,
    required this.argument,
  }) : super(key: key);

  final argument;
  @override
  _LocalAndWebObjectsWidgetState createState() => _LocalAndWebObjectsWidgetState();
}

class _LocalAndWebObjectsWidgetState extends State<LocalAndWebObjectsWidget> {
  // https://github.com/topics/augmented-reality?q=ar+dart
  // https://cdn2.f-cdn.com/files/download/137739228/animation-.jpg?image-optimizer=force&width=806
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  late ARAnchorManager arAnchorManager;
  //String localObjectReference;
  ARNode? localObjectNode;
  //String webObjectReference;
  ARNode? webObjectNode;
  ARNode? fileSystemNode;
  HttpClient? httpClient;

  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];

  double scale = 2;
  double newRotationAmount = 0;
  double newTransX = 0;
  double newTransY = 0;
  double newTransZ = 0;

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

  void _subTransAmountX() {
    newTransX = newTransX - 0.02;
  }

  void _subTransAmountY() {
    newTransY = newTransY - 0.02;
  }

  void _subTransAmountZ() {
    newTransZ = newTransZ - 0.02;
  }

  void _addTransAmountX() {
    newTransX = newTransX + 0.02;
  }

  void _addTransAmountY() {
    newTransY = newTransY + 0.02;
  }

  void _addTransAmountZ() {
    newTransZ = newTransZ + 0.02;
  }

  @override
  Widget build(BuildContext context) {
    String imageARUrl = widget.argument["image3D"]["imageARUrl"];
    return Scaffold(
        appBar: AppBar(backgroundColor: OneColors.transparent, elevation: 0),
        extendBodyBehindAppBar: true,
        body: Stack(children: [
          ARView(
              onARViewCreated: ((arSessionManager, arObjectManager, arAnchorManager, arLocationManager) {
                this.arSessionManager = arSessionManager;
                this.arObjectManager = arObjectManager;
                this.arSessionManager!.onInitialize(
                      showFeaturePoints: false,
                      showPlanes: true,
                      customPlaneTexturePath: "Images/triangle.png",
                      showWorldOrigin: false,
                      handleTaps: false,
                    );
                this.arObjectManager!.onInitialize();

                this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
                //Download model to file system
                httpClient = HttpClient();
                // _downloadFile("https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb", "LocalDuck.glb");
                //_downloadFile("https://github.com/TuanVuuuu/tuanvuAR/blob/TuanVu-Assets/assets/3D_model/earth.glb", "LocalDuck.glb");
                setState(() {
                  onWebButton(imageARUrl);
                });
              }),
              planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildButtonScale(),
                _buildButtonRotation(),
              ],
            ),
          ]),
          _buildButtonTrans(),
        ]));
  }

  Widget _buildButtonTrans() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: OneColors.transparent,
                elevation: 0,
              ),
              onPressed: () {
                if (webObjectNode != null) {
                  setState(() {
                    _subTransAmountY();
                  });
                  var newRotationAxis = vector.Vector3(0, 0, 0);
                  newRotationAxis[1] = 1.0;
                  final newTransform = Matrix4.identity();
                  var newTranslation = vector.Vector3(0, 0, 0);
                  newTranslation[0] = newTransZ;
                  newTranslation[1] = newTransX;
                  newTranslation[2] = newTransY;

                  newTransform.setTranslation(newTranslation);
                  newTransform.rotate(newRotationAxis, newRotationAmount);
                  newTransform.scale(scale);

                  webObjectNode!.transform = newTransform;
                }
              },
              child: Transform.rotate(
                angle: -45 * pi / 180,
                child: ClipPath(
                  clipper: CustomTriangleClipper(),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: OneColors.grey.withOpacity(0.4),
                    ),
                  ),
                ),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: OneColors.transparent,
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (webObjectNode != null) {
                      setState(() {
                        _subTransAmountZ();
                      });
                      var newRotationAxis = vector.Vector3(0, 0, 0);
                      newRotationAxis[1] = 1.0;
                      final newTransform = Matrix4.identity();
                      var newTranslation = vector.Vector3(0, 0, 0);
                      newTranslation[0] = newTransZ;
                      newTranslation[1] = newTransX;
                      newTranslation[2] = newTransY;

                      newTransform.setTranslation(newTranslation);
                      newTransform.rotate(newRotationAxis, newRotationAmount);
                      newTransform.scale(scale);

                      webObjectNode!.transform = newTransform;
                    }
                  },
                  child: Transform.rotate(
                    angle: -135 * pi / 180,
                    child: ClipPath(
                      clipper: CustomTriangleClipper(),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: OneColors.grey.withOpacity(0.4),
                        ),
                      ),
                    ),
                  )),
              Container(
                height: 70,
                width: 60,
                decoration: BoxDecoration(
                  color: OneColors.grey.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: OneColors.transparent,
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (webObjectNode != null) {
                      setState(() {
                        _addTransAmountZ();
                      });
                      var newRotationAxis = vector.Vector3(0, 0, 0);
                      newRotationAxis[1] = 1.0;
                      final newTransform = Matrix4.identity();
                      var newTranslation = vector.Vector3(0, 0, 0);
                      newTranslation[0] = newTransZ;
                      newTranslation[1] = newTransX;
                      newTranslation[2] = newTransY;

                      newTransform.setTranslation(newTranslation);
                      newTransform.rotate(newRotationAxis, newRotationAmount);
                      newTransform.scale(scale);

                      webObjectNode!.transform = newTransform;
                    }
                  },
                  child: Transform.rotate(
                    angle: 45 * pi / 180,
                    child: ClipPath(
                      clipper: CustomTriangleClipper(),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: OneColors.grey.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ))
            ],
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: OneColors.transparent,
                elevation: 0,
              ),
              onPressed: () {
                if (webObjectNode != null) {
                  setState(() {
                    _addTransAmountY();
                  });
                  var newRotationAxis = vector.Vector3(0, 0, 0);
                  newRotationAxis[1] = 1.0;
                  final newTransform = Matrix4.identity();
                  var newTranslation = vector.Vector3(0, 0, 0);
                  newTranslation[0] = newTransZ;
                  newTranslation[1] = newTransX;
                  newTranslation[2] = newTransY;

                  newTransform.setTranslation(newTranslation);
                  newTransform.rotate(newRotationAxis, newRotationAmount);
                  newTransform.scale(scale);

                  webObjectNode!.transform = newTransform;
                }
              },
              child: Transform.rotate(
                angle: 135 * pi / 180,
                child: ClipPath(
                  clipper: CustomTriangleClipper(),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: OneColors.grey.withOpacity(0.4),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildButtonRotation() {
    return Column(
      children: [
        //_build Button Rotation
        Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: OneColors.transparent,
                elevation: 0,
              ),
              onPressed: (() {
                if (webObjectNode != null) {
                  setState(() {
                    _addAmount();
                  });

                  var newRotationAxis = vector.Vector3(0, 0, 0);
                  newRotationAxis[1] = 1.0;
                  var newTranslation = vector.Vector3(0, 0, 0);
                  newTranslation[0] = newTransZ;
                  newTranslation[1] = newTransX;
                  newTranslation[2] = newTransY;

                  final newTransform = Matrix4.identity();
                  newTransform.setTranslation(newTranslation);
                  newTransform.rotate(newRotationAxis, newRotationAmount);
                  newTransform.scale(scale);

                  webObjectNode!.transform = newTransform;
                }
              }),
              child: Container(
                decoration: BoxDecoration(color: OneColors.grey.withOpacity(0.4), shape: BoxShape.circle),
                height: 60,
                width: 60,
                child: const Icon(
                  Icons.settings_backup_restore,
                  size: 30,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: OneColors.transparent,
                elevation: 0,
              ),
              onPressed: (() {
                if (webObjectNode != null) {
                  setState(() {
                    _subAmount();
                  });
                  var newRotationAxis = vector.Vector3(0, 0, 0);
                  newRotationAxis[1] = 1.0;
                  var newTranslation = vector.Vector3(0, 0, 0);
                  newTranslation[0] = newTransZ;
                  newTranslation[1] = newTransX;
                  newTranslation[2] = newTransY;

                  final newTransform = Matrix4.identity();
                  newTransform.setTranslation(newTranslation);
                  newTransform.rotate(newRotationAxis, newRotationAmount);
                  newTransform.scale(scale);

                  webObjectNode!.transform = newTransform;
                }
              }),
              child: Container(
                decoration: BoxDecoration(color: OneColors.grey.withOpacity(0.4), shape: BoxShape.circle),
                height: 60,
                width: 60,
                child: const RotatedBox(
                  quarterTurns: 2,
                  child: Icon(
                    Icons.settings_backup_restore,
                    size: 30,
                  ),
                ),
              ),
            )
          ],
        ),
        // _build Button Trans X
        const SizedBox(height: 30),
        Column(
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: OneColors.transparent,
                  elevation: 0,
                ),
                onPressed: () {
                  if (webObjectNode != null) {
                    setState(() {
                      _addTransAmountX();
                    });
                    var newRotationAxis = vector.Vector3(0, 0, 0);
                    newRotationAxis[1] = 1.0;

                    final newTransform = Matrix4.identity();
                    var newTranslation = vector.Vector3(0, 0, 0);
                    newTranslation[0] = newTransZ;
                    newTranslation[1] = newTransX;
                    newTranslation[2] = newTransY;

                    newTransform.setTranslation(newTranslation);
                    newTransform.rotate(newRotationAxis, newRotationAmount);
                    newTransform.scale(scale);

                    webObjectNode!.transform = newTransform;
                  }
                },
                child: Transform.rotate(
                  angle: -45 * pi / 180,
                  child: ClipPath(
                    clipper: CustomTriangleClipper(),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: OneColors.grey.withOpacity(0.4),
                      ),
                    ),
                  ),
                )),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: OneColors.transparent,
                  elevation: 0,
                ),
                onPressed: () {
                  if (webObjectNode != null) {
                    setState(() {
                      _subTransAmountX();
                    });
                    var newRotationAxis = vector.Vector3(0, 0, 0);
                    newRotationAxis[1] = 1.0;

                    final newTransform = Matrix4.identity();
                    var newTranslation = vector.Vector3(0, 0, 0);
                    newTranslation[0] = newTransZ;
                    newTranslation[1] = newTransX;
                    newTranslation[2] = newTransY;

                    newTransform.setTranslation(newTranslation);
                    newTransform.rotate(newRotationAxis, newRotationAmount);
                    newTransform.scale(scale);

                    webObjectNode!.transform = newTransform;
                  }
                },
                child: Transform.rotate(
                  angle: 135 * pi / 180,
                  child: ClipPath(
                    clipper: CustomTriangleClipper(),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: OneColors.grey.withOpacity(0.4),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ],
    );
  }

  Widget _buildButtonScale() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        //ElevatedButton(onPressed: onLocalObjectShuffleButtonPressed, child: Text("Shuffle Local\nobject at Origin")),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: OneColors.transparent,
            elevation: 0,
          ),
          onPressed: () {
            if (webObjectNode != null) {
              setState(() {
                _subScale();
              });

              var newRotationAxis = vector.Vector3(0, 0, 0);
              newRotationAxis[1] = 1.0;
              final newTransform = Matrix4.identity();
              var newTranslation = vector.Vector3(0, 0, 0);
              newTranslation[0] = newTransZ;
              newTranslation[1] = newTransX;
              newTranslation[2] = newTransY;

              newTransform.setTranslation(newTranslation);
              newTransform.rotate(newRotationAxis, newRotationAmount);
              newTransform.scale(scale);
              webObjectNode!.transform = newTransform;
            }
          },
          child: Container(
            decoration: BoxDecoration(color: OneColors.grey.withOpacity(0.4), shape: BoxShape.circle),
            height: 60,
            width: 60,
            child: const Icon(
              Icons.zoom_out,
              size: 30,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: OneColors.transparent, elevation: 0),
          onPressed: () {
            if (webObjectNode != null) {
              setState(() {
                _addScale();
              });
              var newRotationAxis = vector.Vector3(0, 0, 0);
              newRotationAxis[1] = 1.0;
              final newTransform = Matrix4.identity();
              var newTranslation = vector.Vector3(0, 0, 0);
              newTranslation[0] = newTransZ;
              newTranslation[1] = newTransX;
              newTranslation[2] = newTransY;

              newTransform.setTranslation(newTranslation);
              newTransform.rotate(newRotationAxis, newRotationAmount);
              newTransform.scale(scale);
              webObjectNode!.transform = newTransform;
            }
          },
          child: Container(decoration: BoxDecoration(color: OneColors.grey.withOpacity(0.4), shape: BoxShape.circle), height: 60, width: 60, child: const Icon(Icons.zoom_in, size: 30)),
        ),
      ],
    );
  }

  Future<void> onPlaneOrPointTapped(List<ARHitTestResult> hitTestResults) async {
    var singleHitTestResult = hitTestResults.firstWhere((hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);
    var newAnchor = ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
    bool didAddAnchor = await arAnchorManager.addAnchor(newAnchor) ?? false;
    if (didAddAnchor) {
      anchors.add(newAnchor);
      // Add note to anchor
    }
  }

  Future<void>? onWebButton(String imageARUrl) async {
    if (webObjectNode != null) {
      arObjectManager!.removeNode(webObjectNode!);
      webObjectNode = null;
    } else {
      var newNode = ARNode(type: NodeType.webGLB, uri: imageARUrl, scale: vector.Vector3(0.02, 0.02, 0.02));
      bool? didAddWebNode = await arObjectManager!.addNode(newNode);
      webObjectNode = (didAddWebNode!) ? newNode : null;
    }
  }
}
