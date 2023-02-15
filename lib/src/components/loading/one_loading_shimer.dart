part of '../../../libary/one_libary.dart';

class OneLoadingShimmer extends StatelessWidget {
  const OneLoadingShimmer({
    Key? key,
    this.padding = const EdgeInsets.all(10.0),
    this.itemCount = 20,
    this.color,
  }) : super(key: key);

  final EdgeInsets padding;
  final int itemCount;
  final Color? color;
  Color get _color => color ?? OneColors.white.withOpacity(0.8);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Shimmer.fromColors(
        baseColor: OneColors.textGrey2,
        highlightColor: OneColors.blue100,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: itemCount,
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 20, right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: double.infinity, height: 8.0, color: _color),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                      Container(width: double.infinity, height: 8.0, color: _color),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                      Container(width: double.infinity, height: 8.0, color: _color),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                      Container(width: double.infinity, height: 8.0, color: _color),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                      Container(width: double.infinity, height: 8.0, color: _color),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                      Container(width: 80.0, height: 8.0, color: _color),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                ),
                Container(width: 100.0, height: 100.0, color: _color),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
