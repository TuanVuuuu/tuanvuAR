import 'dart:ui';

import 'package:flutter/material.dart';

class BlurFilter extends StatelessWidget {
  final Widget child;
  final double sigmaX;
  final double sigmaY;
  final double? height;
  const BlurFilter({super.key, required this.child, this.sigmaX = 5.0, this.sigmaY = 5.0, this.height});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        ClipRRect(
          child: SizedBox(
            height: height,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: sigmaX,
                sigmaY: sigmaY,
              ),
              child: Opacity(
                opacity: 0.01,
                child: child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
