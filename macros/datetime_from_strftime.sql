{# ------------------------------------------------------------------------------
@Author:        F. Paul Spitzner
@Created:       2026-09-24 12:00:00
------------------------------------------------------------------------------ #}
{# macrodocs
Create a timestamp from a string using a strftime-like format string.
Supports DuckDB, Postgres, and MSSQL (limited patterns).

# Arguments
- datetime_string: string column or expression containing the timestamp
- format: strftime format string, for example '%Y-%m-%d %H:%M:%S'
    currently supported placeholders:
    - %Y: year (4 digits)
    - %y: year (2 digits)
    - %m: month (01-12)
    - %d: day (01-31)
    - %H: hour (00-23)
    - %I: hour (01-12)
    - %p: AM/PM
    - %M: minute (00-59)
    - %S: second (00-59)
    - %B: month name (full)
    - %b: month name (abbreviated)

# Example
```sql
{{ lf_utils.datetime_from_strftime('col_with_timestamp_as_str', '%Y-%m-%d %H:%M:%S') }}
```

endmacrodocs #}
{% macro datetime_from_strftime(datetime_string, format) %}
    {{ return(adapter.dispatch("datetime_from_strftime", "lf_utils")(datetime_string, format)) }}
{% endmacro %}

{# DuckDB parses strftime format strings natively. #}
{% macro duckdb__datetime_from_strftime(datetime_string, format) %}
    strptime({{ datetime_string }}, '{{ format }}')
{% endmacro %}

{# PostgreSQL uses its own, closely related, template pattern syntax. #}
{% macro postgres__datetime_from_strftime(datetime_string, format) %}
    {%- set pg_format = (
        format
        | replace("%Y", "YYYY")
        | replace("%y", "YY")
        | replace("%m", "MM")
        | replace("%d", "DD")
        | replace("%H", "HH24")
        | replace("%I", "HH12")
        | replace("%p", "AM")
        | replace("%M", "MI")
        | replace("%S", "SS")
        | replace("%B", "FMMonth")
        | replace("%b", "Mon")
        | replace("T", '"T"')
    ) -%}
    to_timestamp({{ datetime_string }}, '{{ pg_format }}')
{% endmacro %}

{# SQL Server does not accept a format expression for parsing. Use documented
style codes for common date and timestamp conventions, then warn on fallback. #}
{% macro sqlserver__datetime_from_strftime(datetime_string, format) %}
    {%- if format == "%Y-%m-%d %H:%M:%S" -%}
        try_convert(datetime2, {{ datetime_string }}, 120)
    {%- elif format == "%Y-%m-%dT%H:%M:%S" -%}
        try_convert(datetime2, {{ datetime_string }}, 126)
    {%- elif format == "%m/%d/%y" -%}
        try_convert(datetime2, {{ datetime_string }}, 1)
    {%- elif format == "%m/%d/%Y" -%}
        try_convert(datetime2, {{ datetime_string }}, 101)
    {%- elif format == "%y.%m.%d" -%}
        try_convert(datetime2, {{ datetime_string }}, 2)
    {%- elif format == "%Y.%m.%d" -%}
        try_convert(datetime2, {{ datetime_string }}, 102)
    {%- elif format == "%d/%m/%y" -%}
        try_convert(datetime2, {{ datetime_string }}, 3)
    {%- elif format == "%d/%m/%Y" -%}
        try_convert(datetime2, {{ datetime_string }}, 103)
    {%- elif format == "%d.%m.%y" -%}
        try_convert(datetime2, {{ datetime_string }}, 4)
    {%- elif format == "%d.%m.%Y" -%}
        try_convert(datetime2, {{ datetime_string }}, 104)
    {%- elif format == "%d-%m-%y" -%}
        try_convert(datetime2, {{ datetime_string }}, 5)
    {%- elif format == "%d-%m-%Y" -%}
        try_convert(datetime2, {{ datetime_string }}, 105)
    {%- elif format == "%m-%d-%y" -%}
        try_convert(datetime2, {{ datetime_string }}, 10)
    {%- elif format == "%m-%d-%Y" -%}
        try_convert(datetime2, {{ datetime_string }}, 110)
    {%- elif format == "%y/%m/%d" -%}
        try_convert(datetime2, {{ datetime_string }}, 11)
    {%- elif format == "%Y/%m/%d" -%}
        try_convert(datetime2, {{ datetime_string }}, 111)
    {%- elif format == "%y%m%d" -%}
        try_convert(datetime2, {{ datetime_string }}, 12)
    {%- elif format == "%Y%m%d" -%}
        try_convert(datetime2, {{ datetime_string }}, 112)
    {%- else -%}
        try_parse({{ datetime_string }} as datetime2 using 'de-DE')
        {% do exceptions.warn(
            "lf_utils.datetime_from_strftime: SQL Server does not have a mapping for "
            ~ format
            ~ ". Falling back to TRY_PARSE (de-DE). You can open an issue at: "
            ~ "https://github.com/linkFISH-Consulting/dbt-lf_utils"
        ) %}
    {%- endif -%}
{% endmacro %}
