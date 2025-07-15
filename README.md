This [dbt](https://github.com/dbt-labs/dbt) package contains macros that can be (re)used across dbt projects.

## Running tests locally

- Copy `config/.env.sample` to `config/.env` and fill in the values (the absolute path of the workspace folder should be enough).

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
```

- stop db servers:
```bash
docker compose -f ./docker-compose.yml down
```

### Restart db servers with database reset:

```
docker-compose down -v && docker-compose up -d
```
