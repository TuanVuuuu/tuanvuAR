part of '../../../libary/one_libary.dart';

class OneFloatToTop extends StatelessWidget {
  const OneFloatToTop({
    super.key,
    required ScrollController scrollController,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: OneColors.white.withOpacity(0.4),
      onPressed: () {
        if (_scrollController.offset >= _scrollController.position.maxScrollExtent) {
          _scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      },
      child: const Icon(Icons.arrow_upward),
    );
  }
}
