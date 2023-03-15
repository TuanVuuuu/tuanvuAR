// ignore_for_file: camel_case_types

part of '../../../libary/one_libary.dart';

class one_button_ar_view extends StatelessWidget {
  const one_button_ar_view({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(color: OneColors.bgButton, borderRadius: BorderRadius.circular(15)),
      height: 50,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            const Icon(
              Icons.view_in_ar,
              color: OneColors.white,
              size: 40,
            ),
            Text(
              "AR",
              style: OneTheme.of(context).title1.copyWith(color: OneColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
