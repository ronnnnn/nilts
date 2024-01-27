// ignore_for_file: prefer_function_declarations_over_variables
// ignore_for_file: type_init_formals
// ignore_for_file: unused_element
// ignore_for_file: defined_value_changed_type
// ignore_for_file: defined_value_setter_type

import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  const MainButton(
    // expect_lint: defined_void_callback_type
    void Function() this.onPressed, {
    // expect_lint: defined_void_callback_type
    void Function()? this.onNullablePressed,
    void Function(int)? this.onParamPressed,
    int Function()? this.onNotVoidPressed,
    super.key,
  });

  // expect_lint: defined_void_callback_type
  final void Function() onPressed;
  // expect_lint: defined_void_callback_type
  final void Function()? onNullablePressed;
  final void Function(int)? onParamPressed;
  final int Function()? onNotVoidPressed;

  void _onPressed(
    // expect_lint: defined_void_callback_type
    void Function() onPressed, {
    // expect_lint: defined_void_callback_type
    void Function()? onNullablePressed,
    void Function(int)? onParamPressed,
    int Function()? onNotVoidPressed,
  }) {}

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        _onPressed(() {});
        onPressed();
      },
      child: const Text('Hello World!'),
    );
  }
}

// expect_lint: defined_void_callback_type
final void Function() globalFunction = () {};
// expect_lint: defined_void_callback_type
const void Function()? globalNullableFunction = null;
const void Function(int)? globalParamFunction = null;
const int Function()? globalNotVoidFunction = null;

void _globalFunction(
  // expect_lint: defined_void_callback_type
  void Function() onPressed, {
  // expect_lint: defined_void_callback_type
  void Function()? onNullablePressed,
  void Function(int)? onParamPressed,
  int Function()? onNotVoidPressed,
}) {}
