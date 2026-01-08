{# ------------------------------------------------------------------------------
@Author:        F. Paul Spitzner
@Created:       2026-01-08 11:46:32
@Last Modified: 2026-01-08 11:58:48
------------------------------------------------------------------------------ #}

{# macrodocs
Extract the minute as an integer from a date or timestamp column.

Returns 0 when the passed object is a date (instead of a timestamp).

# Arguments
- from_date_or_timestamp : date or timestamp
    The column or expression containing the date or timestamp.

# Example
```sql
-- Extract minute from a timestamp column
{{ lf_utils.minute('my_timestamp_column') }}
```

# Notes
- See also `lf_utils.date_strftime` for more flexible date formatting.

endmacrodocs #}

{% macro minute(from_date_or_timestamp) -%}
    {{ return(adapter.dispatch("minute", "lf_utils")(from_date_or_timestamp)) }}
{%- endmacro %}

{% macro duckdb__minute(from_date_or_timestamp) -%}
    extract('minute' from {{ from_date_or_timestamp }})
{%- endmacro %}

{% macro postgres__minute(from_date_or_timestamp) -%}
    extract(minute from cast({{ from_date_or_timestamp }} as timestamp))::integer
{%- endmacro %}

{% macro sqlserver__minute(from_date_or_timestamp) -%}
    datepart(minute, cast({{ from_date_or_timestamp }} as datetime))
{%- endmacro %}
