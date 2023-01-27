/*
 * File: one_button.dart
 * File Created: Friday, 22nd January 2021 9:25:26 am
 * Author: Hieu Tran
 * -----
 * Last Modified: Friday, 22nd January 2021 9:25:57 am
 * Modified By: Hieu Tran
 */

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/components/button/one_button_controller.dart';
import 'package:flutter_application_1/src/components/one_colors.dart';
import 'package:flutter_application_1/src/components/shared/constant.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tuple/tuple.dart';


enum OneButtonState {
  primary,
  outline,
  disable,
  borderless,
}

enum OneButtonSize {
  small,
  middle,
  large,
  largest,
}

class OneButton extends StatefulWidget {
  const OneButton({
    Key? key,
    this.label,
    this.size = OneButtonSize.middle,
    this.onPressed,
    this.state = OneButtonState.primary,
    this.controller,
    this.title,
    this.enable,
    this.prefixIconAssetPath,
    this.suffixIconAssetPath,
    this.color,
    this.gradient,
    this.background,
    this.textColor,
    this.padding,
    this.textStyle,
    this.maxLines,
    this.height,
    this.width,
    this.borderRadius,
  })  : assert(title != null || label != null),
        super(key: key);

  final String? label;
  final String? prefixIconAssetPath;
  final String? suffixIconAssetPath;
  final VoidCallback? onPressed;
  final OneButtonState state;
  final OneButtonSize size;
  final Widget? title;
  final bool? enable;
  final OneButtonController? controller;
  final Color? color;
  final LinearGradient? gradient;
  final Color? background;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final int? maxLines;
  final double? height;
  final double? width;
  final BorderRadiusGeometry? borderRadius;

  @override
  _OneButtonState createState() => _OneButtonState();
}

class _OneButtonState extends State<OneButton> {
  late OneButtonController _controller;
  OneButtonController get _effectiveController => widget.controller ?? _controller;

  bool? _enable;
  bool get enable => _enable ?? _effectiveController.enable;

  OneButtonState? _state;
  OneButtonState get state => _state ?? _effectiveController.state;

  OneVisibility? _visibility;
  OneVisibility get visibility => _visibility ?? _effectiveController.visibility;

  Color get _color => widget.color ?? OneColors.brandVNPT;
  LinearGradient get _gradient {
    if (widget.gradient != null) {
      return widget.gradient!;
    } else if (widget.color != null) {
      return LinearGradient(
        colors: [widget.color!, widget.color!],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    return OneColors.gradient;
  }

  Color get _background => widget.background ?? Colors.white;

  BoxDecoration get _decoration {
    return BoxDecoration(
      color: (state != OneButtonState.outline && state != OneButtonState.borderless) || !enable ? OneColors.greyLight : _background,
      gradient: state != OneButtonState.primary || !enable ? null : _gradient,
      borderRadius: widget.borderRadius ?? BorderRadius.circular(8.0),
      border: state == OneButtonState.outline && enable ? Border.all(width: 1.0, color: _color) : null,
    );
  }

  Color get _textColor {
    if (!enable) {
      return OneColors.textGrey1;
    }
    switch (state) {
      case OneButtonState.primary:
        return widget.textColor ?? Colors.white;
      case OneButtonState.borderless:
      case OneButtonState.outline:
        return widget.textColor ?? _color;
      case OneButtonState.disable:
        return OneColors.textGrey1;
      default:
        return widget.textColor ?? Colors.white;
    }
  }

  Tuple3<double, TextStyle, int> get _sizeConfiguration {
    switch (widget.size) {
      case OneButtonSize.small:
        return Tuple3(widget.height ?? 32, widget.textStyle ?? TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: _textColor), widget.maxLines ?? 2);
      case OneButtonSize.middle:
        return Tuple3(widget.height ?? 40, widget.textStyle ?? TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: _textColor), widget.maxLines ?? 2);
      case OneButtonSize.large:
        return Tuple3(widget.height ?? 48, widget.textStyle ?? TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: _textColor), widget.maxLines ?? 2);
      case OneButtonSize.largest:
        return Tuple3(widget.height ?? 50, widget.textStyle ?? TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: _textColor), widget.maxLines ?? 2);
    }
  }

  double get _minHeight => _sizeConfiguration.item1;
  double get _maxWidth => widget.width ?? double.infinity;
  TextStyle get _textStyle => _sizeConfiguration.item2;
  int get _maxLines => _sizeConfiguration.item3;

  @override
  void initState() {
    super.initState();
    _enable = widget.enable;
    if (widget.controller == null) {
      _controller = OneButtonController(
        label: widget.label,
        state: widget.state,
        enable: widget.enable ?? true,
      );
    } else {
      if (widget.enable != null) widget.controller!.enable = widget.enable!;
      widget.controller!.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(OneButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null) {
        _controller = OneButtonController.fromValue(oldWidget.controller!.value);
      }
      if (widget.controller != null) {
        if (oldWidget.controller == null) {
          _controller = OneButtonController(
            label: widget.label,
            state: widget.state,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return ElevatedButton(
  //     onPressed: enable ? widget.onPressed : null,
  //     style: ElevatedButton.styleFrom(
  //       padding: widget.padding,
  //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
  //     ),
  //     child: Container(
  //       decoration: _decoration,
  //       child: widget.title ?? _buildBody(context),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: _minHeight, maxWidth: _maxWidth),
      decoration: _decoration,
      child: ElevatedButton(
        onPressed: enable ? widget.onPressed : null,
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          overlayColor: MaterialStateProperty.resolveWith((states) => _textColor.withOpacity(0.3)),
          backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
          foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
          elevation: MaterialStateProperty.all(0),
          padding: MaterialStateProperty.resolveWith((states) => widget.padding),
          shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: widget.borderRadius ?? BorderRadius.circular(8.0))),
        ),
        child: widget.title ?? _buildBody(context),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Stack(
  //     fit: StackFit.passthrough,
  //     children: [
  //       Container(
  //         constraints: BoxConstraints(minHeight: _minHeight),
  //         child: ElevatedButton(
  //           onPressed: enable ? widget.onPressed : null,
  //           style: ButtonStyle(
  //             tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //             overlayColor: MaterialStateProperty.resolveWith((states) => _textColor.withOpacity(0.3)),
  //             backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
  //             foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
  //             // elevation: MaterialStateProperty.all(0),
  //             padding: MaterialStateProperty.resolveWith((states) => widget.padding),
  //             shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
  //           ),
  //           child: Opacity(child: widget.title ?? _buildBody(context), opacity: 0),
  //         ),
  //       ),
  //       Positioned.fill(
  //         child: IgnorePointer(
  //           child: Ink(
  //             decoration: _decoration,
  //             child: widget.title ?? _buildBody(context),
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }

  Widget _buildBody(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.prefixIconAssetPath != null) ...[
          SvgPicture.asset(widget.prefixIconAssetPath!, color: _textColor, width: 16.0, height: 16.0, cacheColorFilter: true),
          const SizedBox(width: 5.0),
        ],
        Flexible(
          child: AutoSizeText(
            widget.label!,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: _textStyle,
            overflowReplacement: AutoSizeText(
              widget.label!,
              textAlign: TextAlign.center,
              maxLines: _maxLines,
              overflow: TextOverflow.fade,
              style: _textStyle,
            ),
          ),
        ),
        if (widget.suffixIconAssetPath != null) ...[
          const SizedBox(width: 5.0),
          SvgPicture.asset(widget.suffixIconAssetPath!, color: _textColor, width: 16.0, height: 16.0, cacheColorFilter: true),
        ],
      ],
    );
  }

  void _handleControllerChanged() {
    setState(() {
      _enable = _effectiveController.enable;
      _state = _effectiveController.state;
      _visibility = _effectiveController.visibility;
    });
  }
}
