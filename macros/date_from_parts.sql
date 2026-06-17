{# ------------------------------------------------------------------------------
@Author:        F. Paul Spitzner
@Created:       2025-08-11 13:49:30
@Last Modified: 2025-08-12 12:49:30
------------------------------------------------------------------------------ #}
{# macrodocs

Create a date from year, month, day. In contrast to dbt.date,
this can take integers, but also columns as input.

# Arguments
- year : integer or column
    The year to use, e.g. 2023
- month : integer or column
    The month to use, e.g. 10 for October
- day : integer, column, or the string "last"
    The day to use, e.g. 4 for the 4th of the month, or "last" for the last day of the month

# Example

```sql
select
    {{ lf_utils.date_from_parts(2023, 12, 31) }} as via_integers,
    {{ lf_utils.date_from_parts("year_col", 1, 2) }} as via_mixed,
    {{ lf_utils.date_from_parts("year_col", "month_col", "day_col") }} as via_columns
```

endmacrodocs #}

{% macro date_from_parts(year, month, day) -%}
    {{ return(adapter.dispatch("date_from_parts", "lf_utils")(year, month, day)) }}
{% endmacro %}

{%- macro default__date_from_parts(year, month, day) -%} {%- endmacro %}

{%- macro duckdb__date_from_parts(year, month, day) %}
    {%- if day == 'last' %}
        cast(
            date_trunc(
                'month', make_date(
                    cast({{ year }} as int), cast({{ month }} as int), 1
                )
            )
            + interval '1 month'
            - interval '1 day' as date
        )
    {%- else %}
        make_date(
            cast({{ year }} as int), cast({{ month }} as int), cast({{ day }} as int)
        )
    {%- endif %}
{%- endmacro %}

{%- macro sqlserver__date_from_parts(year, month, day) %}
    {%- if day == 'last' %}
        eomonth(datefromparts(cast({{ year }} as int), cast({{ month }} as int), 1))
    {%- else %}
        datefromparts(
            cast({{ year }} as int), cast({{ month }} as int), cast({{ day }} as int)
        )
    {%- endif %}
{%- endmacro %}

{%- macro postgres__date_from_parts(year, month, day) %}
    {%- if day == 'last' %}
        (
            date_trunc('month', make_date(cast({{ year }} as int), cast({{ month }} as int), 1))
            + interval '1 month - 1 day'
        )::date
    {%- else %}
        to_date(
            cast({{ year }} as int)::text || '-' ||
            cast({{ month }} as int)::text || '-' ||
            cast({{ day }} as int)::text,
            'YYYY-MM-DD'
        )
    {%- endif %}
{%- endmacro %}

{%- macro oracle__date_from_parts(year, month, day) %}
    {%- if day == 'last' %}
        last_day(
            to_date(
                cast({{ year }} as int) || '-' ||
                cast({{ month }} as int) || '-1',
                'YYYY-MM-DD'
            )
        )
    {%- else %}
        to_date(
            cast({{ year }} as int) || '-' ||
            cast({{ month }} as int) || '-' ||
            cast({{ day }} as int),
            'YYYY-MM-DD'
        )
    {%- endif %}
{%- endmacro %}
