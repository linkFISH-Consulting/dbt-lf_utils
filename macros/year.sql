{# ------------------------------------------------------------------------------
@Author:        F. Paul Spitzner
@Created:       2025-08-13 16:36:51
@Last Modified: 2025-08-13 17:32:51
------------------------------------------------------------------------------ #}

{# macrodocs
Extract the year as an integer from a date or timestamp column.

# Arguments
- from_date_or_timestamp : date or timestamp
    The column or expression containing the date or timestamp.

# Example
```sql
-- Extract year from a date column
{{ lf_utils.year('my_date_column') }}
```

# Notes
- See also `lf_utils.date_strftime` for more flexible date formatting.

endmacrodocs #}

{% macro year(from_date_or_timestamp) -%}
    {{ return(adapter.dispatch("year", "lf_utils")(from_date_or_timestamp)) }}
{%- endmacro %}


{% macro duckdb__year(from_date_or_timestamp) -%}
    extract('year' from {{ from_date_or_timestamp }})
{%- endmacro %}

{% macro postgres__year(from_date_or_timestamp) -%}
    -- postgres by default returns a numeric, which could be float
    extract(year from {{ from_date_or_timestamp }})::integer
{%- endmacro %}

{% macro sqlserver__year(from_date_or_timestamp) -%}
    year({{ from_date_or_timestamp }})
{%- endmacro %}

{% macro oracle__year(from_date_or_timestamp) -%}
    extract(year from {{ from_date_or_timestamp }})
{%- endmacro %}
