{# ------------------------------------------------------------------------------
@Author:        F. Paul Spitzner
@Created:       2025-08-13 16:08:21
@Last Modified: 2025-08-14 10:46:36
------------------------------------------------------------------------------ #}

{# TODO: add Tests. PS 2025-08-14: no clue how to do this,
since this is a db operation and I currently dont know how to check if index was
created in dbt unit test. maybe a two-stage thing, first build a model that uses
our macro, then add a test that only checks and depends on the model #}

{# macrodocs
Create a nonclustered index.

# Arguments
- columns : list of strings
    Columns to be indexed.
- includes : list of strings (optional)
    Additional columns to include in the index (where supported).

# Example
```sql
{{ lf_utils.create_nonclustered_index(['col1', 'col2'], ['col3']) }}
```

# Notes
- [What's a Non-Clustered Index](https://www.geeksforgeeks.org/sql/clustered-and-non-clustered-indexing/)
- [SO on non-clustered includes](https://stackoverflow.com/questions/1307990/why-use-the-include-clause-when-creating-an-index)

endmacrodocs #}
{% macro create_nonclustered_index(columns, includes = []) %}
    {{
        return(
            adapter.dispatch("create_nonclustered_index", "lf_utils")(columns, includes)
        )
    }}
{% endmacro %}

{%- macro postgres__create_nonclustered_index(columns, includes) %}
    {# PostgreSQL does not have clustered/nonclustered index distinction;
    create index creates a nonclustered index by default #}
    create index
        {{ this.table }}__index_on_{{ columns | join("_") }}
    on
        {{ this }} ({{ columns | join(", ") }})
    {%- if includes | length > 0 %}
        include ({{ includes | join(", ") }})
        {# includes supported in PostgreSQL 11+ #}
    {%- endif %}
{%- endmacro %}

{%- macro duckdb__create_nonclustered_index(columns, includes) %}
    {# DuckDB create index syntax (no include clause support) #}
    create index
        {{ this.table }}__index_on_{{ columns | join("_") }}
    on {{ this }} ({{ columns | join(", ") }})
{%- endmacro %}

{%- macro sqlserver__create_nonclustered_index(columns, includes) %}

    create nonclustered index
        {{ this.table }}__index_on_{{ columns | join("_") }}
    on
        {{ this }} ({{ '[' + columns | join("], [") + ']' }})
    {%- if includes | length > 0 %}
        include
            ({{ '[' + includes | join("], [") + ']' }})
    {% endif %}

{%- endmacro %}


{%- macro oracle__create_nonclustered_index(columns, includes) %}
    create index
        {{ this.table }}__index_on_{{ columns | join("_") }}
    on
        {{ this }} ({{ '"' + (columns + includes) | join('","') + '"' }})
{%- endmacro %}
