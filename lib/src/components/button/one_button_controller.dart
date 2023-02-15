part of '../../../libary/one_libary.dart';

class OneButtonController extends ValueNotifier<OneButtonValue> {
  OneButtonController({
    bool enable = true,
    OneButtonState state = OneButtonState.primary,
    String? label,
    OneVisibility visibility = OneVisibility.VISIBLE,
  }) : super(OneButtonValue(
          enable: enable,
          state: state,
          label: label,
          visibility: visibility,
        ));

  OneButtonController.fromValue(OneButtonValue value) : super(value);

  bool get enable => value.enable;
  OneButtonState get state => value.state;
  String? get label => value.label;
  OneVisibility get visibility => value.visibility;

  set enable(bool enable) => value = value.copyWith(enable: enable);
  set state(OneButtonState state) => value = value.copyWith(state: state);
  set label(String? label) => value = value.copyWith(label: label);
  set visibility(OneVisibility visibility) => value = value.copyWith(visibility: visibility);
}
