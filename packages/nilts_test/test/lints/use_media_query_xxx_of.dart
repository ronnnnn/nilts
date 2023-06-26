// ignore_for_file: unused_local_variable
// ignore_for_file: invalid_null_aware_operator

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // expect_lint: use_media_query_xxx_of
    MediaQuery.of(context);
    // expect_lint: use_media_query_xxx_of
    MediaQuery.maybeOf(context);

    // expect_lint: use_media_query_xxx_of
    final size = MediaQuery.of(context).size;
    // expect_lint: use_media_query_xxx_of
    final nullableSize = MediaQuery.of(context)?.size;
    // expect_lint: use_media_query_xxx_of
    final maybeSize = MediaQuery.maybeOf(context)?.size;

    // expect_lint: use_media_query_xxx_of
    final orientation = MediaQuery.of(context).orientation;
    // expect_lint: use_media_query_xxx_of
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    // expect_lint: use_media_query_xxx_of
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    // expect_lint: use_media_query_xxx_of
    final platformBrightness = MediaQuery.of(context).platformBrightness;
    // expect_lint: use_media_query_xxx_of
    final padding = MediaQuery.of(context).padding;
    // expect_lint: use_media_query_xxx_of
    final viewInsets = MediaQuery.of(context).viewInsets;
    // expect_lint: use_media_query_xxx_of
    final systemGestureInsets = MediaQuery.of(context).systemGestureInsets;
    // expect_lint: use_media_query_xxx_of
    final viewPadding = MediaQuery.of(context).viewPadding;
    // expect_lint: use_media_query_xxx_of
    final alwaysUse24HourFormat = MediaQuery.of(context).alwaysUse24HourFormat;
    // expect_lint: use_media_query_xxx_of
    final accessibleNavigation = MediaQuery.of(context).accessibleNavigation;
    // expect_lint: use_media_query_xxx_of
    final invertColors = MediaQuery.of(context).invertColors;
    // expect_lint: use_media_query_xxx_of
    final highContrast = MediaQuery.of(context).highContrast;
    // expect_lint: use_media_query_xxx_of
    final disableAnimations = MediaQuery.of(context).disableAnimations;
    // expect_lint: use_media_query_xxx_of
    final boldText = MediaQuery.of(context).boldText;
    // expect_lint: use_media_query_xxx_of
    final navigationMode = MediaQuery.of(context).navigationMode;
    // expect_lint: use_media_query_xxx_of
    final gestureSettings = MediaQuery.of(context).gestureSettings;
    // expect_lint: use_media_query_xxx_of
    final displayFeatures = MediaQuery.of(context).displayFeatures;

    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
