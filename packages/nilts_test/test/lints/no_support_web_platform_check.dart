import 'dart:io';

import 'package:flutter/foundation.dart';

// expect_lint: no_support_web_platform_check
bool get isLinux => !kIsWeb && Platform.isLinux;

// expect_lint: no_support_web_platform_check
bool get isMacOS => !kIsWeb && Platform.isMacOS;

// expect_lint: no_support_web_platform_check
bool get isWindows => !kIsWeb && Platform.isWindows;

// expect_lint: no_support_web_platform_check
bool get isAndroid => !kIsWeb && Platform.isAndroid;

// expect_lint: no_support_web_platform_check
bool get isIOS => !kIsWeb && Platform.isIOS;

// expect_lint: no_support_web_platform_check
bool get isFuchsia => !kIsWeb && Platform.isFuchsia;

bool get isLinuxApp => !kIsWeb && defaultTargetPlatform == TargetPlatform.linux;

bool get isMacOSApp => !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;

bool get isWindowsApp =>
    !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;

bool get isAndroidApp =>
    !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

bool get isIOSApp => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

bool get isFuchsiaApp =>
    !kIsWeb && defaultTargetPlatform == TargetPlatform.fuchsia;
