#!/bin/bash

# Check for --setup argument
run_setup=false
for arg in "$@"; do
  if [ "$arg" = "--setup" ]; then
    run_setup=true
    break
  fi
done

adapters="duckdb mssql postgres"

if [ "$run_setup" = true ]; then
  # source the .env to make variables available
  set -a; source config/.env; set +a
  docker compose -f ./docker-compose.yml up -d

  export DBT_PROJECT_DIR=./unit_tests
  dbt deps

  # setup dummy db and debug
  for adapter in $adapters; do
      export DBT_PROFILE=lf_utils_$adapter
      dbt debug
      dbt build --select _dummy_source
  done
fi

for adapter in $adapters; do
    set -a; source config/.env; set +a
    export DBT_PROFILE=lf_utils_$adapter
    export DBT_PROJECT_DIR=./unit_tests
    dbt test
done

if [ "$run_setup" = true ]; then
    echo "--------------------------------"
    echo "Docker containers left running for future runs. To stop:"
    echo "docker compose -f ./docker-compose.yml down"
fi
