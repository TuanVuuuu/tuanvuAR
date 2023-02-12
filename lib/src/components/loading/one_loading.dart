// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class OneLoading {
  OneLoading._();
  static Widget space_loading = Lottie.asset(
    "assets/icons_river/space-progress.json",
    width: 100,
    height: 100,
    repeat: true,
    fit: BoxFit.contain,
  );

  static Widget space_loading_larget = Lottie.asset(
    "assets/icons_river/space-progress.json",
    width: 200,
    height: 200,
    repeat: true,
    fit: BoxFit.contain,
  );
}
