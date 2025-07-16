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
