# nilts

nilts is lint rules, quick fixes and assists for Dart and Flutter projects that helps you enforce best practices, and avoid errors.

---
## Contents

- [Usage](#usage)
- [Configuration](#configuration)
  - [Disabling strategy](#disabling-strategy)
  - [Enabling strategy](#enabling-strategy)
- [Lint rules and quick fixes](#lint-rules-and-quick-fixes)
  - [Overview](#overview)
  - [Details](#details)
- [Assists](#assists)
- [Feature requests](#feature-requests)
- [Bug reports](#bug-reports)
- [Contributing](#contributing)

## Usage

nilts depends on [`custom_lint`](https://github.com/invertase/dart_custom_lint).  
You should add `nilts` and `custom_lint` to your `dev_dependencies` in `pubspec.yaml` file.

```yaml
dev_dependencies:
  custom_lint: <version>
  nilts: <version>
```

And also, add `custom_lint` to your `analysis_options.yaml` file.

```yaml
analyzer:
  plugins:
    - custom_lint
```

## Configuration

You can configure all lint rules provided by `nilts` in `analysis_options.yaml` file.  
Choice one of the following configuration strategies.

### Disabling strategy

All of `nilts` rules are enabled by default.  
Add lint rule name and set `false` to disable it.

```yaml
custom_lint:
  rules:
    # Disable particular lint rules if you want ignore them whole package.
    - unnecessary_rebuilds_from_media_query: false
```

### Enabling strategy

You can disable all lint rules depends on custom_lint by setting `enable_all_lint_rules` to `false`.  
Add lint rule name and set `true` to enable it.

```yaml
custom_lint:
  # Disable all lint rules depends on custom_lint.
  enable_all_lint_rules: false
  rules:
    - unnecessary_rebuilds_from_media_query: true
```

**NOTE: If you `enable_all_lint_rules` set to `false`, all of lint rules (not only all of nilts's lint rules) depends on `custom_lint` will be disabled by default.**

## Lint rules and quick fixes

Read below to learn about each lint rules intend to.  
Some of lint rules support quick fixes on IDE.

![Quick fix demo](https://github.com/ronnnnn/nilts/blob/main/packages/nilts/resources/quick_fix_demo.gif?raw=true)

### Overview

| Rule name | Overview | Target SDK | Rule type | Maturity level | Quick fix |
| :-- | :-- | :--: | :--: | :--: | :--: |
| [unnecessary\_rebuilds\_from\_media\_query](#unnecessary_rebuilds_from_media_query) | Checks `MediaQuery.xxxOf(context)` or `MediaQuery.maybeXxxOf(context)` usages. | >= Flutter 3.10.0 (Dart 3.0.0) | Practice | Experimental | ✅️ |
| [flaky\_tests\_with\_set\_up\_all](#flaky_tests_with_set_up_all) | Checks `setUpAll` usages. | Any versions nilts supports | Practice | Experimental | ✅️ |

### Details

#### unnecessary_rebuilds_from_media_query

- Target SDK: >= Flutter 3.10.0 (Dart 3.0.0)
- Rule type: Practice
- Maturity level: Experimental
- Quick fix: ✅
  
**Prefer** using `MediaQuery.xxxOf(context)` or `MediaQuery.maybeXxxOf(context)` instead of `MediaQuery.of(context)` or `MediaQuery.maybeOf(context)` to avoid unnecessary rebuilds.

**BAD:**

```dart
final size = MediaQuery.of(context).size;
```


**GOOD:**

```dart
final size = MediaQuery.sizeOf(context);
```

Note that using `MediaQuery.of(context)` or `MediaQuery.maybeOf(context)` makes sense in case of observing `MediaQueryData` object changes or referring to many properties of `MediaQueryData`.  
  
See also:  

- [MediaQuery as InheritedModel by moffatman · Pull Request #114459 · flutter/flutter](https://github.com/flutter/flutter/pull/114459)
- [MediaQuery class - widgets library - Dart API](https://api.flutter.dev/flutter/widgets/MediaQuery-class.html)

#### flaky_tests_with_set_up_all

- Target SDK: Any versions nilts supports
- Rule type: Practice
- Maturity level: Experimental
- Quick fix: ✅

**Consider** using `setUp` function or initialization on top level or body of test group.
`setUpAll` may cause flaky tests with concurrency executions.

**BAD:**
```dart
setUpAll(() {
  // ...
});
```

**GOOD:**
```dart
setUp(() {
  // ...
});
```

```dart
void main() {
  // do initialization on top level
  // ...

 group('...', () {
  // or do initialization on body of test group
  // ...
 });
}
```

See also:

- [setUpAll function - flutter_test library - Dart API](https://api.flutter.dev/flutter/flutter_test/setUpAll.html)
- [setUp function - flutter_test library - Dart API](https://api.flutter.dev/flutter/flutter_test/setUp.html)

## Assists

Upcoming... 🚀

## Feature requests

If you have any feature requests, please create [an issue from this template](https://github.com/ronnnnn/nilts/issues/new?&labels=feat&template=feat.yml).

## Bug reports

If you find any bugs, please create [an issue from this template](https://github.com/ronnnnn/nilts/issues/new?&labels=bug&template=bug.yml).

## Contributing

Welcome your contributions!!  
Please read [CONTRIBUTING](https://github.com/ronnnnn/nilts/blob/main/CONTRIBUTING.md) docs before submitting your PR.
