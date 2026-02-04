{# ------------------------------------------------------------------------------
@Author:        F. Paul Spitzner
@Created:       2025-08-13 17:32:14
@Last Modified: 2026-01-08 11:44:07
------------------------------------------------------------------------------ #}



{# macrodocs
Extract the day as an integer from a date or timestamp column.

# Arguments
- from_date_or_timestamp : date or timestamp
    The column or expression containing the date or timestamp.

# Example
```sql
-- Extract day from a date column
{{ lf_utils.day('my_date_column') }}
```

# Notes
- See also `lf_utils.date_strftime` for more flexible date formatting.

endmacrodocs #}

{% macro day(from_date_or_timestamp) -%}
    {{ return(adapter.dispatch("day", "lf_utils")(from_date_or_timestamp)) }}
{%- endmacro %}

{% macro duckdb__day(from_date_or_timestamp) -%}
    extract('day' from {{ from_date_or_timestamp }})
{%- endmacro %}

{% macro postgres__day(from_date_or_timestamp) -%}
    extract(day from {{ from_date_or_timestamp }})::integer
{%- endmacro %}

{% macro sqlserver__day(from_date_or_timestamp) -%}
    datepart(day, {{ from_date_or_timestamp }})
{%- endmacro %}
