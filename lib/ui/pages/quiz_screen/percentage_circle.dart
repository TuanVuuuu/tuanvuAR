// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/ui/pages/quiz_screen/circle_painter.dart';

class PercentageCircle extends StatefulWidget {
  final double percentage;

  const PercentageCircle({Key? key, required this.percentage}) : super(key: key);

  @override
  _PercentageCircleState createState() => _PercentageCircleState();
}

class _PercentageCircleState extends State<PercentageCircle> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.percentage,
    ).animate(_animationController!);

    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: (widget.percentage < 0.76)
                ? ((widget.percentage >= 0.5 && widget.percentage < 0.75) ? OneColors.textOrange.withOpacity(0.4) : OneColors.red.withOpacity(0.4))
                : OneColors.borderGreen.withOpacity(0.4),
            width: 5),
        //(percentage >= 0.76) ? OneColors.borderGreen : ((percentage >= 0.5 && percentage < 0.75) ? OneColors.textOrange : OneColors.red)
      ),
      child: AnimatedBuilder(
        animation: _animationController!,
        builder: (BuildContext context, Widget? child) {
          return CustomPaint(
            painter: CirclePainter(_animation!.value),
          );
        },
      ),
    );
  }
}
