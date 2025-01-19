// ignore_for_file: document_ignores
// ignore_for_file: avoid_js_rounded_ints
// ignore_for_file: prefer_const_declarations
// ignore_for_file: prefer_final_locals
// ignore_for_file: unused_element
// ignore_for_file: unused_local_variable

const _globalConstant1 = 1234;
// expect_lint: low_readability_numeric_literals
const _globalConstant2 = 12345;

var _globalVariable1 = 1234;
// expect_lint: low_readability_numeric_literals
var _globalVariable2 = 12345;

final _globalFinal1 = 1234;
// expect_lint: low_readability_numeric_literals
final _globalFinal2 = 12345;

void main() {
  const constant1 = 1234;
  // expect_lint: low_readability_numeric_literals
  const constant2 = 12345;
  const constant3 = 12_345;
  // expect_lint: low_readability_numeric_literals
  const constant4 = 1234567890;
  const constant5 = 1_234_567_890;
  // expect_lint: low_readability_numeric_literals
  const constant6 = 123456789012345;
  const constant7 = 123_456_789_012_345;

  var variable1 = 1234;
  // expect_lint: low_readability_numeric_literals
  var variable2 = 12345;
  var variable3 = 12_345;
  // expect_lint: low_readability_numeric_literals
  var variable4 = 1234567890;
  var variable5 = 1_234_567_890;
  // expect_lint: low_readability_numeric_literals
  var variable6 = 123456789012345;
  var variable7 = 123_456_789_012_345;

  final final1 = 1234;
  // expect_lint: low_readability_numeric_literals
  final final2 = 12345;
  final final3 = 12_345;
  // expect_lint: low_readability_numeric_literals
  final final4 = 1234567890;
  final final5 = 1_234_567_890;
  // expect_lint: low_readability_numeric_literals
  final final6 = 123456789012345;
  final final7 = 123_456_789_012_345;

  const hex1 = 0x1234;
  // expect_lint: low_readability_numeric_literals
  const hex2 = 0x12345;
  const hex3 = 0x12_345;
  // expect_lint: low_readability_numeric_literals
  const hex4 = 0x1234567890;
  const hex5 = 0x1_234_567_890;
  // expect_lint: low_readability_numeric_literals
  const hex6 = 0x123456789012345;
  const hex7 = 0x123_456_789_012_345;
}
