// ignore_for_file: comment_references

import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:nilts/src/change_priority.dart';

/// A class for `defined_void_callback_type` rule.
///
/// This rule checks defining `void Function()` type.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Practice
/// - Maturity level : Experimental
/// - Quick fix      : ✅
///
/// **Consider** replace `void Function()` with [VoidCallback] which is defined
/// in Flutter SDK.
///
/// **BAD:**
/// ```dart
/// final void Function() callback;
/// ```
///
/// **GOOD:**
/// ```dart
/// final VoidCallback callback;
/// ```
class DefinedVoidCallbackType extends DartLintRule {
  /// Create a new instance of [DefinedVoidCallbackType].
  const DefinedVoidCallbackType() : super(code: _code);

  static const _code = LintCode(
    name: 'defined_void_callback_type',
    problemMessage: '`VoidCallback` type is defined in Flutter SDK.',
    url: 'https://github.com/ronnnnn/nilts#defined_void_callback_type',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    // For VoidCallback.
    context.registry.addTypeAnnotation((node) {
      final type = node.type;
      // Do nothing if the type is not Function.
      if (type is! FunctionType) return;

      // Do nothing if Function has parameters.
      if (type.parameters.isNotEmpty) return;

      // Do nothing if the return type is not void.
      final returnType = type.returnType;
      if (returnType is! VoidType) return;

      reporter.reportErrorForNode(_code, node);
    });

    // For ValueChanged and ValueSetter.
    context.registry.addTypeAnnotation((node) {
      final type = node.type;
      // Do nothing if the type is not Function.
      if (type is! FunctionType) return;

      // Do nothing if Function don't have a parameter.
      if (type.parameters.length != 1) return;

      // Do nothing if the return type is not void.
      final returnType = type.returnType;
      if (returnType is! VoidType) return;

      reporter.reportErrorForNode(_code, node);
    });

    // For ValueGetter.
    context.registry.addTypeAnnotation((node) {
      final type = node.type;
      // Do nothing if the type is not Function.
      if (type is! FunctionType) return;

      // Do nothing if Function has parameters.
      if (type.parameters.isNotEmpty) return;

      // Do nothing if the return type is invalid or never.
      final returnType = type.returnType;
      if (returnType is InvalidType || returnType is NeverType) return;

      reporter.reportErrorForNode(_code, node);
    });

    // For IterableFilter.
    context.registry.addTypeAnnotation((node) {
      final type = node.type;
      // Do nothing if the type is not Function.
      if (type is! FunctionType) return;

      // Do nothing if Function don't have a parameter.
      if (type.parameters.length != 1) return;
      // Do nothing if Function don't have a iterable parameter.
      final parameter = type.parameters.first;
      if (!parameter.type.isDartCoreIterable) return;

      // Do nothing if the return type is not iterable.
      final returnType = type.returnType;
      if (!returnType.isDartCoreIterable) return;

      // Do nothing if the parameter type and return type are not same.
      if ((parameter.type as ParameterizedType).typeArguments.first.element !=
          (returnType as ParameterizedType).typeArguments.first.element) return;

      reporter.reportErrorForNode(_code, node);
    });

    // For AsyncCallback.
    context.registry.addTypeAnnotation((node) {
      final type = node.type;
      // Do nothing if the type is not Function.
      if (type is! FunctionType) return;

      // Do nothing if Function has parameters.
      if (type.parameters.isNotEmpty) return;

      // Do nothing if the return type is not future.
      final returnType = type.returnType;
      if (!returnType.isDartAsyncFuture) return;

      // Do nothing if the return generics type is not void.
      final returnParameterizedType =
          (returnType as ParameterizedType).typeArguments.first;
      if (returnParameterizedType is! VoidType) return;

      reporter.reportErrorForNode(_code, node);
    });

    // For AsyncValueSetter.
    context.registry.addTypeAnnotation((node) {
      final type = node.type;
      // Do nothing if the type is not Function.
      if (type is! FunctionType) return;

      // Do nothing if Function don't have a parameter.
      if (type.parameters.length != 1) return;

      // Do nothing if the return type is not future.
      final returnType = type.returnType;
      if (!returnType.isDartAsyncFuture) return;

      // Do nothing if the return generics type is not void.
      final returnParameterizedType =
          (returnType as ParameterizedType).typeArguments.first;
      if (returnParameterizedType is! VoidType) return;

      reporter.reportErrorForNode(_code, node);
    });

    // For AsyncValueGetter.
    context.registry.addTypeAnnotation((node) {
      final type = node.type;
      // Do nothing if the type is not Function.
      if (type is! FunctionType) return;

      // Do nothing if Function has parameters.
      if (type.parameters.isNotEmpty) return;

      // Do nothing if the return type is not future.
      final returnType = type.returnType;
      if (!returnType.isDartAsyncFuture) return;

      // Do nothing if the return generics type is invalid or never.
      final returnParameterizedType =
          (returnType as ParameterizedType).typeArguments.first;
      if (returnParameterizedType is InvalidType ||
          returnParameterizedType is NeverType) return;

      reporter.reportErrorForNode(_code, node);
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithVoidCallbackType(),
      ];
}

class _ReplaceWithVoidCallbackType extends DartFix {
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
        message: 'Replace with VoidCallback',
        priority: ChangePriority.replaceWithVoidCallback,
      )
          .addDartFileEdit((builder) {
        final delta = node.question != null ? -1 : 0;
        builder.addSimpleReplacement(
          node.sourceRange.getMoveEnd(delta),
          'VoidCallback',
        );
      });
    });
  }
}
