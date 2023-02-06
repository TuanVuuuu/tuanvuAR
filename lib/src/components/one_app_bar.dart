/*
 * File: one_app_bar.dart
 * File Created: Wednesday, 20th January 2021 10:46:31 am
 * Author: Hieu Tran
 * -----
 * Last Modified: Wednesday, 20th January 2021 11:00:02 am
 * Modified By: Hieu Tran
 */

part of '../../../libary/one_libary.dart';

class OneAppBar extends StatelessWidget {
  const OneAppBar({
    Key? key,
    this.title,
    this.onTapBack,
    this.onTapMenu,
    this.actions,
    this.isTransparent = false,
    this.automaticallyImplyLeading = true,
    this.leftAction,
    this.color,
  })  : assert(actions == null || onTapMenu == null),
        super(key: key);

  final String? title;
  final bool automaticallyImplyLeading;
  final VoidCallback? onTapBack;
  final VoidCallback? onTapMenu;
  final Widget? leftAction;
  final List<Widget>? actions;
  final bool isTransparent;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final appBar = _appBar(context);
    return SafeArea(
      top: false,
      bottom: false,
      child: Stack(
        children: [
          if (isTransparent) const SizedBox() else OneBackgroundDetail(height: appBar.preferredSize.height),
          Container(
            child: appBar,
          ),
        ],
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    final style = OneTheme.of(context).header.copyWith(color: color ?? OneColors.black);
    return AppBar(
      title: title?.isNotEmpty ?? false
          ? Hero(
              tag: 'app_bar_title',
              transitionOnUserGestures: true,
              child: DefaultTextStyle(
                  style: OneTheme.of(context).body2,
                  child: AutoSizeText(
                    title!,
                    style: style,
                    maxLines: 1,
                    minFontSize: 16,
                    overflowReplacement: SizedBox(
                      height: 50,
                      child: Marquee(
                        text: title!,
                        style: style,
                        blankSpace: 30,
                        startAfter: const Duration(seconds: 2),
                        pauseAfterRound: const Duration(seconds: 2),
                      ),
                    ),
                  )),
            )
          : null,
      centerTitle: true,
      backgroundColor: OneColors.transparent,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      leading: automaticallyImplyLeading
          ? InkWell(
              onTap: onTapBack ?? () => Navigator.of(context).pop(),
              child: Center(
                child: Icon(Icons.arrow_back_ios, color: color ?? OneColors.brandVNPT),
              ),
            )
          : leftAction,
      actions: actions ??
          [
            if (onTapMenu != null)
              InkWell(
                onTap: onTapMenu,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: SvgPicture.asset(
                    OneIcons.ic_menu_3,
                    color: color ?? OneColors.brandVNPT,
                    fit: BoxFit.scaleDown,
                    cacheColorFilter: true,
                  ),
                ),
              ),
          ],
    );
  }
}
