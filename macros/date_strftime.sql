{# ------------------------------------------------------------------------------
@Author:        F. Paul Spitzner
@Created:       2025-07-17 15:49:52
@Last Modified: 2025-07-18 10:56:35
------------------------------------------------------------------------------ #}

{# macrodocs
A cross-backend macro to format dates using strftime-like format strings.
Supports DuckDB, Postgres, and MSSQL (limited patterns).

TODO: Think about localisation (Month names)

# Arguments
- date_col: date/timestamp column
- format: strftime format string (e.g. '%Y%m%d')
    currently supported placeholders:
    - %Y: year  (4 digits)
    - %m: month (01-12)
    - %d: day (01-31)
    - %H: hour (00-23)
    - %I: hour (01-12)
    - %p: AM/PM
    - %M: minute (00-59)
    - %S: second (00-59)
    - %B: month name (full)
    - %b: month name (abbreviated)
    - %W: week number (00-53)
        Cannot be combined with other patterns!
        Note, index starts at 0, not 1.

# Example
lf_utils.date_strftime('my_date', '%Y%m%d')

endmacrodocs #}

{% macro date_strftime(date_col, format) %}
    {{ return(adapter.dispatch("date_strftime", "lf_utils")(date_col, format)) }}
{% endmacro %}

{# DuckDB: supports strftime natively
https://duckdb.org/docs/stable/sql/functions/dateformat.html#format-specifiers
#}
{% macro duckdb__date_strftime(date_col, format) %}
    strftime({{ date_col }}, '{{ format }}')
{% endmacro %}

{# Postgres: see
https://database.guide/template-patterns-modifiers-for-date-time-formatting-in-postgresql/
#}
{% macro postgres__date_strftime(date_col, format) %}
    {%- set pg_format = (
        format
        | replace("%Y", "YYYY")
        | replace("%m", "MM")
        | replace("%d", "DD")
        | replace("%H", "HH24")
        | replace("%I", "HH12")
        | replace("%p", "AM")
        | replace("%M", "MI")
        | replace("%S", "SS")
        | replace("%B", "FMMonth")
        | replace("%b", "Mon")
        | replace("%W", "WW")
    ) -%}
    to_char({{ date_col }}, '{{ pg_format }}')
{% endmacro %}

{# MSSQL: see
https://database.guide/list-of-the-custom-date-time-format-strings-supported-by-the-format-function-in-sql-server/
#}
{% macro sqlserver__date_strftime(date_col, format) %}
    {%- if format == "%W" -%}
        right('0' + cast(datepart(week, {{ date_col }}) - 1 as varchar), 2)
    {%- else -%}
        {%- set mssql_format = (
            format
            | replace("%Y", "yyyy")
            | replace("%m", "MM")
            | replace("%d", "dd")
            | replace("%H", "HH")
            | replace("%I", "hh")
            | replace("%p", "tt")
            | replace("%M", "mm")
            | replace("%S", "ss")
            | replace("%B", "MMMM")
            | replace("%b", "MMM")
        ) -%}
        format({{ date_col }}, '{{ mssql_format }}')
    {%- endif -%}
{% endmacro %}
