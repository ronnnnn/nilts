## Contribute flows

1. [Create or find an issue](#create-or-find-an-issue)
2. [Fork this repository and setup](#fork-this-repository-and-setup)
3. [Create a branch and make commit your changes](#create-a-branch-and-make-commit-your-changes)
4. [Create a new Pull Request](#create-a-new-pull-request)

## Create or find an issue

Before your contribute, you should find an issue that you want to contribute first.
If you can't find an issue that you want to contribute, you should [create a new issue from here](https://github.com/ronnnnn/nilts/issues/new/choose).

## Fork this repository and setup

Fork this repository and clone it to your local machine.

### Setup asdf (optional)

Using asdf is optional, but you **must** use SDK versions that managed by [`.tool-versions`](https://github.com/ronnnnn/nilts/blob/main/.tool-versions) file.

This project use [asdf](https://asdf-vm.com) to manage Dart and Flutter SDK versions.
If you want to use asdf, you should install asdf.
After you install asdf, you should run below command on the root of this repository.

```bash
asdf install
```

If you are not familiar with asdf, you should read [asdf documentation](https://asdf-vm.com) first.

### Setup Melos

This project build with [Melos](https://melos.invertase.dev).
You should install Melos globally.

```bash
dart pub global activate melos
```

If you are not familiar with Melos, you should read [Melos documentation](https://melos.invertase.dev) first.

### Setup project

You should run only `melos bootstrap` and `melos prepare` commands.

```bash
// You can use `melos bs` instead
melos bootstrap
melos prepare
```

## Create a branch and make commit your changes

You should create a branch from `main` branch and make commit your changes.

### `custom_lint`

nilts is built on the top of [`custom_lint`](https://github.com/invertase/dart_custom_lint) package.
Read `custom_lint` documentation to understand how to debug and test lint rules you created.

- [Using the Dart debugger](https://github.com/invertase/dart_custom_lint#using-the-dart-debugger)
- [Testing your plugins using expect_lint](https://github.com/invertase/dart_custom_lint#testing-your-plugins-using-expect_lint)

### Writing rules

Basically, nilts respects [writing rules of Dart's official lint rules](https://github.com/dart-lang/sdk/blob/main/pkg/linter/doc/writing-lints.md).
You should read it before you create a new lint rule and ensure that your lint rules and documents follows it.

#### Lint Name

Lint name should represent **WHAT IS THE PROBLEM** shortly.
It should be written in `lower_case_with_underscores`.

Lint rule class which extends `LintRule` should be named with `PascalCase`.

**DON'T** start the name with "always", "avoid", or "prefer".

#### Problem Message

Problem message should give details of the problem.

#### Quick Fix Name

Quick fix name should represent **WHAT TO DO** to fix the problem shortly.

Quick fix class which extends `DartFix` should be named with `PascalCase`.

#### Quick Fix Message

Quick fix message should give details of the quick fix.

## Create a new Pull Request

After you make commit your changes, you can create a new Pull Request.
You should write a description of your changes with following [template](https://github.com/ronnnnn/nilts/blob/main/.github/PULL_REQUEST_TEMPLATE.md).
Ensure that all of checks are passed with following check list in the template.
