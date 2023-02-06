import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/components/one_colors.dart';
import 'package:flutter_application_1/src/components/one_theme.dart';
import 'dart:math' as math;

class BuildDiscoveryHeader extends StatelessWidget {
  const BuildDiscoveryHeader({Key? key, required this.title}) : super(key: key);

  final String? title;
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      floating: false,
      delegate: _SliverAppBarDelegate(
        minHeight: 0,
        maxHeight: 100,
        child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
            color: OneColors.transparent,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: OneColors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      title ?? "",
                      style: OneTheme.of(context).header.copyWith(letterSpacing: 3, color: OneColors.white),
                    ),
                  ),
                ),
                const Expanded(flex: 1, child: SizedBox()),
              ],
            )),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}
