# ------------------------------------------------------------------------------ #
# @Author:        F. Paul Spitzner
# @Created:       2025-08-15 15:49:04
# @Last Modified: 2025-08-15 15:51:51
# ------------------------------------------------------------------------------ #

# Simple script hacked together that looks at materialized staing tables
# to find which columns are present
# and loosely scans down-stream sql model files for occurrences
# of those column names.
#
# Aim is to replace those `select * ` statements
#
# This does not use column lineage or anything, its only a rough clue.

db_path = "/Users/paul/para/3_Areas/lf_coasti/_bios_coasti.nosync/data/duckdb/haushaltplus/datamart.duckdb"
models_path = "/Users/paul/para/2_Projects/fe_dbt_blueprint/_haushaltplus.nosync/dbt_haushaltplus/models"
schema = "dev_stg_huh"
stageing_folder = "staging"
staging_prefix = "stg_"
# Prefix of file names that does not end up in dwh tables


import os
import re
from collections import defaultdict
from glob import glob

import duckdb



# Get columns from DuckDB for all models in the schema
con = duckdb.connect(database=db_path, read_only=True)
query = f"""
SELECT
    t.table_name,
    c.column_name,
    c.data_type
FROM
    information_schema.tables t
JOIN
    information_schema.columns c
    ON t.table_schema = c.table_schema
    AND t.table_name = c.table_name
WHERE
    t.table_schema = '{schema}'
    AND t.table_type = 'BASE TABLE'
ORDER BY
    t.table_name,
    c.ordinal_position;
"""
results = con.execute(query).fetchall()
con.close()

# Organize columns by model
duckdb_models = defaultdict(list)
max_col_len = 0
max_type_len = 0
for table_name, column_name, data_type in results:
    duckdb_models[table_name].append((column_name, data_type))
    max_col_len = max(max_col_len, len(column_name))
    max_type_len = max(max_type_len, len(data_type))

# Find all staging model SQL files
staging_sql_files = glob(os.path.join(models_path, f"{stageing_folder}/**/*.sql"), recursive=True)

# Map SQL files to DuckDB models by removing prefix
def model_name_from_file(file, prefix):
    name = os.path.splitext(os.path.basename(file))[0]
    if name.startswith(prefix):
        name = name[len(prefix):]
    return name

# Build mapping: model -> columns (from DuckDB)
staging_model_names = set()
for file in staging_sql_files:
    model_name = model_name_from_file(file, staging_prefix)
    if model_name in duckdb_models:
        staging_model_names.add(model_name)

# Find all later-stage model SQL files (not in staging)
later_sql_files = [f for f in glob(os.path.join(models_path, "**/*.sql"), recursive=True) if f"/{stageing_folder}/" not in f]

# For each column, check if it occurs as '.col_name ' in any later-stage model
column_occurs = defaultdict(set)
for file in later_sql_files:
    with open(file, "r") as f:
        sql = f.read()
    for model, columns in duckdb_models.items():
        if model not in staging_model_names:
            continue
        for col, _ in columns:
            # Search for '.col_name ' (with space)
            if re.search(rf"\.{re.escape(col)} ", sql):
                column_occurs[model].add(col)

# Print results with formatting: columns/types from DuckDB, annotate with '*' if used downstream
for model, columns in duckdb_models.items():
    columns.sort(key=lambda x: x[0].lower())
    if model not in staging_model_names:
        continue
    print(f"{model}")
    for col, dtype in columns:
        star = "* " if col in column_occurs[model] else "  "
        print(f"  {star}{col.ljust(max_col_len)}   {dtype.ljust(max_type_len).lower()}")
    print()
