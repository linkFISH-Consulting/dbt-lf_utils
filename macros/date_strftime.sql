{# macrodocs
A cross-backend macro to format dates using strftime-like format strings.
Supports DuckDB, Postgres, and MSSQL (limited patterns).

# Arguments
- date_col: date/timestamp column
- format: strftime format string (e.g. '%Y%m%d')

# Example
lf_utils.date_strftime('my_date', '%Y%m%d')

endmacrodocs #}
{% macro date_strftime(date_col, format) %}
    {{ return(adapter.dispatch("date_strftime", "lf_utils")(date_col, format)) }}
{% endmacro %}

{# DuckDB: supports strftime natively #}
{% macro duckdb__date_strftime(date_col, format) %}
    strftime({{ date_col }}, '{{ format }}')
{% endmacro %}

{# Postgres: map strftime to to_char format codes #}
{% macro postgres__date_strftime(date_col, format) %}
    {%- set pg_format = (
        format
        | replace("%Y", "YYYY")
        | replace("%m", "MM")
        | replace("%d", "DD")
        | replace("%H", "HH24")
        | replace("%M", "MI")
        | replace("%S", "SS")
        | replace("%B", "FMMonth")
        | replace("%b", "Mon")
    ) -%}
    to_char({{ date_col }}, '{{ pg_format }}')
{% endmacro %}


{% macro sqlserver__date_strftime(date_col, format) %}
    {%- set mssql_format = (
        format
        | replace("%Y", "yyyy")
        | replace("%m", "MM")
        | replace("%d", "dd")
        | replace("%H", "HH")
        | replace("%M", "mm")
        | replace("%S", "ss")
        | replace("%B", "MMMM")
        | replace("%b", "MMM")
    ) -%}
    format({{ date_col }}, '{{ mssql_format }}')
{% endmacro %}
