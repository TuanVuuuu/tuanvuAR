import 'package:flutter/material.dart';
import 'package:flutter_application_1/libary/one_libary.dart';

class CustomTheme {
  CustomTheme();

  ThemeData? appTheme;

  factory CustomTheme.fromContext(BuildContext context) {
    final CustomTheme theme = CustomTheme();

    theme.appTheme = ThemeData(
      primaryColor: OneColors.brandVNP,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'NunitoSans',
      textTheme: TextTheme(
        bodyMedium: OneTheme.of(context).body2,
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        height: 56.0,
        buttonColor: OneColors.brandVNP,
      ),
    );

    return theme;
  }
}
