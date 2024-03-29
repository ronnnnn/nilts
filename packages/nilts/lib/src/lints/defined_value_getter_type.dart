// ignore_for_file: comment_references

import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:nilts/src/change_priority.dart';

/// A class for `defined_value_getter_type` rule.
///
/// This rule checks defining `T Function()` type.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Practice
/// - Maturity level : Experimental
/// - Quick fix      : ✅
///
/// **Consider** replace `T Function()` with [ValueGetter] which is defined
/// in Flutter SDK.
///
/// **BAD:**
/// ```dart
/// final int Function() callback;
/// ```
///
/// **GOOD:**
/// ```dart
/// final ValueGetter<int> callback;
/// ```
///
/// See also:
///
/// - [ValueGetter typedef - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/ValueGetter.html)
class DefinedValueGetterType extends DartLintRule {
  /// Create a new instance of [DefinedValueGetterType].
  const DefinedValueGetterType() : super(code: _code);

  static const _code = LintCode(
    name: 'defined_value_getter_type',
    problemMessage: '`ValueGetter<T>` type is defined in Flutter SDK.',
    url: 'https://github.com/ronnnnn/nilts#defined_value_getter_type',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addTypeAnnotation((node) {
      final type = node.type;
      // Do nothing if the type is not Function.
      if (type is! FunctionType) return;

      // Do nothing if Function has parameters.
      if (type.parameters.isNotEmpty) return;

      // Do nothing if the return type is not void.
      final returnType = type.returnType;
      if (returnType is VoidType ||
          returnType is InvalidType ||
          returnType is NeverType ||
          returnType.isDartAsyncFuture) return;

      reporter.reportErrorForNode(_code, node);
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithValueGetter(),
      ];
}

class _ReplaceWithValueGetter extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addTypeAnnotation((node) {
      if (!node.sourceRange.intersects(analysisError.sourceRange)) return;

      reporter
          .createChangeBuilder(
        message: 'Replace with ValueGetter<T>',
        priority: ChangePriority.replaceWithValueGetter,
      )
          .addDartFileEdit((builder) {
        final returnTypeName =
            (node.type! as FunctionType).returnType.element!.displayName;

        final delta = node.question != null ? -1 : 0;
        builder.addSimpleReplacement(
          node.sourceRange.getMoveEnd(delta),
          'ValueGetter<$returnTypeName>',
        );
      });
    });
  }
}
