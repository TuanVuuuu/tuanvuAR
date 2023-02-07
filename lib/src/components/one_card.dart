import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/components/one_colors.dart';

class OneCard extends StatelessWidget {
  const OneCard({
    Key? key,
    required this.child,
    this.color = OneColors.white,
    this.gradient,
    this.borderRadius,
    this.padding,
    this.margin,
    this.shadow,
  }) : super(key: key);

  final Widget child;
  final Color color;
  final Gradient? gradient;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool? shadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 4),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Positioned.fill(
            top: 10.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                boxShadow: [
                  BoxShadow(
                    color: shadow != true ? OneColors.shadow.withOpacity(0.7) : OneColors.shadow.withOpacity(0.0),
                    blurRadius: 20.0,
                  ),
                ],
              ),
            ),
          ),
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Container(
                padding: padding,
                decoration: BoxDecoration(
                  color: color,
                  gradient: gradient,
                  borderRadius: borderRadius,
                ),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
