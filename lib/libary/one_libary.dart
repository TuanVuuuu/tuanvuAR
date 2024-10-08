// ignore_for_file: unused_import, depend_on_referenced_packages
// package:flutter_application_1/src/lib/src/components/libary/one_libary.dart
// part 'one_libary.dart'

import 'dart:ui';
import 'package:babylonjs_viewer/babylonjs_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/src/shared/contant.dart';
import 'package:flutter_application_1/ui/pages/a_example_2/arscreen4.dart';
import 'package:flutter_application_1/ui/pages/ar_screen/ar_screen.dart';
import 'package:flutter_application_1/ui/pages/auth_screen/forgot_password_screen.dart';
import 'package:flutter_application_1/ui/pages/auth_screen/sign_out.dart';
import 'package:flutter_application_1/ui/pages/auth_screen/signup_screen.dart';
import 'package:flutter_application_1/ui/pages/auth_screen/user_detail_info_screen.dart';
import 'package:flutter_application_1/ui/pages/profile_screen/rank_user_screen.dart';
import 'package:flutter_application_1/ui/pages/quiz_manager_screen/quiz_manager_screen.dart';
import 'package:flutter_application_1/ui/pages/scan_ar_screen.dart/my_scan_ar_app.dart';
import 'package:flutter_application_1/ui/splash/splash_bg.dart';
import 'package:flutter_application_1/src/components/loading/one_loading.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter_application_1/src/components/one_images.dart';
import 'dart:math' as math;
import 'package:flutter_application_1/src/components/one_icons.dart';
import 'package:flutter_application_1/src/components/widget/one_blur.dart';
import 'package:flutter_application_1/src/widgets/one_news_widget/card_with_tags.dart';
import 'package:flutter_application_1/src/widgets/one_news_widget/one_card_news_image.dart';
import 'package:flutter_application_1/ui/menu/entry_point.dart';
import 'package:flutter_application_1/ui/pages/artificial_screen/artificial_screen.dart';
import 'package:flutter_application_1/ui/pages/auth_screen/login_manager.dart';
import 'package:flutter_application_1/ui/pages/auth_screen/signin_screen.dart';
import 'package:flutter_application_1/ui/pages/news_screen/detail_news_screen.dart';
import 'package:flutter_application_1/ui/views/exit_dialog.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
import 'package:flutter_application_1/src/components/shared/constant.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:tuple/tuple.dart';
import 'dart:io';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:vector_math/vector_math_64.dart';
import 'dart:math';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/src/widgets/planets_widget/card_planets.dart';
import 'package:readmore/readmore.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io' as io;
import 'package:chewie/chewie.dart';
import 'package:flutter_application_1/ui/pages/discovery_screen/discovery_detail_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:native_ar_viewer/native_ar_viewer.dart';
import 'package:flutter_application_1/ui/pages/discovery_screen/discovery_screen.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/src/shared/firestore_helper.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_application_1/src/shared/controller/auth_controller.dart';

part '../src/components/welcome_header.dart';
part '../src/components/one_thick_ness.dart';
part '../src/components/one_theme.dart';
part '../src/components/one_theme_data.dart';
part '../src/components/one_colors.dart';
part '../src/components/one_card.dart';
part '../src/components/loading/one_cache_manager.dart';
part '../src/components/loading/one_cache_images.dart';
part '../src/components/button/one_float_to_top.dart';
part '../src/components/widget/one_widget.dart';
part '../src/components/button/one_triangle_shape.dart';
part '../src/components/button/one_button_ar_view.dart';
part '../src/widgets/example/example3.dart';
part '../ui/pages/home_screen/3d_view.dart';
part '../src/widgets/local_ar_web_view.dart';
part '../ui/pages/home_screen/planet_detail_screen.dart';
part '../ui/pages/home_screen/home_screen.dart';
part '../ui/pages/planet_3D_view.dart';
part '../ui/splash/splash_screen.dart';
part '../src/components/loading/one_loading_shimer.dart';
part '../src/shared/controller/app_routes.dart';
part '../src/shared/controller/initial_binding.dart';
part '../src/shared/app_scaffold.dart';
// part '../src/shared/download_status.dart';
part '../ui/pages/news_screen/top_news_screen.dart';
