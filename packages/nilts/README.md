# nilts

nilts is lint rules, quick fixes and assists for Dart and Flutter projects that helps you enforce best practices, and avoid errors.

---
## Appendix

- [Usage](#usage)
- [Configuration](#configuration)
  - [Disabling strategy](#disabling-strategy)
  - [Enabling strategy](#enabling-strategy)
- [Lint rules and quick fixes](#lint-rules-and-quick-fixes)
  - [Overview](#overview)
  - [Details](#details)
- [Assists](#assists)
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
    - use_media_query_xxx_of: false
```

### Enabling strategy

You can disable all lint rules depends on custom_lint by setting `enable_all_lint_rules` to `false`.  
Add lint rule name and set `true` to enable it.

```yaml
custom_lint:
  # Disable all lint rules depends on custom_lint.
  enable_all_lint_rules: false
  rules:
    - use_media_query_xxx_of: true
```

**NOTE: If you `enable_all_lint_rules` set to `false`, all of lint rules (not only all of nilts's lint rules) depends on `custom_lint` will be disabled by default.**

## Lint rules and quick fixes

Read below to learn about each lint rules intend to.  
Some of lint rules support quick fixes on IDE.

![Quick fix demo](https://github.com/ronnnnn/nilts/blob/main/packages/nilts/resources/quick_fix_demo.gif?raw=true)

### Overview

| Rule name | Description | Target SDK | Quick fix support |
| :-- | :-- | :--: | :--: |
| [use\_media\_query\_xxx\_of](#use_media_query_xxx_of) | Checks `MediaQuery.xxxOf(context)` or `MediaQuery.maybeXxxOf(context)` usages. | Flutter | ⭕️ |

### Details

#### use_media_query_xxx_of

- Target SDK: Flutter
- Quick fix support: ⭕️
  
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
  
See also: [flutter/flutter#114459](https://github.com/flutter/flutter/pull/114459)

## Assists

Upcoming...

## Feature requests

If you have any feature requests, please create [an issue from this template](https://github.com/ronnnnn/nilts/issues/new?&labels=feat&template=feat.yml).

## Bug reports

If you find any bugs, please create [an issue from this template](https://github.com/ronnnnn/nilts/issues/new?&labels=bug&template=bug.yml).

## Contributing

TBD