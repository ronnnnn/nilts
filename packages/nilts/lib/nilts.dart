import 'package:custom_lint_builder/custom_lint_builder.dart';

PluginBase createPlugin() => _NiltsLint();

class _NiltsLint extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [];
}
