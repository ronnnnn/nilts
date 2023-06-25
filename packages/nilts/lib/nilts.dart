import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:nilts/src/lints/use_media_query_xxx_of.dart';

PluginBase createPlugin() => _NiltsLint();

class _NiltsLint extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        const UseMediaQueryXxxOf(),
      ];
}
