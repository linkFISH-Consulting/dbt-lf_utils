# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.2] - Upcoming

### Fixed
-   The `generate_docs_from_macrodoc.py` script now extracts the macro name, needed for dbt overwrites (in the patches folder) and handles generic tests

### Added
-   macro: `filter` a column for a list of values.
-   Examples for `environment.yml` files to create a working dbt environment.
-   The `generate_docs_from_macrodoc.py` script now allows extra characters
    around the jinja in/out snippets to allow visual dividiers (see `period_shift_is_consistent.sql` for an example)
-   generic_test: `period_shift_is_consistent`
-   macro: `is_int`, to check if a column can be cast to int.
    gives a 1 or 0, uses regex if possible (cos postgres)
-   macro: `lpad` to left pad a string with a character.
    Note: in the edge case of `length` being shorter than the string, this behaves different than our old version (which truncated from the left). We now truncate from the right - consistent with `lpad` in postgres and duckdb. (`foobar` with length 3 becomes `foo` instead of `bar`).
-   macros: `create_nonclustered_index` and `drop_index`
-   macros: `year` and `month` to extract as integer from a date
-   macros: `dbt__generate_schema_name` and `dbt__generate_alias_name` for our default renames (during materialization). Dont need to be called by the user, dbt should do this automatically. Might have to check the [dispatch search order](https://docs.getdbt.com/reference/dbt-jinja-functions/dispatch#overriding-global-macros).

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

[0.2.2]: https://github.com/linkFISH-Consulting/dbt-lf_utils/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/linkFISH-Consulting/dbt-lf_utils/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/linkFISH-Consulting/dbt-lf_utils/compare/v0.1.0...v0.2.0

