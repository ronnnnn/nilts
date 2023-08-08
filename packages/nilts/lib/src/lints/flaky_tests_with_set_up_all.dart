import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

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
  List<Fix> getFixes() => [];
}
