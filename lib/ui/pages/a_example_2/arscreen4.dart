// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class MultipleAugmentedImagesPage extends StatefulWidget {
  const MultipleAugmentedImagesPage({super.key});

  @override
  _MultipleAugmentedImagesPageState createState() => _MultipleAugmentedImagesPageState();
}

class _MultipleAugmentedImagesPageState extends State<MultipleAugmentedImagesPage> {
  ArCoreController? arCoreController;
  Map<String, ArCoreAugmentedImage> augmentedImagesMap = {};
  Map<String, Uint8List> bytesMap = {};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Multiple augmented images'),
        ),
        body: ArCoreView(
          onArCoreViewCreated: _onArCoreViewCreated,
          type: ArCoreViewType.AUGMENTEDIMAGES,
        ),
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) async {
    arCoreController = controller;
    arCoreController?.onTrackingImage = _handleOnTrackingImage;
    loadMultipleImage();
  }

  loadMultipleImage() async {
    final ByteData bytes1 = await rootBundle.load('assets/localModel/aug/earthaug.jpg');
    final ByteData bytes2 = await rootBundle.load('assets/localModel/aug/jupiter.png');
    final ByteData bytes3 = await rootBundle.load('assets/localModel/aug/Mars.png');
    bytesMap["earth_augmented_image"] = bytes1.buffer.asUint8List();
    bytesMap["jupiter"] = bytes2.buffer.asUint8List();
    bytesMap["Mars"] = bytes3.buffer.asUint8List();

    arCoreController?.loadMultipleAugmentedImage(bytesMap: bytesMap);
  }

  _handleOnTrackingImage(ArCoreAugmentedImage augmentedImage) {
    if (!augmentedImagesMap.containsKey(augmentedImage.name)) {
      augmentedImagesMap[augmentedImage.name] = augmentedImage;
      switch (augmentedImage.name) {
        case "earth_augmented_image":
          _addSphere(augmentedImage, 'assets/localModel/augmentedimage/earthaugmentedimage.jpg');
          break;
        case "jupiter":
          _addSphere(augmentedImage, 'assets/localModel/augmentedimage/jupiter_aug.jpeg');
          // _addCube(augmentedImage);
          break;
        case "Mars":
          _addSphere(augmentedImage, 'assets/localModel/augmentedimage/Mars_aug.jpeg');
          // _addCylindre(augmentedImage);
          break;
      }
    }
  }

  Future _addSphere(ArCoreAugmentedImage augmentedImage, String uri) async {
    final ByteData textureBytes = await rootBundle.load(uri);

    final material = ArCoreMaterial(
      color: const Color.fromARGB(120, 66, 134, 244),
      textureBytes: textureBytes.buffer.asUint8List(),
    );
    final sphere = ArCoreSphere(
      materials: [material],
      radius: augmentedImage.extentX / 2,
    );
    final node = ArCoreNode(
      shape: sphere,
    );
    arCoreController?.addArCoreNodeToAugmentedImage(node, augmentedImage.index);
  }

  void _addCube(ArCoreAugmentedImage augmentedImage) {
    double size = augmentedImage.extentX / 2;
    final material = ArCoreMaterial(
      color: const Color.fromARGB(120, 66, 134, 244),
      metallic: 1.0,
    );
    final cube = ArCoreCube(
      materials: [material],
      size: vector.Vector3(size, size, size),
    );
    final node = ArCoreNode(
      shape: cube,
    );
    arCoreController?.addArCoreNodeToAugmentedImage(node, augmentedImage.index);
  }

  void _addCylindre(ArCoreAugmentedImage augmentedImage) {
    final material = ArCoreMaterial(
      color: Colors.red,
      reflectance: 1.0,
    );
    final cylindre = ArCoreCylinder(
      materials: [material],
      radius: augmentedImage.extentX / 2,
      height: augmentedImage.extentX / 3,
    );
    final node = ArCoreNode(
      shape: cylindre,
    );
    arCoreController?.addArCoreNodeToAugmentedImage(node, augmentedImage.index);
  }

  @override
  void dispose() {
    arCoreController?.dispose();
    super.dispose();
  }
}
