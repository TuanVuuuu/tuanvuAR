import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/components/one_background.dart';

class OneBackgroundDetail extends StatelessWidget {
  const OneBackgroundDetail({
    Key? key,
    required this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    final edgeInsets = MediaQuery.of(context).padding;
    return OneBackground(
      height: height + edgeInsets.top,
    );
  }
}
