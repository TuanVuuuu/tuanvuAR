// ignore_for_file: library_private_types_in_public_api

import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/libary/one_libary.dart';

class AssetsObject extends StatefulWidget {
  const AssetsObject({super.key});

  @override
  _AssetsObjectState createState() => _AssetsObjectState();
}

class _AssetsObjectState extends State<AssetsObject> {
  ArCoreController? arCoreController;

  String? objectSelected;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          // title: const Text('Image Detection Sample'),
          backgroundColor: OneColors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: <Widget>[
            ArCoreView(
              onArCoreViewCreated: _onArCoreViewCreated,
              enableTapRecognizer: true,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ListObjectSelection(
                onTap: (value) {
                  objectSelected = value;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController?.onNodeTap = (name) => onTapHandler(name);
    arCoreController?.onPlaneTap = _handleOnPlaneTap;
  }

  void _addToucano(ArCoreHitTestResult plane) {
    if (objectSelected != null) {
      //"https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF/Duck.gltf"
      final toucanoNode = ArCoreReferenceNode(name: objectSelected, object3DFileName: objectSelected, position: plane.pose.translation, rotation: plane.pose.rotation);
      arCoreController?.addArCoreNodeWithAnchor(toucanoNode);
    } else {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) => const AlertDialog(content: Text('Select an object!')),
      );
    }
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    final hit = hits.first;
    _addToucano(hit);
  }

  void onTapHandler(String name) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Row(
          children: <Widget>[
            Text('Remove $name?'),
            IconButton(
                icon: const Icon(
                  Icons.delete,
                ),
                onPressed: () {
                  arCoreController?.removeNode(nodeName: name);
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    arCoreController?.dispose();
    super.dispose();
  }
}

class ListObjectSelection extends StatefulWidget {
  final Function? onTap;

  const ListObjectSelection({super.key, this.onTap});

  @override
  _ListObjectSelectionState createState() => _ListObjectSelectionState();
}

class _ListObjectSelectionState extends State<ListObjectSelection> {
  List<String> gifs = [
    'assets/TocoToucan.gif',
    'assets/AndroidRobot.gif',
    'assets/ArcticFox.gif',
  ];

  List<String> objectsFileName = [
    'toucan.sfb',
    'andy.sfb',
    'artic_fox.sfb',
  ];

  String? selected;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.0,
      child: ListView.builder(
        itemCount: gifs.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selected = gifs[index];
                widget.onTap?.call(objectsFileName[index]);
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  decoration: BoxDecoration(
                    color: selected == gifs[index] ? Colors.transparent : Colors.transparent,
                    shape: BoxShape.circle
                  ),
                  padding: selected == gifs[index] ? const EdgeInsets.all(8.0) : null,
                  child: Image.asset(gifs[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
