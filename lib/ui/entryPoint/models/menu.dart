import 'package:flutter_application_1/src/components/one_images.dart';

import 'rive_model.dart';

class Menu {
  final String title;
  final RiveModel rive;

  Menu({required this.title, required this.rive});
}

// List<Menu> sidebarMenus = [
//   Menu(
//     title: "Home",
//     rive: RiveModel(src: OneImages.icons, artboard: "HOME", stateMachineName: "HOME_interactivity"),
//   ),
//   Menu(
//     title: "Search",
//     rive: RiveModel(src: OneImages.icons, artboard: "SEARCH", stateMachineName: "SEARCH_Interactivity"),
//   ),
//   Menu(
//     title: "Favorites",
//     rive: RiveModel(src: OneImages.icons, artboard: "LIKE/STAR", stateMachineName: "STAR_Interactivity"),
//   ),
//   Menu(
//     title: "Help",
//     rive: RiveModel(src: OneImages.icons, artboard: "CHAT", stateMachineName: "CHAT_Interactivity"),
//   ),
// ];
// List<Menu> sidebarMenus2 = [
//   Menu(
//     title: "History",
//     rive: RiveModel(src: OneImages.icons, artboard: "TIMER", stateMachineName: "TIMER_Interactivity"),
//   ),
//   Menu(
//     title: "Notifications",
//     rive: RiveModel(src: OneImages.icons, artboard: "BELL", stateMachineName: "BELL_Interactivity"),
//   ),
// ];

List<Menu> bottomNavItems = [
  // Menu(
  //   title: "Chat",
  //   rive: RiveModel(
  //       src:  OneImages.icons,
  //       artboard: "CHAT",
  //       stateMachineName: "CHAT_Interactivity"),
  // ),
  Menu(
    title: "Home",
    rive: RiveModel(src: OneImages.icons, artboard: "HOME", stateMachineName: "HOME_interactivity"),
  ),
  Menu(
    title: "Search",
    rive: RiveModel(src: OneImages.icons, artboard: "SEARCH", stateMachineName: "SEARCH_Interactivity"),
  ),
  // Menu(
  //   title: "Timer",
  //   rive: RiveModel(src:  OneImages.icons, artboard: "TIMER", stateMachineName: "TIMER_Interactivity"),
  // ),
  // Menu(
  //   title: "Notification",
  //   rive: RiveModel(src:  OneImages.icons, artboard: "BELL", stateMachineName: "BELL_Interactivity"),
  // ),
  Menu(
    title: "Profile",
    rive: RiveModel(src: OneImages.icons, artboard: "USER", stateMachineName: "USER_Interactivity"),
  ),
];
