import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_application_1/src/components/one_colors.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: OneColors.transparent,
      pinned: false,
      floating: true,
      snap: false,
      expandedHeight: 60,
      flexibleSpace: _MyWelcomingHeader(),
    );
  }
}

class _MyWelcomingHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
      final deltaExtent = settings!.maxExtent - settings.minExtent;
      final t = (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent).clamp(0.0, 1.0);
      final fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
      const fadeEnd = 1.0;
      final opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);

      return Container(
        color: OneColors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 30),
          child: Opacity(
            opacity: opacity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Flexible(
                  child: Icon(
                    Icons.menu,
                    size: 22,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Astronomy',
                    style: TextStyle(
                      color: OneColors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
