"""
Little script to autogenerate dbt models.
Pass the source yaml, and we generate the models in the same folder.
Using filename prefix according to dbt style guide, but you may provide your own.

Dependencies:
```
pip install click
```
"""

# Author:        F. Paul Spitzner
# Email:         paul.spitzner@linkfish.eu
# Created:       2024-11-13
# Last Modified: 2024-11-13

import os
import re
import traceback
from datetime import datetime

import click
import yaml


@click.command(help=__doc__)
@click.argument("yaml_file", type=click.Path(exists=True))
@click.option(
    "--prefix",
    default=None,
    help="Prefix for the model file name. default: stg_{source_name}__",
)
@click.option("--overwrite", is_flag=True, help="Overwrite existing model files.")
@click.option(
    "--snake_case",
    is_flag=True,
    help="Convert model names to snake_case. Changes the names of generated files, but keeps the upstream data table name as specified.",
)
def main(yaml_file, prefix, overwrite, snake_case):
    with open(yaml_file, "r") as file:
        sources = yaml.safe_load(file)

    folder_name = os.path.basename(os.path.dirname(yaml_file))
    print(f"Parsing {yaml_file}\nCreating models in folder: {folder_name}")

    for source in sources.get("sources", []):
        source_name = source.get("name")
        source_prefix = prefix or f"stg_{source_name}__"
        print(
            f"Creating models for source `{source_name}` with prefix: {source_prefix}"
        )

        for table in source.get("tables", []):
            try:
                table_name = table.get("name")
                file_name = f"{source_prefix}{table_name}.sql"
                if snake_case:
                    file_name = f"{source_prefix}{camel_to_snake(table_name)}.sql"
                file_path = os.path.join(folder_name, file_name)

                if os.path.exists(file_path):
                    if overwrite:
                        print(f"Model file already exists, overwriting: {file_path}")
                    else:
                        print(f"Model file already exists, skipping: {file_path}")
                        continue

                # Write the model content to the file
                with open(file_path, "w") as model_file:
                    file_content = model_content(source_name=source_name, table=table)
                    model_file.write(file_content)
                print(f"Created model file: {file_path}")

            except Exception as e:
                print(f"Error creating model for table {table} {e}")
                traceback.print_exc()


model_template = """{header}

{description}

with
source as (select * from {{{{ source('{source_name}', '{table_name}') }}}})

, cte_final as (
    -- only perform light transformations like renaming during the staging.
    -- alter as needed.
    -- by default, the generation script does not overwrite existing files.
    select * from source
)

select * from cte_final
"""


def model_content(source_name: str, table: dict) -> str:
    header = ""
    header += f"-- this file was auto-generated\n"
    # header += f"-- {os.path.realpath(__file__)}\n"
    header += f"-- created on {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n"

    table_name = table.get("name")

    description = table.get("description", None)
    if description is not None:
        description = f"\n-- {description}\n"
    else:
        description = f"\n"

    return model_template.format(
        header=header,
        alias=table_name,
        description=description,
        source_name=source_name,
        table_name=table_name,
    )


def camel_to_snake(name):
    """
    Convert camelCase to snake_case.

    Example
    --------

    ```python
    df = df.rename(
        {col: camel_to_snake(col) for col in df.collect_schema().names()}
    )
    ```

    """
    s1 = re.sub("(.)([A-Z][a-z]+)", r"\1_\2", name)
    s2 = re.sub("([a-z0-9])([A-Z])", r"\1_\2", s1).lower()
    res = re.sub("_+", "_", s2)
    res = res.replace("ä", "ae").replace("ö", "oe").replace("ü", "ue")

    return res


if __name__ == "__main__":
    main()
