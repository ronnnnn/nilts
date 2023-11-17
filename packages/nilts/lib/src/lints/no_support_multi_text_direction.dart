import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:nilts/src/utils/library_element_ext.dart';

class NoSupportMultiTextDirection extends DartLintRule {
  /// Create a new instance of [NoSupportMultiTextDirection].
  const NoSupportMultiTextDirection() : super(code: _code);

  static const _code = LintCode(
    name: 'no_support_multi_text_direction',
    problemMessage:
        'This configuration is not affected by changes of `TextDirection`.',
    url: 'https://github.com/ronnnnn/nilts#no_support_multi_text_direction',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    // Check for `Alignment`.
    context.registry.addPrefixedIdentifier((node) {
      // Do nothing if the package of class is not `flutter`.
      final library = node.staticType?.element?.library;
      if (library == null) return;
      if (!library.isFlutter) return;

      // Do nothing if the class name is not `Alignment`.
      final isAlignment = node.prefix.name == 'Alignment';
      if (!isAlignment) return;

      // Do nothing if the period is not `.`.
      final operatorToken = node.period;
      if (operatorToken.type != TokenType.PERIOD) return;

      // Do nothing if the variable name is not
      // - `bottomLeft`
      // - `bottomRight`
      // - `centerLeft`
      // - `centerRight`
      // - `topLeft`
      // - `topRight`
      final propertyName = node.identifier.name;
      if (propertyName != 'bottomLeft' &&
          propertyName != 'bottomRight' &&
          propertyName != 'centerLeft' &&
          propertyName != 'centerRight' &&
          propertyName != 'topLeft' &&
          propertyName != 'topRight') {
        return;
      }

      reporter.reportErrorForNode(_code, node);
    });

    // Check for `EdgeInsets`.
    context.registry.addInstanceCreationExpression((node) {
      // Do nothing if the package of constructor is not `flutter`.
      final library = node.constructorName.type.element?.library;
      if (library == null) return;
      if (!library.isFlutter) return;

      // Do nothing if the class is not `EdgeInsets`.
      final isEdgeInsets =
          node.constructorName.type.element?.name == 'EdgeInsets';
      if (!isEdgeInsets) return;

      // Do nothing if the constructor is not named constructor.
      final operatorToken = node.constructorName.period;
      if (operatorToken?.type != TokenType.PERIOD) return;

      // Do nothing if the named constructor name is not
      // - `fromLTRB`
      // - `only`
      final constructorName = node.constructorName.name?.name;
      if (constructorName != 'fromLTRB' && constructorName != 'only') return;

      if (constructorName == 'only') {
        // Do nothing if the constructor has not `left` or `right` parameter.
        if (!_hasLRArgument(node.argumentList)) return;
      }

      reporter.reportErrorForNode(_code, node);
    });

    // Check for `Positioned`.
    context.registry.addInstanceCreationExpression((node) {
      // Do nothing if the package of constructor is not `flutter`.
      final library = node.constructorName.type.element?.library;
      if (library == null) return;
      if (!library.isFlutter) return;

      // Do nothing if the class is not `Positioned`.
      final isEdgeInsets =
          node.constructorName.type.element?.name == 'Positioned';
      if (!isEdgeInsets) return;

      // Do nothing if the named constructor name is not
      // - primary constructor
      // - `fill`
      final constructorName = node.constructorName.name?.name;
      if (constructorName != null && constructorName != 'fill') return;

      // Do nothing if the constructor has not `left` or `right` parameter.
      if (!_hasLRArgument(node.argumentList)) return;

      reporter.reportErrorForNode(_code, node);
    });
  }

  bool _hasLRArgument(ArgumentList argumentList) {
    // Do nothing if the constructor has not `left` or `right` parameter.
    final arguments = argumentList.arguments;
    return arguments.whereType<NamedExpression>().any(
          (argument) =>
              argument.name.label.name == 'left' ||
              argument.name.label.name == 'right',
        );
  }

  @override
  List<Fix> getFixes() => [];
}
