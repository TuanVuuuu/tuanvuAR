import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/components/one_colors.dart';

class OneThickNess extends StatelessWidget {
  const OneThickNess({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 8),
        child: Container(
          height: 1,
          color: OneColors.textGrey2,
        ),
      ),
    );
  }
}
