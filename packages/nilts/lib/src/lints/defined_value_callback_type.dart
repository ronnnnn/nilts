// ignore_for_file: comment_references

import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:nilts/src/change_priority.dart';

/// A class for `defined_value_changed_type` rule.
///
/// This rule checks defining `void Function(T value)` type.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Practice
/// - Maturity level : Experimental
/// - Quick fix      : ✅
///
/// **Consider** replace `void Function(T value)` with [ValueChanged]
/// which is defined in Flutter SDK.
///
/// **BAD:**
/// ```dart
/// final void Function(int value) callback;
/// ```
///
/// **GOOD:**
/// ```dart
/// final ValueChanged<int> callback;
/// ```
class DefinedValueChangedType extends _DefinedValueCallbackType {
  /// Create a new instance of [DefinedValueChangedType].
  const DefinedValueChangedType() : super(_code);

  static const _code = LintCode(
    name: 'defined_value_changed_type',
    problemMessage: '`ValueChanged<T>` type is defined in Flutter SDK.',
    url: 'https://github.com/ronnnnn/nilts#defined_value_changed_type',
  );

  @override
  List<Fix> getFixes() => [
        _ReplaceWithValueChanged(),
      ];
}

/// A class for `defined_value_setter_type` rule.
///
/// This rule checks defining `void Function(T value)` type.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Practice
/// - Maturity level : Experimental
/// - Quick fix      : ✅
///
/// **Consider** replace `void Function(T value)` with [ValueSetter]
/// which is defined in Flutter SDK.
///
/// **BAD:**
/// ```dart
/// final void Function(int value) callback;
/// ```
///
/// **GOOD:**
/// ```dart
/// final ValueSetter<int> callback;
/// ```
class DefinedValueSetterType extends _DefinedValueCallbackType {
  /// Create a new instance of [DefinedValueSetterType].
  const DefinedValueSetterType() : super(_code);

  static const _code = LintCode(
    name: 'defined_value_setter_type',
    problemMessage: '`ValueSetter<T>` type is defined in Flutter SDK.',
    url: 'https://github.com/ronnnnn/nilts#defined_value_setter_type',
  );

  @override
  List<Fix> getFixes() => [
        _ReplaceWithValueSetter(),
      ];
}

class _ReplaceWithValueChanged extends _ReplaceWithValueCallbackType {
  _ReplaceWithValueChanged()
      : super(
          'ValueChanged',
          ChangePriority.replaceWithValueChanged,
        );
}

class _ReplaceWithValueSetter extends _ReplaceWithValueCallbackType {
  _ReplaceWithValueSetter()
      : super(
          'ValueSetter',
          ChangePriority.replaceWithValueSetter,
        );
}

class _DefinedValueCallbackType extends DartLintRule {
  const _DefinedValueCallbackType(LintCode code)
      : _lintCode = code,
        super(code: code);

  final LintCode _lintCode;

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

      // Do nothing if Function doesn't have a parameter.
      if (type.parameters.length != 1) return;

      final param = type.parameters.first;
      // Do nothing if the parameter is named or optional.
      if (param.isNamed || param.isOptional) return;

      // Do nothing if the return type is not void.
      final returnType = type.returnType;
      if (returnType is! VoidType) return;

      reporter.reportErrorForNode(_lintCode, node);
    });
  }
}

class _ReplaceWithValueCallbackType extends DartFix {
  _ReplaceWithValueCallbackType(
    this._typeName,
    this._changePriority,
  );

  final String _typeName;
  final int _changePriority;

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
        message: 'Replace with $_typeName<T>',
        priority: _changePriority,
      )
          .addDartFileEdit((builder) {
        final paramTypeName = (node.type! as FunctionType)
            .parameters
            .first
            .type
            .element!
            .displayName;

        final delta = node.question != null ? -1 : 0;
        builder.addSimpleReplacement(
          node.sourceRange.getMoveEnd(delta),
          '$_typeName<$paramTypeName>',
        );
      });
    });
  }
}
