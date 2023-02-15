// ignore_for_file: constant_identifier_names

part of '../../../libary/one_libary.dart';

enum AppRoutes {
  SPLASH_SCREEN,
  ENTRYPOINT,
  HOMESCREEN,
}

extension AppRouteExt on AppRoutes {
  String get name {
    switch (this) {
      case AppRoutes.SPLASH_SCREEN:
        return '/';
      case AppRoutes.ENTRYPOINT:
        return '/entrypoint';
      case AppRoutes.HOMESCREEN:
        return '/homescreen';
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
      case AppRoutes.ENTRYPOINT:
        return GetPageRoute(
          settings: settings,
          page: () => const SplashScreen(),
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
      default:
        return GetPageRoute(settings: settings, curve: Curves.linear, transition: Transition.rightToLeft
            // page: () => EmptyScreen(desc: 'No route defined for ${settings.name}'),
            );
    }
  }

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static Route<dynamic> bindingRoute(RouteSettings settings) {
    return AppRouteExt.generateRoute(settings);
  }
}

// class AppRoutes {
//   static List<GetPage> routes() => [
//         GetPage(name: "/", page: () => const SplashScreen()),
//         GetPage(
//           name: "/ENTRYPOINT",
//           page: () => const EntryPoint(),
//         )
//       ];
// }
