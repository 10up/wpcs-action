# Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.0] - 2025-07-15

### Changed

- Switch to a PHP 8 Alpine image in our docker container (props [@iamdharmesh](https://github.com/iamdharmesh), [@dkotter](https://github.com/dkotter) via [#51](https://github.com/10up/wpcs-action/pull/51)).
- Upgrade WordPress Coding Standards to 3.1.0 (props [@sksaju](https://github.com/sksaju), [@mehul0810](https://github.com/mehul0810), [@benlk](https://github.com/benlk), [@thrijith](https://github.com/thrijith), [@s3rgiosan](https://github.com/s3rgiosan), [@iamdharmesh](https://github.com/iamdharmesh), [@dkotter](https://github.com/dkotter), [@jeffpaul](https://github.com/jeffpaul) via [#49](https://github.com/10up/wpcs-action/pull/49)).

### Developer

- Updated GitHub Action workflow permissions (props [@dkotter](https://github.com/dkotter), [@jeffpaul](https://github.com/jeffpaul) via [#50](https://github.com/10up/wpcs-action/pull/50)).

## [1.7.0] - 2024-07-01

### Added

- Arguments to allow the action to run the linter only on changed files or on changed lines (props [@kmgalanakis](https://github.com/kmgalanakis), [@faisal-alvi](https://github.com/faisal-alvi), [@fabiankaegy](https://github.com/fabiankaegy), [@dkotter](https://github.com/dkotter) via [#45](https://github.com/10up/wpcs-action/pull/45)).

### Fixed

- Using "WordPress" standards by installing from proper directory (props [@kmgalanakis](https://github.com/kmgalanakis), [@faisal-alvi](https://github.com/faisal-alvi), [@fabiankaegy](https://github.com/fabiankaegy), [@dkotter](https://github.com/dkotter) via [#47](https://github.com/10up/wpcs-action/pull/47)).

### Developer

- Replaced [lee-dohm/no-response](https://github.com/lee-dohm/no-response) with [actions/stale](https://github.com/actions/stale) to help with closing no-response/stale issues (props [@jeffpaul](https://github.com/jeffpaul), [@dkotter](https://github.com/dkotter) via [#43](https://github.com/10up/wpcs-action/pull/43)).

## [1.6.1] - 2023-08-30

### Fixed

- Clone the 2.3.3 tagged release of the VIPCS package to ensure running VIP scans works (props [@dkotter](https://github.com/dkotter), [@TylerB24890](https://github.com/TylerB24890) via [#37](https://github.com/10up/wpcs-action/pull/37)).

## [1.6.0] - 2023-08-30

### Added

- New example for excluding specific rules in the README file (props [@kmgalanakis](https://github.com/kmgalanakis), [@iamdharmesh](https://github.com/iamdharmesh) via [#32](https://github.com/10up/wpcs-action/pull/32)).

### Changed

- Update docs (props [@jeffpaul](https://github.com/jeffpaul), [@faisal-alvi](https://github.com/faisal-alvi) via [#30](https://github.com/10up/wpcs-action/pull/30)).

### Fixed

- Clone the 2.3.0 tagged branch of the WordPress Coding Standards (props [@dkotter](https://github.com/dkotter), [@iamdharmesh](https://github.com/iamdharmesh), [@GaryJones](https://github.com/GaryJones) via [#34](https://github.com/10up/wpcs-action/pull/34)).

## [1.5.0] - 2023-06-12

### Added

- Include WP VIP coding standards with 10up-Default sniffs (props [@peterwilsoncc](https://github.com/peterwilsoncc), [@cadic](https://github.com/cadic), [@dkotter](https://github.com/dkotter), [@jeffpaul](https://github.com/jeffpaul) via [#25](https://github.com/10up/wpcs-action/pull/25)).

### Changed

- GitHub Actions summary example in README.md (props [@iamdharmesh](https://github.com/iamdharmesh), [@peterwilsoncc](https://github.com/peterwilsoncc), [@B-Interactive](https://github.com/B-Interactive), [@dinhtungdu](https://github.com/dinhtungdu), [@jeffpaul](https://github.com/jeffpaul) via [#27](https://github.com/10up/wpcs-action/pull/27)).

## [1.4.0] - 2022-11-23

### Added

- Support of 10up-Default ruleset (props [@cadic](https://github.com/cadic), [@jeffpaul](https://github.com/jeffpaul), [@peterwilsoncc](https://github.com/peterwilsoncc) via [#21](https://github.com/10up/wpcs-action/pull/21)).

### Fixed

- Action failure with PHP8 (props [@cadic](https://github.com/cadic), [@jeffpaul](https://github.com/jeffpaul), [@dkotter](https://github.com/dkotter), [@dinhtungdu](https://github.com/dinhtungdu), [@iamdharmesh](https://github.com/iamdharmesh), [@peterwilsoncc](https://github.com/peterwilsoncc) via [#20](https://github.com/10up/wpcs-action/pull/20)).

### Other

- Add release workflow (props [@dinhtungdu](https://github.com/dinhtungdu), [@jeffpaul](https://github.com/jeffpaul), [@Sidsector9](https://github.com/Sidsector9) via [#17](https://github.com/10up/wpcs-action/pull/17)).

## [1.3.4] - 2022-06-14

### Added

- `EXTRA_ARGS` flag to support custom arguments (props [@dinhtungdu](https://github.com/dinhtungdu) via [#12](https://github.com/10up/wpcs-action/pull/12)).

## [1.3.3] - 2022-04-12

### Fixed

- Wrong branch used in examples.
- Docs: Update supported standards.

## [1.3.2] - 2021-07-13

### Fixed

- VIPCS detection issue.

## [1.3.1] - 2021-06-29

### Added

- Detect local phpcs config. This is disabled by default. Enable it by setting `use_local_config` to 'true'.
- `phpcs_bin_path` option to use local PHPCS.

### Removed

- `is_vipcs` option. From this version, `wpcs-action` checks against VIPCS automatically if the `standard` option set to `WordPress-VIP-Go` or `WordPressVIPMinimum`.

## [1.3.0] - 2021-06-29

### Added

- Support WordPress Coding Standard exclusively.
- Support Custom Standards.
- Support VIPCS. Enable VIPCS check by using `is_vipcs` options.

### Removed

- `phpcs_bin_path` and `installed_paths` options.

[Unreleased]: https://github.com/10up/wpcs-action/compare/stable...develop
[2.0.0]: https://github.com/10up/wpcs-action/compare/v1.7.0...v2.0.0
[1.7.0]: https://github.com/10up/wpcs-action/compare/v1.6.1...v1.7.0
[1.6.1]: https://github.com/10up/wpcs-action/compare/v1.6.0...v1.6.1
[1.6.0]: https://github.com/10up/wpcs-action/compare/v1.5.0...v1.6.0
[1.5.0]: https://github.com/10up/wpcs-action/compare/v1.4.0...v1.5.0
[1.4.0]: https://github.com/10up/wpcs-action/compare/v1.3.4...v1.4.0
[1.3.4]: https://github.com/10up/wpcs-action/compare/v1.3.3...v1.3.4
[1.3.3]: https://github.com/10up/wpcs-action/compare/v1.3.2...v1.3.3
[1.3.2]: https://github.com/10up/wpcs-action/compare/v1.3.1...v1.3.2
[1.3.1]: https://github.com/10up/wpcs-action/compare/v1.3.0...v1.3.1
[1.3.0]: https://github.com/10up/wpcs-action/compare/v1.2.0...v1.3.0
