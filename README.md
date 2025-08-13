This [dbt](https://github.com/dbt-labs/dbt) package contains macros that can be (re)used across dbt projects.

For latest changes, see the [CHANGELOG](CHANGELOG.md).

## Supported Adapters:

- [x] postgres
- [x] mssql
- [x] duckdb
- [ ] oracle (we have some snippets but no tests yet)

## Running tests locally

- Copy `config/.env.sample` to `config/.env` and fill in the values (the absolute path of the workspace folder should be enough).

```
# first run
./test_all_adapters.sh --setup

# future runs
./test_all_adapters.sh

# teardown
docker compose -f ./docker-compose.yml down
```

- ... or to do it manually:

- source the .env to make variables available:
```bash
set -a
source config/.env
set +a
```

- launch database servers via docker:
```bash
docker compose -f ./docker-compose.yml up -d
```

- select dbt profile to run
```bash
# postgres
export DBT_PROFILE=lf_utils_postgres

# mssql
export DBT_PROFILE=lf_utils_mssql

# duckdb (also needs to create the datamart path)
export DBT_PROFILE=lf_utils_duckdb
mkdir -p $(dirname $LF_UTILS__DUCKDB_DATAMART_PATH)
```

- run tests:
```bash
# tests live in their own dbt project (this is a hard requirement of dbt)
export DBT_PROJECT_DIR=./unit_tests
dbt debug
dbt build --select _dummy_source
dbt test

# one-liner
DBT_PROFILE=lf_utils_mssql; DBT_PROJECT_DIR=./unit_tests; dbt debug; dbt build --select _dummy_source; dbt test
```

- stop db servers:
```bash
docker compose -f ./docker-compose.yml down
```

### Restart db servers with database reset:

```bash
docker-compose down -v && docker-compose up -d

# for the impatient:
docker-compose kill && docker-compose down -v && docker-compose up -d
```

This helps when one of the tests failed and left artifacts. For example:
```
[42S01] [Microsoft][ODBC Driver 18 for SQL Server][SQL Server]
There is already an object named 'ut_date_strftime__dbt_tmp' in the database.
(2714) (SQLMoreResults)
```

## Developing


### Custom Macros
- Our custom macros live direclty in the `macros` folder.
- Each macro has one or more unit tests in `unit_tests/models`.
- Tests mostly consist of a `.yml` specifying inputs and expected outputs, and a `.sql` that defines the test logic.
- Most tests rely on the `unit_tests/models/_dummy_source` model, which is a mock table with a few columns and rows that is needed to define the schema of _potential_ inputs. (It's a dbt limitation we have to live with.)

### Patches
- In some cases, we need to add dispatch functions to make other tools work on all our backends.
- The main use case is to make functions from dbt utils work on mssql.
- These dispatch functions live under `macros/patches` with tests in `unit_tests/models/patches`.

### Guidelines:
- Let's not add default adapters. This helps catching errors early, already when developing, and not only running the model and finding broken data.



## Migration

We had a loose collection for macros, this is a list of where they ended up ...

Dbt offers a lot of cross-database macros, we should try to use them, and extend them in the toolbox if they dont work for our needed adapters. [See here](https://docs.getdbt.com/reference/dbt-jinja-functions/cross-database-macros)


### Date functions

- `datefromparts` -> use `lf_utils.date_from_parts`
    - `{{ dbt.date(2023, 10, 4) }}` would be nice, but does not support columns as input.
- `eomonth` -> use `{{ dbt.last_day(date, "month") }}` instead. We here test that it works.
- `dateadd` -> use `{{ dbt.dateadd(datepart, number, from_date_or_timestamp) }}` instead. We here test that it works for dateparts `day`, `month`, `year`.
- `datediff` -> use `{{ dbt.datediff(datepart, from_date_or_timestamp, to_date_or_timestamp) }}` instead. We here test that it works for dateparts `day`, `month`, `year`.
- `year` -> `{{ lf_utils.year }}` (there is also `{{ lf_utils.month }}`)
    - also consider `{{ lf_utils.date_strftime(date, "%Y") }}` for advanced use cases. Cast to int via `cast({{ lf_utils.date_strftime(date, "%Y")) }}, dbt.type_int() }}`

### Strings
- `charindex` -> use `{{ dbt.position(substring, text) }}` instead.
- `concat` -> use `{{ dbt.concat(fields) }}` instead.
- `len` -> use `{{ dbt.length(string) }}` instead. Not tested yet.
- `left` -> use `{{ lf_utils.left(text, len) }}`
- `right` -> use `{{ lf_utils.right(text, len) }}` (wrapper around `dbt.right()`. Somehow they only implement `right` but not `left` but it makes sense to have the same syntax for both)

### Casting

- `cast` -> Should be safe to use with dbt types (see below).
    `cast(value, dbt.type_string())`
    We could also consider using `{{ dbt.cast(value, dbt.type_string()) }}` instead.
- `try_cast` -> use `{{ dbt.safe_cast(value, dbt.type_string()) }}`.
    Ideally, we avoid using this -> dbt.safe_cast does not work with postgres.
    TODO: Maybe add a custom `try_cast` macro for us and make it wrap safe_cast?
    For PG, could add manual checks for a bunch of types and then use normal cast?

## Learnings

### Jinja

Jinja is a pain in the neck.

To pass a static string into a macro:

```sql

{% set my_var = lf_utils.left("fooBar", 3) %}
--> 'foo', but we have to be in a jinja context
```

Things get trickier when in a select statement:
```sql
select
    {{ lf_utils.left("fooBar", 3) }} as output
from input
--> would try to find a column `fooBar` in the input table.

select
    '{{ lf_utils.left("fooBar", 3) }}' as output
from input
--> put a static 'foo' into the output column
```

Sometimes macros can take either fields (column references) or static strings, like the `left` macro:

```sql
select
    {{ lf_utils.left(col1, 3) }} as output
from input
--> would fail because col1 is not set as a jinja variable.

select
    {{ lf_utils.left("col1", 3) }} as output
from input
--> would try to find a column `col1` in the input table.

select
    {{ lf_utils.left("'fooBar'", 3) }} as output
from input
--> would put a static 'fooBar' into the output column
```


## Casting

dbt has some builtin `type_` macros to make casting work across adapters.

Useful references:
- https://docs.getdbt.com/reference/dbt-jinja-functions/cross-database-macros#data-type-functions
- https://github.com/dbt-labs/dbt-core/blob/8019498f0912e9ea921a5579c454e3408764960c/core/dbt/include/global_project/macros/utils/data_types.sql
- https://github.com/dbt-labs/dbt-core/issues/7103

Found the following types:
- `type_timestamp`
- `type_string`
- `type_numeric`
- `type_int`
- `type_bigint`
- `type_float`
- `type_boolean`
- Note that there is no `type_date`, (PS 2025-07-18: I reccon `date` works in all adapters?)

Example:

This works on duckdb, postres and mssql adapters:
```sql
cast('2021-01-01' as date ) as date_col,
cast('2021-01-01 01:01:01' as {{ dbt.type_timestamp() }}) as datetime_col,
cast('' as {{ dbt.type_string() }}) as string_col,
```

strings become `text` in postgres, and `varchar(8000)` in mssql.

Dbt also offers functions: `cast` and `safe_cast` (returns null on error)
```sql
{{ dbt.cast("column_1", api.Column.translate_type("string")) }}
{{ dbt.cast("column_2", api.Column.translate_type("integer")) }}
{{ dbt.cast("'2016-03-09'", api.Column.translate_type("date")) }}
```

