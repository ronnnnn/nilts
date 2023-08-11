import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // expect_lint: flaky_tests_with_set_up_all
  setUpAll(() => debugPrint('setUpAll'));
  // expect_lint: flaky_tests_with_set_up_all
  setUpAll(() async => debugPrint('setUpAll'));
  // expect_lint: flaky_tests_with_set_up_all
  setUpAll(() async {
    debugPrint('setUpAll');
  });

  setUp(() {});

  test('Test', () async {});

  group('Group', () {
    // expect_lint: flaky_tests_with_set_up_all
    setUpAll(() => debugPrint('setUpAll'));
    // expect_lint: flaky_tests_with_set_up_all
    setUpAll(() async => debugPrint('setUpAll'));
    // expect_lint: flaky_tests_with_set_up_all
    setUpAll(() async {
      debugPrint('setUpAll');
    });

    setUp(() {});

    test('Test', () async {});
  });
}
