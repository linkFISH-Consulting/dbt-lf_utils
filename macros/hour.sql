{# ------------------------------------------------------------------------------
@Author:        F. Paul Spitzner
@Created:       2026-01-08 11:46:08
@Last Modified: 2026-01-08 11:57:37
------------------------------------------------------------------------------ #}

{# macrodocs
Extract the hour as an integer from a date or timestamp column.

Returns 0 when the passed object is a date (instead of a timestamp).

# Arguments
- from_date_or_timestamp : date or timestamp
    The column or expression containing the date or timestamp.

# Example
```sql
-- Extract hour from a timestamp column
{{ lf_utils.hour('my_timestamp_column') }}
```

# Notes
- See also `lf_utils.date_strftime` for more flexible date formatting.

endmacrodocs #}

{% macro hour(from_date_or_timestamp) -%}
    {{ return(adapter.dispatch("hour", "lf_utils")(from_date_or_timestamp)) }}
{%- endmacro %}

{% macro duckdb__hour(from_date_or_timestamp) -%}
    extract('hour' from {{ from_date_or_timestamp }})
{%- endmacro %}

{% macro postgres__hour(from_date_or_timestamp) -%}
    extract(hour from cast({{ from_date_or_timestamp }} as timestamp))::integer
{%- endmacro %}

{% macro sqlserver__hour(from_date_or_timestamp) -%}
    datepart(hour, cast({{ from_date_or_timestamp }} as datetime))
{%- endmacro %}
