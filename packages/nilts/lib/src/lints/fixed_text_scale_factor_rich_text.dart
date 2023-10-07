// ignore_for_file: comment_references

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:nilts/src/change_priority.dart';
import 'package:nilts/src/utils/library_element_ext.dart';

/// A class for `fixed_text_scale_factor_rich_text` rule.
///
/// This rule checks if `textScaleFactor` is missing in [RichText] constructor.
///
/// - Target SDK: Any versions nilts supports
/// - Rule type: Practice
/// - Maturity level: Experimental
/// - Quick fix: ✅
///
/// **Consider** adding `textScaleFactor` argument to [RichText] constructor to
/// make the text size responsive for user setting.
///
/// **BAD:**
/// ```dart
/// RichText(
///   text: TextSpan(
///     text: 'Hello, world!',
///   ),
/// )
/// ```
///
/// **GOOD:**
/// ```dart
/// RichText(
///   text: TextSpan(
///     text: 'Hello, world!',
///   ),
///   textScaleFactor: MediaQuery.textScaleFactorOf(context),
/// )
/// ```
///
/// See also:
///
/// - [RichText class - widgets library - Dart API](https://api.flutter.dev/flutter/widgets/RichText-class.html)
class FixedTextScaleFactorRichText extends DartLintRule {
  /// Create a new instance of [FixedTextScaleFactorRichText].
  const FixedTextScaleFactorRichText() : super(code: _code);

  static const _code = LintCode(
    name: 'fixed_text_scale_factor_rich_text',
    problemMessage: 'default textScaleFactor value of RichText constructor is '
        'fixed value.',
    url: 'https://github.com/ronnnnn/nilts#fixed_text_scale_factor_rich_text',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      // Do nothing if the package of constructor is not `flutter`.
      final constructorName = node.constructorName;
      final library = constructorName.staticElement?.library;
      if (library == null) return;
      if (!library.isFlutter) return;

      // Do nothing if the constructor name is not `RichText`.
      if (constructorName.type.element?.name != 'RichText') return;

      // Do nothing if the constructor has `textScaleFactor` argument.
      final arguments = node.argumentList.arguments;
      final isTextScaleFactorSet = arguments.any(
        (argument) =>
            argument is NamedExpression &&
            argument.name.label.name == 'textScaleFactor',
      );
      if (isTextScaleFactorSet) return;

      reporter.reportErrorForNode(_code, node);
    });
  }

  @override
  List<Fix> getFixes() => [
        _AddTextScaleFactor(),
      ];
}

class _AddTextScaleFactor extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      if (!node.sourceRange.intersects(analysisError.sourceRange)) return;

      // Do nothing if the constructor name is not `RichText`.
      final constructorName = node.constructorName;
      if (constructorName.type.element?.name != 'RichText') return;

      reporter
          .createChangeBuilder(
        message: 'Add textScaleFactor',
        priority: ChangePriority.addTextScaleFactor,
      )
          .addDartFileEdit((builder) {
        builder.addSimpleInsertion(
          node.argumentList.arguments.last.end,
          ',\ntextScaleFactor: MediaQuery.textScaleFactorOf(context)',
        );
      });
    });
  }
}
