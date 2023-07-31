import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:nilts/src/change_priority.dart';
import 'package:nilts/src/dart_version.dart';

/// A class for `unnecessary_rebuilds_from_media_query` rule.
///
/// This rule checks if
/// `MediaQuery.of(context)` or `MediaQuery.maybeOf(context)` is used
/// instead of `MediaQuery.xxxOf(context)` or `MediaQuery.maybeXxxOf(context)`.
///
/// - Target SDK: >= Flutter 3.10.0 (Dart 3.0.0)
/// - Rule type: Practice
/// - Maturity level: Experimental
/// - Quick fix: ✅
///
/// Prefer using
/// `MediaQuery.xxxOf(context)` or `MediaQuery.maybeXxxOf(context)`
/// instead of `MediaQuery.of(context)` or `MediaQuery.maybeOf(context)`
/// to avoid unnecessary rebuilds.
///
/// **BAD:**
/// ```dart
/// final size = MediaQuery.of(context).size;
/// ```
///
/// **GOOD:**
/// ```dart
/// final size = MediaQuery.sizeOf(context);
/// ```
///
/// Note that using `MediaQuery.of(context)` or `MediaQuery.maybeOf(context)`
/// makes sense in case of observing `MediaQueryData` object changes or
/// referring to many properties of `MediaQueryData`.
///
/// See also:
///
/// - [MediaQuery as InheritedModel by moffatman · Pull Request #114459 · flutter/flutter](https://github.com/flutter/flutter/pull/114459)
/// - [MediaQuery class - widgets library - Dart API](https://api.flutter.dev/flutter/widgets/MediaQuery-class.html)
class UnnecessaryRebuildsFromMediaQuery extends DartLintRule {
  /// Create a new instance of UseMediaQueryXxxOf.
  const UnnecessaryRebuildsFromMediaQuery() : super(code: _code);

  static const _code = LintCode(
    name: 'unnecessary_rebuilds_from_media_query',
    problemMessage: 'Prefer using '
        'MediaQuery.xxxOf(context) or MediaQuery.maybeXxxOf(context) '
        'instead of MediaQuery.of(context) or MediaQuery.maybeOf(context) '
        'to avoid unnecessary rebuilds.',
    url:
        'https://github.com/ronnnnn/nilts#unnecessary_rebuilds_from_media_query',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodInvocation((node) {
      // Do nothing if dart version is below 3.0.0.
      if (DartVersion.fromPlatform() <
          const DartVersion(major: 3, minor: 0, patch: 0)) {
        return;
      }

      // Do nothing if the method name is not `of` and not `maybeOf`.
      final methodName = node.methodName;
      if (methodName.name != 'of' && methodName.name != 'maybeOf') return;

      // Do nothing if the method argument's type is not `BuildContext`.
      final arguments = node.argumentList.arguments;
      if (arguments.length != 1) return;
      final firstArgument = node.argumentList.arguments.first.staticType;
      if (firstArgument == null) return;
      final hasContextParam = const TypeChecker.fromName(
        'BuildContext',
        packageName: 'flutter',
      ).isExactlyType(firstArgument);
      if (!hasContextParam) return;

      // Do nothing if the package of method is not `flutter`.
      final library = methodName.staticElement?.library;
      if (library == null) return;
      final libraryUri = Uri.tryParse(library.identifier);
      if (libraryUri == null) return;
      if (libraryUri.scheme != 'package' ||
          libraryUri.pathSegments.first != 'flutter') return;

      // Do nothing if the operator of method is not `.`.
      final operatorToken = node.operator;
      if (operatorToken?.type != TokenType.PERIOD) return;

      // Do notion if the class of method is not `MediaQuery`.
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
  /// All data that `MediaQueryData` depends on.
  ///
  /// See also: https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/widgets/media_query.dart#L36C4-L36C4
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
    // Do nothing if the operator of method is not `.` and not `?.`.
    final operatorToken = node.operator;
    if (operatorToken.type != TokenType.PERIOD &&
        operatorToken.type != TokenType.QUESTION_PERIOD) return;

    final methodTarget = node.realTarget;
    if (methodTarget is! MethodInvocation) return;
    final methodName = methodTarget.methodName.name;
    // Do nothing if the method name which the property depends on
    // is not `of` and not `maybeOf`.
    if (methodName == 'of') {
      reporter
          .createChangeBuilder(
        message: 'Replace With MediaQuery.${property}Of(context)',
        priority: ChangePriority.replaceWithMediaQueryXxxOf,
      )
          .addDartFileEdit((builder) {
        builder.addSimpleReplacement(
          methodTarget.methodName.sourceRange.getMoveEnd(
            (methodTarget.typeArguments?.length ?? 0) +
                methodTarget.argumentList.length +
                node.operator.length +
                node.propertyName.length,
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
          methodTarget.methodName.sourceRange.getMoveEnd(
            (methodTarget.typeArguments?.length ?? 0) +
                methodTarget.argumentList.length +
                node.operator.length +
                node.propertyName.length,
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

      // Do nothing if MediaQueryData doesn't have the property.
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
