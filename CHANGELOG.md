# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.1] - 2025-08-12

### Fixed

-   Tests now live in their own dbt project as suggested by dbt guide. This was needed
    to avoid test models running in projects that install our package.

## [0.2.0] - 2025-08-12

### Fixed

-   The doc generator now adds `{% raw %}` tags around code blocks to avoid compile errors,
    as suggested in [dbt issue #11837](https://github.com/dbt-labs/dbt-core/issues/11837)

### Added

-   macro: `substring`
-   macro: `date_from_parts` because `dbt.date` does not work with columns as input
-   dispatches: `at_least_one` and `equal_row_count` to fix dbt utils tests on mssql.
    We have no tests for these dispatches yet.

## 0.1.0 - 2025-07-24

-   initial commit

[0.2.1]: https://github.com/linkFISH-Consulting/dbt-lf_utils/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/linkFISH-Consulting/dbt-lf_utils/compare/v0.1.0...v0.2.0

