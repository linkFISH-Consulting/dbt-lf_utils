{# ------------------------------------------------------------------------------
@Author:        F. Paul Spitzner
@Created:       2025-08-13 17:32:14
@Last Modified: 2025-08-13 17:35:16
------------------------------------------------------------------------------ #}



{# macrodocs
Extract the month as an integer from a date or timestamp column.
January is 1, December is 12.

# Arguments
- from_date_or_timestamp : date or timestamp
    The column or expression containing the date or timestamp.

# Example
```sql
-- Extract month from a date column
{{ lf_utils.month('my_date_column') }}
```

# Notes
- See also `lf_utils.date_strftime` for more flexible date formatting.

endmacrodocs #}

{% macro month(from_date_or_timestamp) -%}
    {{ return(adapter.dispatch("month", "lf_utils")(from_date_or_timestamp)) }}
{%- endmacro %}

{% macro duckdb__month(from_date_or_timestamp) -%}
    extract('month' from {{ from_date_or_timestamp }})
{%- endmacro %}

{% macro postgres__month(from_date_or_timestamp) -%}
    extract(month from {{ from_date_or_timestamp }})::integer
{%- endmacro %}

{% macro sqlserver__month(from_date_or_timestamp) -%}
    month({{ from_date_or_timestamp }})
{%- endmacro %}
