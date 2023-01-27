/*
 * File: one_background.dart
 * File Created: Wednesday, 20th January 2021 10:58:32 am
 * Author: Hieu Tran
 * -----
 * Last Modified: Wednesday, 20th January 2021 11:00:06 am
 * Modified By: Hieu Tran
 */

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/src/components/one_colors.dart';
import 'package:flutter_application_1/src/components/one_images.dart';

class OneBackground extends StatelessWidget {
  const OneBackground({
    Key? key,
    required this.height,
    this.clipper,
  }) : super(key: key);

  final double height;
  final CustomClipper<Path>? clipper;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildBackground(context),
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      child: ClipPath(
        clipper: clipper,
        child: FutureBuilder(
          future: _loadUiImage(OneImages.background),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ShaderMask(
                blendMode: BlendMode.overlay,
                shaderCallback: (bounds) => ImageShader(
                  snapshot.data as ui.Image,
                  TileMode.mirror,
                  TileMode.repeated,
                  Matrix4.identity().storage,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                      // gradient: CustomColors.gradient,
                      color: Color(0xff00A3FF)),
                ),
              );
            }
            return Container(
              decoration: const BoxDecoration(
                gradient: OneColors.gradient,
              ),
            );
          },
        ),
      ),
    );
  }

  Future<ui.Image> _loadUiImage(String imageAssetPath) async {
    final data = await rootBundle.load(imageAssetPath);
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(Uint8List.view(data.buffer), completer.complete);
    return completer.future;
  }
}
