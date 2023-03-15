import 'package:flutter/material.dart';
import 'package:flutter_application_1/libary/one_libary.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({
    Key? key,
    required this.isSearchBar,
    required this.onPressed,
  }) : super(key: key);

  final bool isSearchBar;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (isSearchBar) {
      return TextButton(
        onPressed: onPressed,
        child: Text(
          "Đóng",
          style: OneTheme.of(context).title2.copyWith(color: OneColors.black),
        ),
      );
    } else {
      return InkWell(
        onTap: onPressed,
        child: const Icon(
          Icons.search,
          size: 30,
          color: OneColors.black,
        ),
      );
    }
  }
}
