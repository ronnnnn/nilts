// ignore_for_file: prefer_function_declarations_over_variables
// ignore_for_file: type_init_formals
// ignore_for_file: unused_element

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: MainButton(() {}),
        ),
      ),
    );
  }
}

class MainButton extends StatelessWidget {
  const MainButton(
    // expect_lint: defined_void_callback_type
    void Function() this.onPressed, {
    // expect_lint: defined_void_callback_type
    void Function()? this.onNullablePressed,
    super.key,
  });

  // expect_lint: defined_void_callback_type
  final void Function() onPressed;
  // expect_lint: defined_void_callback_type
  final void Function()? onNullablePressed;

  void _onPressed(
    // expect_lint: defined_void_callback_type
    void Function() onPressed, {
    // expect_lint: defined_void_callback_type
    void Function()? onNullablePressed,
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

void _globalFunction(
  // expect_lint: defined_void_callback_type
  void Function() onPressed, {
  // expect_lint: defined_void_callback_type
  void Function()? onNullablePressed,
}) {}
