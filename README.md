This [dbt](https://github.com/dbt-labs/dbt) package contains macros that can be (re)used across dbt projects.

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
dbt debug
dbt build --select _dummy_source
dbt test

# one-liner
DBT_PROFILE=lf_utils_mssql; dbt debug; dbt build --select _dummy_source; dbt test
```

- stop db servers:
```bash
docker compose -f ./docker-compose.yml down
```

### Restart db servers with database reset:

```
docker-compose down -v && docker-compose up -d
```

## Developing



### Guidelines:
- Let's not add default adapters. This helps catching errors early, already when developing, and not only running the model and finding broken data.



## Migration

We had a loose collection for macros, this is a list of where they ended up ...



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

Example:

This works on duckdb, postres and mssql adapters:
```sql
cast('2021-01-01' as date ) as date_col,
cast('2021-01-01 01:01:01' as {{ dbt.type_timestamp() }}) as datetime_col,
cast('' as {{ dbt.type_string() }}) as string_col,
```

strings become `text` in postgres, and `varchar(8000)` in mssql.
