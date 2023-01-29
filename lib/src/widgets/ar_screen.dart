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
import 'package:flutter_application_1/src/components/button/one_triangle_shape.dart';
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
                      showWorldOrigin: true,
                      handleTaps: false,
                    );
                this.arObjectManager!.onInitialize();
                //Download model to file system
                httpClient = new HttpClient();
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
                  var newRotationAxis = Vector3(0, 0, 0);
                  newRotationAxis[1] = 1.0;
                  final newTransform = Matrix4.identity();
                  var newTranslation = Vector3(0, 0, 0);
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
                      var newRotationAxis = Vector3(0, 0, 0);
                      newRotationAxis[1] = 1.0;
                      final newTransform = Matrix4.identity();
                      var newTranslation = Vector3(0, 0, 0);
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
                      var newRotationAxis = Vector3(0, 0, 0);
                      newRotationAxis[1] = 1.0;
                      final newTransform = Matrix4.identity();
                      var newTranslation = Vector3(0, 0, 0);
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
                  var newRotationAxis = Vector3(0, 0, 0);
                  newRotationAxis[1] = 1.0;
                  final newTransform = Matrix4.identity();
                  var newTranslation = Vector3(0, 0, 0);
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

                  var newRotationAxis = Vector3(0, 0, 0);
                  newRotationAxis[1] = 1.0;
                  var newTranslation = Vector3(0, 0, 0);
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
                  var newRotationAxis = Vector3(0, 0, 0);
                  newRotationAxis[1] = 1.0;
                  var newTranslation = Vector3(0, 0, 0);
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
        SizedBox(height: 30),
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
                    var newRotationAxis = Vector3(0, 0, 0);
                    newRotationAxis[1] = 1.0;

                    final newTransform = Matrix4.identity();
                    var newTranslation = Vector3(0, 0, 0);
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
                    var newRotationAxis = Vector3(0, 0, 0);
                    newRotationAxis[1] = 1.0;

                    final newTransform = Matrix4.identity();
                    var newTranslation = Vector3(0, 0, 0);
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

              var newRotationAxis = Vector3(0, 0, 0);
              newRotationAxis[1] = 1.0;
              final newTransform = Matrix4.identity();
              var newTranslation = Vector3(0, 0, 0);
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
              var newRotationAxis = Vector3(0, 0, 0);
              newRotationAxis[1] = 1.0;
              final newTransform = Matrix4.identity();
              var newTranslation = Vector3(0, 0, 0);
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

  Future<void>? onWebButton(String imageARUrl) async {
    if (webObjectNode != null) {
      arObjectManager!.removeNode(webObjectNode!);
      webObjectNode = null;
    } else {
      var newNode = ARNode(type: NodeType.webGLB, uri: "https://github.com/TuanVuuuu/tuanvuAR/blob/TuanVu-01/assets/3D_model/earth.glb?raw=true", scale: Vector3(0.02, 0.02, 0.02));
      bool? didAddWebNode = await arObjectManager!.addNode(newNode);
      webObjectNode = (didAddWebNode!) ? newNode : null;
    }
  }
}
