import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:nilts/src/change_priority.dart';

class DefinedVoidCallbackType extends DartLintRule {
  /// Create a new instance of [DefinedVoidCallbackType].
  const DefinedVoidCallbackType() : super(code: _code);

  static const _code = LintCode(
    name: 'defined_void_callback_type',
    problemMessage: 'VoidCallback type is defined in SDK.',
    url: 'https://github.com/ronnnnn/nilts#defined_void_callback_type',
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
      if (returnType is! VoidType) return;

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
