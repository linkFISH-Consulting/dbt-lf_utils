{# ------------------------------------------------------------------------------
@Author:        F. Paul Spitzner
@Created:       2025-07-18 14:46:33
@Last Modified: 2025-08-11 14:15:06
------------------------------------------------------------------------------ #}
{# macrodocs

# Arguments
- start_year : integer
    The year to start from, inclusive
- end_year : integer
    The year to end with, inclusive

# Returns
- table with columns:
    - jahr : integer
    - monat : integer
    - jahrmonat : string
    - jahrmonat_vormonat : string
    - jahrmonat_folgemonat : string
    - jahrmonat_vorjahr : string
    - jahrmonat_folgejahr : string
    - letzter_tag : date (date of the last day of the month)

# Example
```sql
with months as (
    {{ lf_utils.get_months(2023, 2025) }}
)
select * from months
-- gives a cross-join of all months from jan 2023 to dez 2025
```

# Notes
- on ms sql server, we have to use master..spt_values, which can only provide ~ 2k rows.
  to be 100% sure, add a dbt test that the last year is what you expect.

endmacrodocs #}
{% macro get_months(start_year, end_year) %}
    {{
        return(
            adapter.dispatch("get_months", "lf_utils")(
                start_year | int, end_year | int
            )
        )
    }}
{% endmacro %}


{#
The idea how to do this is simple:
Do cross joins between years and months (cartesian product) so that we cover all
combinations.
#}

/* --------------------------------- duckdb --------------------------------- */
{%- macro duckdb__get_months(start_year, end_year) %}
    select
        jahr,
        monat,
        strftime('%Y%m', make_date(jahr, monat, 1)) as jahrmonat,

        strftime(
            '%Y%m', date_add(make_date(jahr, monat, 1), - interval 1 month)
        ) as jahrmonat_vormonat,
        strftime(
            '%Y%m', date_add(make_date(jahr, monat, 1), interval 1 month)
        ) as jahrmonat_folgemonat,

        strftime(
            '%Y%m', date_add(make_date(jahr, monat, 1), - interval 1 year)
        ) as jahrmonat_vorjahr,
        strftime(
            '%Y%m', date_add(make_date(jahr, monat, 1), interval 1 year)
        ) as jahrmonat_folgejahr,

        cast(
            date_trunc('month', make_date(jahr, monat, 1))
            + interval '1 month'
            - interval '1 day' as date
        ) as letzter_tag

    from generate_series({{ start_year }}, {{ end_year }}) as t1(jahr)
    cross join generate_series(1, 12) as t2(monat)
{%- endmacro %}


/* --------------------------------- postgres --------------------------------- */
{%- macro postgres__get_months(start_year, end_year) %}
    select
        jahr,
        monat,
        to_char(make_date(jahr, monat, 1), 'YYYYMM') as jahrmonat,

        to_char(
            make_date(jahr, monat, 1) - interval '1 month', 'YYYYMM'
        ) as jahrmonat_vormonat,
        to_char(
            make_date(jahr, monat, 1) + interval '1 month', 'YYYYMM'
        ) as jahrmonat_folgemonat,

        to_char(
            make_date(jahr, monat, 1) - interval '1 year', 'YYYYMM'
        ) as jahrmonat_vorjahr,
        to_char(
            make_date(jahr, monat, 1) + interval '1 year', 'YYYYMM'
        ) as jahrmonat_folgejahr,

        (
            date_trunc('month', make_date(jahr, monat, 1)) + interval '1 month - 1 day'
        )::date as letzter_tag

    from generate_series({{ start_year }}, {{ end_year }}) as t1(jahr)
    cross join generate_series(1, 12) as t2(monat)
{%- endmacro %}


/* --------------------------------- sqlserver --------------------------------- */
{%- macro sqlserver__get_months(start_year, end_year) %}
    select
        jahr,
        monat,
        format(datefromparts(jahr, monat, 1), 'yyyyMM') as jahrmonat,

        format(
            dateadd(month, -1, datefromparts(jahr, monat, 1)), 'yyyyMM'
        ) as jahrmonat_vormonat,
        format(
            dateadd(month, 1, datefromparts(jahr, monat, 1)), 'yyyyMM'
        ) as jahrmonat_folgemonat,

        format(
            dateadd(year, -1, datefromparts(jahr, monat, 1)), 'yyyyMM'
        ) as jahrmonat_vorjahr,
        format(
            dateadd(year, 1, datefromparts(jahr, monat, 1)), 'yyyyMM'
        ) as jahrmonat_folgejahr,

        eomonth(datefromparts(jahr, monat, 1)) as letzter_tag

    from
        {# master ..spt_values is just a workaround since we cant
        generate series in old sql server instances. we use row_number()
        because we dont want to care _what numbers_ the table holds, and make sure its
        a sequence ourselves.
        #}
        (
            select
                top({{ end_year }} - {{ start_year }} + 1)
                {{ start_year }}
                - 1
                + row_number() over (order by (select null)) as jahr
            from master..spt_values
        ) as _years
    cross join
        (
            select
                top 12 row_number() over (order by (select null)) as monat
            from master..spt_values
        ) as _months
{%- endmacro %}
