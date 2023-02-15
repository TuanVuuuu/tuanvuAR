part of '../../../libary/one_libary.dart';

class OneThickNess extends StatelessWidget {
  const OneThickNess({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 8),
        child: Container(
          height: 1,
          color: OneColors.textGrey2,
        ),
      ),
    );
  }
}
