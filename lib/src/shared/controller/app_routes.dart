// ignore_for_file: constant_identifier_names

part of '../../../libary/one_libary.dart';

enum AppRoutes {
  SPLASH_SCREEN,
  ENTRY_POINT,
  HOMESCREEN,
  LOGIN_MANAGER,
  LOGIN_SCREEN,
  REGISTER_PAGE,
  FORGOT_PASSWORD,
  SIGN_OUT,
  ARTIFICIAL_SCREEN,
  DISCOVERY_SCREEN,
  USER_DETAIL_INFO,
  MULTIPLE_AUGMENTED_IMAGES,
  TOP_NEWS,
  TOP_NEWS_DETAIL,
}

extension AppRouteExt on AppRoutes {
  String get name {
    switch (this) {
      case AppRoutes.SPLASH_SCREEN:
        return '/splash';
      case AppRoutes.ENTRY_POINT:
        return '/entrypoint';
      case AppRoutes.HOMESCREEN:
        return '/homescreen';
      case AppRoutes.LOGIN_MANAGER:
        return '/loginmanager';
      case AppRoutes.LOGIN_SCREEN:
        return '/loginscreen';
      case AppRoutes.REGISTER_PAGE:
        return '/registerscreen';
      case AppRoutes.FORGOT_PASSWORD:
        return '/forgotpassword';
      case AppRoutes.SIGN_OUT:
        return '/signout';
      case AppRoutes.ARTIFICIAL_SCREEN:
        return '/artificial';
      case AppRoutes.DISCOVERY_SCREEN:
        return '/discovery';
      case AppRoutes.USER_DETAIL_INFO:
        return '/userdetailinfo';
      case AppRoutes.MULTIPLE_AUGMENTED_IMAGES:
        return '/multipleaugmentedimages';
      case AppRoutes.TOP_NEWS:
        return '/topnewsscreen';
      case AppRoutes.TOP_NEWS_DETAIL:
        return '/topnewsdetail';
    }
  }

  static AppRoutes? from(String? name) {
    for (final item in AppRoutes.values) {
      if (item.name == name) {
        return item;
      }
    }
    return null;
  }

  static Route generateRoute(RouteSettings settings) {
    switch (AppRouteExt.from(settings.name)) {
      case AppRoutes.SPLASH_SCREEN:
        return GetPageRoute(
          settings: settings,
          page: () => const SplashScreen(),
          curve: Curves.ease,
          transition: Transition.fade,
        );
      case AppRoutes.ENTRY_POINT:
        return GetPageRoute(
          settings: settings,
          page: () => const BottomNavigationBarWidget(),
          curve: Curves.ease,
          transition: Transition.fade,
        );
      case AppRoutes.HOMESCREEN:
        return GetPageRoute(
          settings: settings,
          page: () => const HomeScreen(),
          curve: Curves.linear,
          transition: Transition.rightToLeft,
        );
      case AppRoutes.LOGIN_MANAGER:
        return GetPageRoute(
          settings: settings,
          page: () => const LoginManagerScreen(),
          curve: Curves.linear,
          transition: Transition.rightToLeft,
        );
      case AppRoutes.LOGIN_SCREEN:
        return GetPageRoute(
          settings: settings,
          page: () => const LoginPage(),
          curve: Curves.linear,
          transition: Transition.rightToLeft,
        );
      case AppRoutes.REGISTER_PAGE:
        return GetPageRoute(
          settings: settings,
          page: () => const RegisterPage(),
          curve: Curves.linear,
          transition: Transition.rightToLeft,
        );
      case AppRoutes.FORGOT_PASSWORD:
        return GetPageRoute(
          settings: settings,
          page: () => const ForgotPasswordScreen(),
          curve: Curves.linear,
          transition: Transition.rightToLeft,
        );
      case AppRoutes.SIGN_OUT:
        return GetPageRoute(
          settings: settings,
          page: () => SignOutScreen(),
          curve: Curves.linear,
          transition: Transition.rightToLeft,
        );
      case AppRoutes.ARTIFICIAL_SCREEN:
        return GetPageRoute(
          settings: settings,
          page: () => const ArtificialScreen(),
          curve: Curves.linear,
          transition: Transition.rightToLeft,
        );
      case AppRoutes.DISCOVERY_SCREEN:
        return GetPageRoute(
          settings: settings,
          page: () => const DiscoveryScreen(),
          curve: Curves.linear,
          transition: Transition.rightToLeft,
        );
      case AppRoutes.USER_DETAIL_INFO:
        return GetPageRoute(
          settings: settings,
          page: () => const UserDetailInfoScreen(),
          curve: Curves.linear,
          transition: Transition.rightToLeft,
        );
      case AppRoutes.MULTIPLE_AUGMENTED_IMAGES:
        return GetPageRoute(
          settings: settings,
          page: () => const MultipleAugmentedImagesPage(),
          curve: Curves.linear,
          transition: Transition.rightToLeft,
        );
      case AppRoutes.TOP_NEWS:
        return GetPageRoute(
          settings: settings,
          page: () => const TopNewsScreen(),
          curve: Curves.linear,
          transition: Transition.rightToLeft,
        );
      case AppRoutes.TOP_NEWS_DETAIL:
        dynamic argument;
        return GetPageRoute(
          settings: settings,
          page: () => DetailNewsScreen(
            argument: argument,
          ),
          curve: Curves.linear,
          transition: Transition.rightToLeft,
        );
      default:
        return GetPageRoute(
          settings: settings,
          curve: Curves.linear,
          transition: Transition.rightToLeft,
          page: () => const SplashScreen(),
        );
    }
  }

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static Route<dynamic> bindingRoute(RouteSettings settings) {
    return AppRouteExt.generateRoute(settings);
  }
}
