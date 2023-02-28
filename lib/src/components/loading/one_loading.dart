// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class OneLoading {
  OneLoading._();
  static Widget space_loading = Lottie.asset(
    "assets/icons_river/space-progress.json",
    width: 150,
    height: 150,
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

  static Widget signup_done = Lottie.asset(
    "assets/icons_river/done.json",
    width: 80,
    height: 80,
    repeat: true,
    fit: BoxFit.contain,
  );

  static Widget quiz_false = Lottie.asset(
    "assets/icons_river/crying-baby-astronaut.json",
    width: 150,
    height: 150,
    repeat: true,
    fit: BoxFit.contain,
  );

  static Widget quiz_pass = Lottie.asset(
    "assets/icons_river/happy-spaceman.json",
    width: 200,
    height: 200,
    repeat: true,
    fit: BoxFit.contain,
  );
}
