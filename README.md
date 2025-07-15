# WPCS GitHub Action

> GitHub Action to help you lint your PHP without additional dependencies within your codebase.

[![Support Level](https://img.shields.io/badge/support-active-green.svg)](#support-level) [![Release Version](https://img.shields.io/github/release/10up/wpcs-action.svg)](https://github.com/10up/wpcs-action/releases/latest) [![MIT License](https://img.shields.io/github/license/10up/wpcs-action.svg)](https://github.com/10up/wpcs-action/blob/develop/LICENSE)

## Overview

This action will help you to run phpcs (PHP_CodeSniffer) against [WordPress Coding Standards](https://github.com/WordPress/WordPress-Coding-Standards) with the [GitHub Actions](https://github.com/features/actions) platform.

To make it as simple as possible, this action supports WordPress Coding Standards exclusively and only checks for PHP files. This action doesn't require any change or addition to your source code. It means that you don't need to add composer/phpcs to your plugin or create a PHP CodeSniffer config to use this action.

This is a fork of [chekalsky/phpcs-action](https://github.com/chekalsky/phpcs-action), so this action supports GitHub Action annotations too. All credit goes to
[Ilya Chekalsky](https://github.com/chekalsky).

From v1.3.1, this action can detect the PHPCS custom config and use that config to check the source code. When using the local config, `paths`, `excludes`, and `standard` are ignored.

### ☞ Check out our [collection of WordPress-focused GitHub Actions](https://github.com/10up/actions-wordpress)

## Known Caveats/Issues

### Annotations limit

GitHub allows only 10 warning annotations and 10 error annotations per step. So any warning/error exceeds this threshold won't show on the GitHub Pull Request page.

## Usage

Add the following code to `.github/workflows/wpcs.yml` file.

```yaml
name: WPCS check

on: pull_request

jobs:
  phpcs:
      name: WPCS
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v4
        - name: WPCS check
          uses: 10up/wpcs-action@stable
```

Available options (with default value):

```yaml
        ...
        - name: WPCS check
          uses: 10up/wpcs-action@stable
          with:
            enable_warnings: false # Enable checking for warnings (-w)
            paths: '.' # Paths to check, space separated
            excludes: '' # Paths to excludes, space separated
            standard: 'WordPress' # Standard to use. Accepts WordPress|WordPress-Core|WordPress-Docs|WordPress-Extra|WordPress-VIP-Go|WordPressVIPMinimum|10up-Default.
            standard_repo: '' # Public (git) repository URL of the coding standard
            repo_branch: 'master' # Branch of Standard repository
            phpcs_bin_path: 'phpcs' # Custom PHPCS bin path
            use_local_config: 'false' # Use local config if available
            extra_args: '' # Extra arguments passing to the command
            only_changed_files: '' # Run the linter only on the changed files. Accepts true|false
            only_changed_lines: '' # Run the linter only on the changed lines. Accepts true|false
```

## Examples

### VIP Coding Standards

```yaml
name: WPCS check

on: pull_request

jobs:
  phpcs:
      name: VIPCS
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v4
        - name: VIPCS check
          uses: 10up/wpcs-action@stable
          with:
            standard: 'WordPress-VIP-Go'
```

### Display the linting result in the GitHub Actions summary

```yaml
name: WPCS check

on: pull_request

jobs:
  phpcs:
      name: VIPCS
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v4
        - name: VIPCS check
          uses: 10up/wpcs-action@stable
          with:
            standard: 'WordPress-VIP-Go'
            extra_args: '--report-json=./phpcs.json'
        - name: Update summary
          run: |
            npm i -g github:10up/phpcs-json-to-md
            phpcs-json-to-md --path ./phpcs.json --output ./phpcs.md
            cat phpcs.md >> $GITHUB_STEP_SUMMARY
          if: always()
```

### Exclude specific rule(s) from the used ruleset

Create a custom project ruleset by creating file named `phpcs.xml.dist` in the root directory of the project. The contents of the file should be similar to the following:

```xml
<?xml version="1.0"?>
<ruleset name="Project Rules">
  <rule ref="WordPress">
    <!-- Any of `WordPress|WordPress-Core|WordPress-Docs|WordPress-Extra|WordPress-VIP-Go|WordPressVIPMinimum|10up-Default` -->
    <exclude name="WordPress.Files.FileName.NotHyphenatedLowercase" />
    <exclude name="WordPress.Files.FileName.InvalidClassFileName" />
  </rule>
</ruleset>
```

When setting up the workflow for the project, to use the custom project ruleset, the `use_local_config` arguments will need to be set to `true` to instruct the action to use the local project file. The job configuration should be similar to the following:

```yaml
jobs:
  phpcs:
    name: WPCS
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: WPCS check
        uses: 10up/wpcs-action@stable
        with:
          standard: 'WordPress' # Standard to use. Accepts WordPress|WordPress-Core|WordPress-Docs|WordPress-Extra|WordPress-VIP-Go|WordPressVIPMinimum|10up-Default.
          use_local_config: 'true'
```

### Run linter on changed lines

```yaml
name: WPCS check

on: pull_request

jobs:
  phpcs:
    name: WPCS
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0 # This is very important. Without this the linting of only the changed lines will not work.
      - name: WPCS check
        uses: 10up/wpcs-action@stable
        with:
          standard: 10up-Default
          enable_warnings: true
          only_changed_lines: true
```

## Support Level

**Active:** 10up is actively working on this, and we expect to continue work for the foreseeable future including keeping tested up to the most recent version of WordPress.  Bug reports, feature requests, questions, and pull requests are welcome.

## Changelog

A complete listing of all notable changes to this project are documented in [CHANGELOG.md](https://github.com/10up/wpcs-action/blob/develop/CHANGELOG.md).

## Contributing

Please read [CODE_OF_CONDUCT.md](https://github.com/10up/wpcs-action/blob/develop/CODE_OF_CONDUCT.md) for details on our code of conduct, [CONTRIBUTING.md](https://github.com/10up/wpcs-action/blob/develop/CONTRIBUTING.md) for details on the process for submitting pull requests to us, and [CREDITS.md](https://github.com/10up/wpcs-action/blob/develop/CREDITS.md) for a listing of maintainers, contributors, and libraries for this project.

## Like what you see?

[![Work with the 10up WordPress Practice at Fueled](https://github.com/10up/.github/blob/trunk/profile/10up-github-banner.jpg)](http://10up.com/contact/)
