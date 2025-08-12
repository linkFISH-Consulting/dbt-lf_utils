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
  set -a
  source config/.env
  set +a
  docker compose -f ./docker-compose.yml up -d

  # setup dummy db and debug
  for adapter in $adapters; do
      dbt debug --profile lf_utils_$adapter;
      dbt build --profile lf_utils_$adapter --select _dummy_source;
  done
fi

for adapter in $adapters; do
    dbt test --profile lf_utils_$adapter
done

if [ "$run_setup" = true ]; then
    echo "--------------------------------"
    echo "Docker containers left running for future runs. To stop:"
    echo "docker compose -f ./docker-compose.yml down"
fi
