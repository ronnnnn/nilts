// ignore_for_file: prefer_function_declarations_over_variables
// ignore_for_file: type_init_formals
// ignore_for_file: unused_element

import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  const MainButton(
    // expect_lint: defined_void_callback_type
    void Function() this.onPressed, {
    // expect_lint: defined_void_callback_type
    void Function()? this.onNullablePressed,
    void Function(int)? this.onParamPressed,
    int Function()? this.onNotVoidPressed,
    Iterable<int> Function(Iterable<int>)? this.onIterablePressed,
    Iterable<int> Function(Iterable<bool>)? this.onDifferentIterablePressed,
    Future<void> Function()? this.onFuturePressed,
    Future<void> Function(int)? this.onFutureParamPressed,
    Future<int> Function()? this.onFutureReturnPressed,
    super.key,
  });

  // expect_lint: defined_void_callback_type
  final void Function() onPressed;
  // expect_lint: defined_void_callback_type
  final void Function()? onNullablePressed;
  final void Function(int)? onParamPressed;
  final int Function()? onNotVoidPressed;
  final Iterable<int> Function(Iterable<int>)? onIterablePressed;
  final Iterable<int> Function(Iterable<bool>)? onDifferentIterablePressed;
  final Future<void> Function()? onFuturePressed;
  final Future<void> Function(int)? onFutureParamPressed;
  final Future<int> Function()? onFutureReturnPressed;

  void _onPressed(
    // expect_lint: defined_void_callback_type
    void Function() onPressed, {
    // expect_lint: defined_void_callback_type
    void Function()? onNullablePressed,
    void Function(int)? onParamPressed,
    int Function()? onNotVoidPressed,
    Iterable<int> Function(Iterable<int>)? onIterablePressed,
    Iterable<int> Function(Iterable<bool>)? onDifferentIterablePressed,
    Future<void> Function()? onFuturePressed,
    Future<void> Function(int)? onFutureParamPressed,
    Future<int> Function()? onFutureReturnPressed,
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
const Iterable<int> Function(Iterable<int>)? globalIterableFunction = null;
const Iterable<int> Function(Iterable<bool>)? globalDifferentIterableFunction =
    null;
const Future<void> Function()? globalFutureFunction = null;
const Future<void> Function(int)? globalFutureParamFunction = null;
const Future<int> Function()? globalFutureReturnFunction = null;

void _globalFunction(
  // expect_lint: defined_void_callback_type
  void Function() onPressed, {
  // expect_lint: defined_void_callback_type
  void Function()? onNullablePressed,
  void Function(int)? onParamPressed,
  int Function()? onNotVoidPressed,
  Iterable<int> Function(Iterable<int>)? onIterablePressed,
  Iterable<int> Function(Iterable<bool>)? onDifferentIterablePressed,
  Future<void> Function()? onFuturePressed,
  Future<void> Function(int)? onFutureParamPressed,
  Future<int> Function()? onFutureReturnPressed,
}) {}
