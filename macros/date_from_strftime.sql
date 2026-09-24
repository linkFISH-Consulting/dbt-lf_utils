{# ------------------------------------------------------------------------------
@Author:        F. Paul Spitzner
@Created:       2026-09-24 11:22:18
@Last Modified: 2026-09-24 12:03:00
------------------------------------------------------------------------------ #}
{# macrodocs
Create a date from a string using a strftime-like format string.
Supports DuckDB, Postgres, and MSSQL (limited patterns).

# Arguments
- date_string: string column or expression containing the date
- format: strftime format string, for example '%Y%m%d'
    currently supported date placeholders:
    - %Y: year (4 digits)
    - %y: year (2 digits)
    - %m: month (01-12)
    - %d: day (01-31)
    - %B: month name (full)
    - %b: month name (abbreviated)

# Example
```sql
{{ lf_utils.date_from_strftime('col_w_date_as_str', '%Y%m%d') }}
```

endmacrodocs #}
{% macro date_from_strftime(date_string, format) %}
    {{ return(adapter.dispatch("date_from_strftime", "lf_utils")(date_string, format)) }}
{% endmacro %}

{# DuckDB parses strftime format strings natively. #}
{% macro duckdb__date_from_strftime(date_string, format) %}
    cast(strptime({{ date_string }}, '{{ format }}') as date)
{% endmacro %}

{# PostgreSQL uses its own, closely related, template pattern syntax. #}
{% macro postgres__date_from_strftime(date_string, format) %}
    {%- set pg_format = (
        format
        | replace("%Y", "YYYY")
        | replace("%y", "YY")
        | replace("%m", "MM")
        | replace("%d", "DD")
        | replace("%B", "FMMonth")
        | replace("%b", "Mon")
    ) -%}
    to_date({{ date_string }}, '{{ pg_format }}')
{% endmacro %}

{# SQL Server has no equivalent parser that accepts a format expression.
Use deterministic style codes for numeric formats and culture-aware parsing
for month names.
https://learn.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-ver17#date-and-time-styles
#}
{% macro sqlserver__date_from_strftime(date_string, format) %}
    {%-   if format == "%m/%d/%y"  -%} try_convert(date, {{ date_string }}, 1)
    {%- elif format == "%m/%d/%Y"  -%} try_convert(date, {{ date_string }}, 101)
    {%- elif format == "%y.%m.%d"  -%} try_convert(date, {{ date_string }}, 2)
    {%- elif format == "%Y.%m.%d"  -%} try_convert(date, {{ date_string }}, 102)
    {%- elif format == "%d/%m/%y"  -%} try_convert(date, {{ date_string }}, 3)
    {%- elif format == "%d/%m/%Y"  -%} try_convert(date, {{ date_string }}, 103)
    {%- elif format == "%d.%m.%y"  -%} try_convert(date, {{ date_string }}, 4)
    {%- elif format == "%d.%m.%Y"  -%} try_convert(date, {{ date_string }}, 104)
    {%- elif format == "%d-%m-%y"  -%} try_convert(date, {{ date_string }}, 5)
    {%- elif format == "%d-%m-%Y"  -%} try_convert(date, {{ date_string }}, 105)
    {%- elif format == "%d %b %y"  -%} try_convert(date, {{ date_string }}, 6)
    {%- elif format == "%d %b %Y"  -%} try_convert(date, {{ date_string }}, 106)
    {%- elif format == "%b %d, %y" -%} try_convert(date, {{ date_string }}, 7)
    {%- elif format == "%b %d, %Y" -%} try_convert(date, {{ date_string }}, 107)
    {%- elif format == "%m-%d-%y"  -%} try_convert(date, {{ date_string }}, 10)
    {%- elif format == "%m-%d-%Y"  -%} try_convert(date, {{ date_string }}, 110)
    {%- elif format == "%y/%m/%d"  -%} try_convert(date, {{ date_string }}, 11)
    {%- elif format == "%Y/%m/%d"  -%} try_convert(date, {{ date_string }}, 111)
    {%- elif format == "%y%m%d"    -%} try_convert(date, {{ date_string }}, 12)
    {%- elif format == "%Y%m%d"    -%} try_convert(date, {{ date_string }}, 112)
    {%- elif format == "%Y-%m-%d"  -%} try_convert(date, {{ date_string }}, 23)
    {%- elif format == "%Y/%m/%d"  -%} try_convert(date, {{ date_string }}, 111)
    {%- elif format == "%d/%m/%Y"  -%} try_convert(date, {{ date_string }}, 103)
    {%- elif format == "%d.%m.%Y"  -%} try_convert(date, {{ date_string }}, 104)
    {%- elif format == "%m/%d/%Y"  -%} try_convert(date, {{ date_string }}, 101)
    {%- elif format == "%Y.%m.%d"  -%} try_convert(date, {{ date_string }}, 102)
    {%- elif format == "%d-%m-%Y"  -%} try_convert(date, {{ date_string }}, 105)
    {%- elif format == "%m-%d-%Y"  -%} try_convert(date, {{ date_string }}, 110)
    {%- else -%}
        try_parse({{ date_string }} as date using 'de-DE')
        {% do exceptions.warn(
            "lf_utils.date_from_strftime: SQL Server does not have a mapping for "
            ~ format
            ~ ". Falling back to TRY_PARSE (de-DE). You can open an issue at: "
            ~ "https://github.com/linkFISH-Consulting/dbt-lf_utils"
        ) %}
    {%- endif -%}
{% endmacro %}
