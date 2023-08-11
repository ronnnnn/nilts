import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:nilts/src/change_priority.dart';

class FlakyTestsWithSetUpAll extends DartLintRule {
  const FlakyTestsWithSetUpAll() : super(code: _code);

  static const _code = LintCode(
    name: 'flaky_tests_with_set_up_all',
    problemMessage: 'Consider using setUp function or '
        'initialization on top level or body of group. '
        'setUpAll may cause flaky tests with concurrency executions.',
    url: 'https://github.com/ronnnnn/nilts#flaky_tests_with_set_up_all',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodInvocation((node) {
      // Do nothing if the method name is not `setUpAll`.
      final methodName = node.methodName;
      if (methodName.name != 'setUpAll') return;

      // Do nothing if the method argument's type is not `Function`.
      final arguments = node.argumentList.arguments;
      if (arguments.length != 1) return;
      final firstArgument = node.argumentList.arguments.first.staticType;
      if (firstArgument == null) return;
      if (firstArgument is! FunctionType) return;

      // Do nothing if the package of method is not `flutter_test`.
      final library = methodName.staticElement?.library;
      if (library == null) return;
      final libraryUri = Uri.tryParse(library.identifier);
      if (libraryUri == null) return;
      if (libraryUri.scheme != 'package' ||
          libraryUri.pathSegments.first != 'flutter_test') return;

      reporter.reportErrorForNode(_code, node.methodName);
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithSetUp(),
        _UnwrapSetUpAll(),
      ];
}

class _ReplaceWithSetUp extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addMethodInvocation((node) {
      if (!node.sourceRange.intersects(analysisError.sourceRange)) return;

      // Do nothing if the method name is not `setUpAll`.
      final methodName = node.methodName;
      if (methodName.name != 'setUpAll') return;

      reporter
          .createChangeBuilder(
        message: 'Replace With setUp',
        priority: ChangePriority.replaceWithSetUp,
      )
          .addDartFileEdit((builder) {
        builder.addSimpleReplacement(node.methodName.sourceRange, 'setUp');
      });
    });
  }
}

class _UnwrapSetUpAll extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addMethodInvocation((node) {
      if (!node.sourceRange.intersects(analysisError.sourceRange)) return;

      // Do nothing if the method name is not `setUpAll`.
      final methodName = node.methodName;
      if (methodName.name != 'setUpAll') return;

      reporter
          .createChangeBuilder(
        message: 'Unwrap setUpAll',
        priority: ChangePriority.unwrapSetUpAll,
      )
          .addDartFileEdit((builder) {
        final arguments = node.argumentList;
        final functionArgument = arguments.arguments.first;
        // Do nothing if the function argument is not `Function`.
        if (functionArgument is! FunctionExpression) return;

        final parameters = functionArgument.parameters;
        final typeParameters = functionArgument.typeParameters;
        final functionBody = functionArgument.body;
        final star = functionBody.star;
        final keyword = functionBody.keyword;

        // Delete `);`.
        builder
          ..addDeletion(SourceRange(node.endToken.end, 1))
          ..addDeletion(node.endToken.sourceRange);

        if (functionBody is BlockFunctionBody) {
          // Delete `{` and `}`.
          builder
            ..addDeletion(functionBody.block.leftBracket.sourceRange)
            ..addDeletion(functionBody.block.rightBracket.sourceRange);
        } else if (functionBody is ExpressionFunctionBody) {
          // Delete `=>`.
          builder.addDeletion(functionBody.functionDefinition.sourceRange);
        }

        // Delete `*`.
        if (star != null) {
          builder.addDeletion(star.sourceRange);
        }
        // Delete `async`.
        if (keyword != null) {
          builder.addDeletion(keyword.sourceRange);
        }
        // Delete `(...)`.
        if (parameters != null) {
          builder.addDeletion(parameters.sourceRange);
        }
        // Delete `<...>`.
        if (typeParameters != null) {
          builder.addDeletion(typeParameters.sourceRange);
        }
        // Delete `(`.
        builder.addDeletion(
          node.methodName.sourceRange.getMoveEnd(
            node.argumentList.leftParenthesis.length,
          ),
        );
      });
    });
  }
}
