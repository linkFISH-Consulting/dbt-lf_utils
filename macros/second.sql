{# ------------------------------------------------------------------------------
@Author:        F. Paul Spitzner
@Created:       2026-01-08 11:46:58
@Last Modified: 2026-01-08 12:01:09
------------------------------------------------------------------------------ #}

{# macrodocs
Extract the second as an integer from a date or timestamp column.

Returns 0 when the passed object is a date (instead of a timestamp).


# Arguments
- from_date_or_timestamp : date or timestamp
    The column or expression containing the date or timestamp.

# Example
```sql
-- Extract second from a timestamp column
{{ lf_utils.second('my_timestamp_column') }}
```

# Notes
- See also `lf_utils.date_strftime` for more flexible date formatting.

endmacrodocs #}

{% macro second(from_date_or_timestamp) -%}
    {{ return(adapter.dispatch("second", "lf_utils")(from_date_or_timestamp)) }}
{%- endmacro %}

{% macro duckdb__second(from_date_or_timestamp) -%}
    extract('second' from {{ from_date_or_timestamp }})
{%- endmacro %}

{% macro postgres__second(from_date_or_timestamp) -%}
    extract(second from cast({{ from_date_or_timestamp }} as timestamp))::integer
{%- endmacro %}

{% macro sqlserver__second(from_date_or_timestamp) -%}
    datepart(second, cast({{ from_date_or_timestamp }} as datetime))
{%- endmacro %}
