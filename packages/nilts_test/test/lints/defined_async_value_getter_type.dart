// ignore_for_file: prefer_function_declarations_over_variables
// ignore_for_file: type_init_formals
// ignore_for_file: unused_element
// ignore_for_file: defined_value_getter_type
// ignore_for_file: defined_async_callback_type
// ignore_for_file: defined_async_value_setter_type

import 'dart:async';

import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  const MainButton(
    Future<void> Function() this.onPressed,
    // expect_lint: defined_async_value_getter_type
    Future<int> Function() this.onReturnPressed,
    int Function() this.onFutureReturnPressed, {
    Future<void> Function()? this.onNullablePressed,
    Future<void> Function(int)? this.onParamPressed,
    // expect_lint: defined_async_value_getter_type
    Future<int> Function()? this.onNullableReturnPressed,
    int Function()? this.onNullableFutureReturnPressed,
    super.key,
  });

  final Future<void> Function() onPressed;
  // expect_lint: defined_async_value_getter_type
  final Future<int> Function() onReturnPressed;
  final int Function() onFutureReturnPressed;
  final Future<void> Function()? onNullablePressed;
  final Future<void> Function(int)? onParamPressed;
  // expect_lint: defined_async_value_getter_type
  final Future<int> Function()? onNullableReturnPressed;
  final int Function()? onNullableFutureReturnPressed;

  void _onPressed(
    Future<void> Function() onPressed,
    // expect_lint: defined_async_value_getter_type
    Future<int> Function() onReturnPressed,
    int Function() onFutureReturnPressed, {
    Future<void> Function()? onNullablePressed,
    Future<void> Function(int)? onParamPressed,
    // expect_lint: defined_async_value_getter_type
    Future<int> Function()? onNullableReturnPressed,
    int Function()? onNullableFutureReturnPressed,
  }) {}

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        _onPressed(
          () async {},
          () async => 0,
          () => 0,
        );
        onPressed();
      },
      child: const Text('Hello World!'),
    );
  }
}

final Future<void> Function() globalFunction = () async {};
// expect_lint: defined_async_value_getter_type
final Future<int> Function() globalReturnFunction = () async => 0;
final int Function() globalFutureReturnFunction = () => 0;
const Future<void> Function()? globalNullableFunction = null;
const Future<void> Function(int)? globalParamFunction = null;
// expect_lint: defined_async_value_getter_type
const Future<int> Function()? globalNullableReturnFunction = null;
const int Function()? globalNullableFutureReturnFunction = null;

void _globalFunction(
  Future<void> Function() onPressed,
  // expect_lint: defined_async_value_getter_type
  Future<int> Function() onReturnPressed,
  int Function() onFutureReturnPressed, {
  Future<void> Function()? onNullablePressed,
  Future<void> Function(int)? onParamPressed,
  // expect_lint: defined_async_value_getter_type
  Future<int> Function()? onNullableReturnPressed,
  int Function()? onNullableFutureReturnPressed,
}) {}
