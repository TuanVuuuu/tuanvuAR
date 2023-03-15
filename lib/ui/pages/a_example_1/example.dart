// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api

import 'dart:async';

import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ImageDetectionPage extends StatefulWidget {
  const ImageDetectionPage({super.key});

  @override
  _ImageDetectionPageState createState() => _ImageDetectionPageState();
}

class _ImageDetectionPageState extends State<ImageDetectionPage> {
  late ArCoreController arCoreController;
  Timer? timer;
  bool anchorWasFound = false;

  @override
  void dispose() {
    timer?.cancel();
    arCoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Detection Sample')),
      body: ArCoreView(
        onArCoreViewCreated: onArCoreViewCreated,
        enableTapRecognizer: true,
        type: ArCoreViewType.STANDARDVIEW,
      ),
    );
  }

  void onArCoreViewCreated(ArCoreController arCoreController) async {
    this.arCoreController = arCoreController;
    this.arCoreController.onPlaneTap = _handleOnPlaneTap;

    final bytes = await _getAssetBytes('assets/2D_model/Mars.jpg');
    final material = ArCoreMaterial(
      color: Colors.blue,
      textureBytes: bytes,
      metallic: 1,
      reflectance: 0.6,
      roughness: 0.8,
    );
    final sphere = ArCoreSphere(
      materials: [material],
      radius: 0.1,
    );
    final node = ArCoreNode(
      name: 'earth',
      shape: sphere,
      position: vector.Vector3(0, 0, -1),
    );
    arCoreController.addArCoreNodeWithAnchor(node);
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) async {
    final hit = hits.first;
    final bytes = await _getAssetBytes('assets/2D_model/Mars.jpg');
    final material = ArCoreMaterial(
      color: Colors.blue,
      textureBytes: bytes,
      metallic: 1,
      reflectance: 0.6,
      roughness: 0.8,
    );
    final sphere = ArCoreSphere(
      materials: [material],
      radius: 0.1,
    );
    final node = ArCoreNode(
      name: 'earth',
      shape: sphere,
      position: hit.pose.translation,
      rotation: hit.pose.rotation,
    );
    arCoreController.addArCoreNodeWithAnchor(node);
  }

  Future<Uint8List> _getAssetBytes(String path) async {
    final byteData = await rootBundle.load(path);
    return byteData.buffer.asUint8List();
  }
}
