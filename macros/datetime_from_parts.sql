{# ------------------------------------------------------------------------------
@Author:        F. Paul Spitzner
@Created:       2025-08-11 13:49:30
@Last Modified: 2026-01-07 20:55:14
------------------------------------------------------------------------------ #}
{# macrodocs

Create a timestamp from year, month, day, hour, minute, second
This can take integers, but also columns as input.

# Arguments
- year : integer or column
    The year to use, e.g. 2023
- month : integer or column
    The month to use, e.g. 10 for October
- day : integer or column
    The day to use, e.g. 4 for the 4th of the month
- hour: integer or column
    Hour, default 0
- minute: integer or column
    Minute, default 0
- second: integer or column
    Second, default 0

# Example

31 Dez 2023 at 16:04:00

```sql
select
    {{ lf_utils.datetime_from_parts(2023, 12, 31, 16, 4) }} as via_integers,
    {{ lf_utils.datetime_from_parts("year_col", 12, 31, 16, 4) }} as via_mixed,
```

endmacrodocs #}

{% macro datetime_from_parts(year, month, day, hour=0, minute=0, second=0) -%}
    {{
        return(
            adapter.dispatch("datetime_from_parts", "lf_utils")(
                year, month, day, hour, minute, second
            )
        )
    }}
{% endmacro %}

{%- macro default__datetime_from_parts(year, month, day, hour, minute, second) -%}
{%- endmacro %}

{%- macro duckdb__datetime_from_parts(year, month, day, hour, minute, second) %}
    make_timestamp(
        cast({{ year }} as int),
        cast({{ month }} as int),
        cast({{ day }} as int),
        cast({{ hour }} as int),
        cast({{ minute }} as int),
        cast({{ second }} as numeric)
    )
{%- endmacro %}

{%- macro sqlserver__datetime_from_parts(year, month, day, hour, minute, second) %}
    datetimefromparts(
        cast({{ year }} as int),
        cast({{ month }} as int),
        cast({{ day }} as int),
        cast({{ hour }} as int),
        cast({{ minute }} as int),
        cast({{ second }} as int),
        0  -- millisecond
    )
{%- endmacro %}

{%- macro postgres__datetime_from_parts(year, month, day, hour, minute, second) %}
    to_timestamp(
        cast({{ year }} as int)::text || '-' ||
        cast({{ month }} as int)::text || '-' ||
        cast({{ day }} as int)::text || ' ' ||
        lpad(cast({{ hour }} as int)::text, 2, '0') || ':' ||
        lpad(cast({{ minute }} as int)::text, 2, '0') || ':' ||
        lpad(cast({{ second }} as numeric)::text, 2, '0'),
        'YYYY-MM-DD HH24:MI:SS'
    )
{%- endmacro %}

{%- macro oracle__datetime_from_parts(year, month, day, hour, minute, second) %}
    to_date(
        cast({{ year }} as int) || '-' ||
        cast({{ month }} as int) || '-' ||
        cast({{ day }} as int) || ' ' ||
        lpad(cast({{ hour }} as int), 2, '0') || ':' ||
        lpad(cast({{ minute }} as int), 2, '0') || ':' ||
        lpad(cast({{ second }} as int), 2, '0'),
        'YYYY-MM-DD HH24:MI:SS'
    )
{%- endmacro %}
