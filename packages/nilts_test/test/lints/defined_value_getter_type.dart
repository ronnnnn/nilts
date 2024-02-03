// ignore_for_file: prefer_function_declarations_over_variables
// ignore_for_file: type_init_formals
// ignore_for_file: unused_element
// ignore_for_file: defined_value_changed_type
// ignore_for_file: defined_value_setter_type
// ignore_for_file: defined_void_callback_type

import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  const MainButton(
    void Function() this.onPressed,
    // expect_lint: defined_value_getter_type
    int Function() this.onReturnPressed, {
    void Function()? this.onNullablePressed,
    void Function(int)? this.onParamPressed,
    // expect_lint: defined_value_getter_type
    int Function()? this.onNullableReturnPressed,
    super.key,
  });

  final void Function() onPressed;
  // expect_lint: defined_value_getter_type
  final int Function() onReturnPressed;
  final void Function()? onNullablePressed;
  final void Function(int)? onParamPressed;
  // expect_lint: defined_value_getter_type
  final int Function()? onNullableReturnPressed;

  void _onPressed(
    void Function() onPressed,
    // expect_lint: defined_value_getter_type
    int Function() onReturnPressed, {
    void Function()? onNullablePressed,
    void Function(int)? onParamPressed,
    // expect_lint: defined_value_getter_type
    int Function()? onNullableReturnPressed,
  }) {}

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        _onPressed(
          () {},
          () => 0,
        );
        onPressed();
      },
      child: const Text('Hello World!'),
    );
  }
}

final void Function() globalFunction = () {};
// expect_lint: defined_value_getter_type
final int Function() globalReturnFunction = () => 0;
const void Function()? globalNullableFunction = null;
const void Function(int)? globalParamFunction = null;
// expect_lint: defined_value_getter_type
const int Function()? globalNullableReturnFunction = null;

void _globalFunction(
  void Function() onPressed,
  // expect_lint: defined_value_getter_type
  int Function() onReturnPressed, {
  void Function()? onNullablePressed,
  void Function(int)? onParamPressed,
  // expect_lint: defined_value_getter_type
  int Function()? onNullableReturnPressed,
}) {}
