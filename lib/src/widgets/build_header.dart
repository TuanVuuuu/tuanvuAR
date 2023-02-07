import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/components/one_card.dart';
import 'package:flutter_application_1/src/components/one_colors.dart';
import 'package:flutter_application_1/ui/views/sliver_appbar_delegate.dart';

class BuildHeader extends StatelessWidget {
  const BuildHeader({
    Key? key,
    // ignore: non_constant_identifier_names
    this.icon_header,
    // ignore: non_constant_identifier_names
    this.title_header,
    required this.context,
    this.ontap,
  }) : super(key: key);

  final BuildContext context;
  // ignore: non_constant_identifier_names
  final Icon? icon_header;
  // ignore: non_constant_identifier_names
  final String? title_header;
  // ignore: prefer_typing_uninitialized_variables
  final ontap;

  @override
  Widget build(BuildContext context) {
    final double headerHeight = 68 + MediaQuery.of(context).padding.top;
    return SliverPersistentHeader(
      pinned: true,
      floating: false,
      delegate: SliverAppBarDelegate(
        child: OneCard(
          color: OneColors.transparent,
          shadow: true,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 20, right: 24),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: ontap,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        icon_header ??
                            const Icon(
                              Icons.home,
                              color: OneColors.brandVNP,
                            ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [],
                  ),
                )
              ],
            ),
          ),
        ),
        minHeight: MediaQuery.of(context).padding.top + 70,
        maxHeight: headerHeight,
      ),
    );
  }
}
