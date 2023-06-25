import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:nilts/src/change_priority.dart';

class UseMediaQueryXxxOf extends DartLintRule {
  const UseMediaQueryXxxOf() : super(code: _code);

  static const _code = LintCode(
    name: 'use_media_query_xxx_of',
    problemMessage: 'Prefer using MediaQuery.xxxOf(context) instead of '
        'MediaQuery.of(context) or MediaQuery.maybeOf(context) '
        'to avoid unnecessary rebuilds.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodInvocation((node) {
      // validate method name
      final methodName = node.methodName;
      if (methodName.name != 'of' && methodName.name != 'maybeOf') return;

      // validate method argument
      final arguments = node.argumentList.arguments;
      if (arguments.length > 1) return;
      final firstArgument = node.argumentList.arguments.firstOrNull?.staticType;
      if (firstArgument == null) return;
      final hasContextParam = const TypeChecker.fromName(
        'BuildContext',
        packageName: 'flutter',
      ).isExactlyType(firstArgument);
      if (!hasContextParam) return;

      // validate library
      final library = methodName.staticElement?.library;
      if (library == null) return;
      final libraryUri = Uri.tryParse(library.identifier);
      if (libraryUri == null) return;
      if (libraryUri.scheme != 'package' ||
          libraryUri.pathSegments.first != 'flutter') return;

      // validate operator
      final operatorToken = node.operator;
      if (operatorToken?.type != TokenType.PERIOD) return;

      // validate class name
      final target = node.realTarget;
      if (target is! SimpleIdentifier) return;
      final isMediaQuery = target.name == 'MediaQuery';
      if (!isMediaQuery) return;

      reporter.reportErrorForNode(_code, node.methodName);
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithMediaQueryXxxOf(),
      ];
}

class _ReplaceWithMediaQueryXxxOf extends DartFix {
  // fixed value for range of "of(context)."
  static const int _rangeDeltaForOf = 12;

  // fixed value for range of "of(context)?."
  static const int _rangeDeltaForOfWithQuestionPeriod = 13;

  // fixed value for range of "maybeOf(context)?."
  static const int _rangeDeltaForMaybeOf = 18;

  // https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/widgets/media_query.dart#L36C4-L36C4
  static const List<String> _properties = [
    'size',
    'orientation',
    'devicePixelRatio',
    'textScaleFactor',
    'platformBrightness',
    'padding',
    'viewInsets',
    'systemGestureInsets',
    'viewPadding',
    'alwaysUse24HourFormat',
    'accessibleNavigation',
    'invertColors',
    'highContrast',
    'disableAnimations',
    'boldText',
    'navigationMode',
    'gestureSettings',
    'displayFeatures',
  ];

  void _runInternal({
    required ChangeReporter reporter,
    required PropertyAccess node,
    required String property,
  }) {
    // validate operator
    final operatorToken = node.operator;
    if (operatorToken.type != TokenType.PERIOD &&
        operatorToken.type != TokenType.QUESTION_PERIOD) return;

    final methodTarget = node.realTarget;
    if (methodTarget is! MethodInvocation) return;
    final methodName = methodTarget.methodName.name;

    if (methodName == 'of') {
      final isQuestionPeriod = operatorToken.type == TokenType.QUESTION_PERIOD;
      final delta = isQuestionPeriod
          ? _rangeDeltaForOfWithQuestionPeriod
          : _rangeDeltaForOf;

      reporter
          .createChangeBuilder(
        message: 'Replace With MediaQuery.${property}Of(context)',
        priority: ChangePriority.replaceWithMediaQueryXxxOf,
      )
          .addDartFileEdit((builder) {
        builder.addSimpleReplacement(
          SourceRange(
            node.propertyName.sourceRange.offset - delta,
            node.propertyName.sourceRange.length + delta,
          ),
          '${property}Of(context)',
        );
      });
    } else if (methodName == 'maybeOf') {
      final maybeProperty =
          '${property[0].toUpperCase()}${property.substring(1)}';
      reporter
          .createChangeBuilder(
        message: 'Replace With MediaQuery.maybe${maybeProperty}Of(context)',
        priority: ChangePriority.replaceWithMediaQueryXxxOf,
      )
          .addDartFileEdit((builder) {
        builder.addSimpleReplacement(
          SourceRange(
            node.propertyName.sourceRange.offset - _rangeDeltaForMaybeOf,
            node.propertyName.sourceRange.length + _rangeDeltaForMaybeOf,
          ),
          'maybe${maybeProperty}Of(context)',
        );
      });
    }
  }

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addPropertyAccess((node) {
      if (!node.sourceRange.intersects(analysisError.sourceRange)) return;

      final property = node.propertyName.name;
      if (!_properties.contains(property)) return;

      _runInternal(
        reporter: reporter,
        node: node,
        property: property,
      );
    });
  }
}
