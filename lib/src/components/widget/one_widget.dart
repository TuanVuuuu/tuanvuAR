// ignore_for_file: non_constant_identifier_names

part of '../../../libary/one_libary.dart';

class OneWidget {
  OneWidget._();
  static BoxDecoration background_bg4 = const BoxDecoration(
    image: DecorationImage(
      image: AssetImage(OneImages.bg4),
      fit: BoxFit.cover,
    ),
  );
  static BoxDecoration background_bg3 = const BoxDecoration(
    image: DecorationImage(
      image: AssetImage(OneImages.bg3),
      fit: BoxFit.cover,
    ),
  );

  static BoxDecoration background_bg2 = const BoxDecoration(
    image: DecorationImage(
      image: AssetImage(OneImages.bg2),
      fit: BoxFit.cover,
    ),
  );
  static BoxShadow boxshadow_offset_5 = BoxShadow(
    color: OneColors.grey.withOpacity(0.2),
    offset: const Offset(5.0, 5.0),
    blurRadius: 10.0,
    spreadRadius: 2.0,
  );
  static BoxShadow boxshadow_offset_0 = BoxShadow(
    color: OneColors.grey.withOpacity(0.2),
    offset: const Offset(0.0, 0.0),
    blurRadius: 0.0,
    spreadRadius: 0.0,
  );
}
