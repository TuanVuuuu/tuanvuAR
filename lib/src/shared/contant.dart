// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

const KEY_APPMATH = '_RES_SPACES_APP';

class AppContants {
  static double sizeHeight = 0.0;
  static double sizeWidth = 0.0;

  // AppContants.init(context);
  //AppContants.sizeHeight, AppContants.sizeWidth
  static void init(BuildContext context) {
    sizeHeight = MediaQuery.of(context).size.height;
    sizeWidth = MediaQuery.of(context).size.width;
  }
}
