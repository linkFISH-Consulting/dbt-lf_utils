{% macro get_months(start_year, future_years=1) %}
    {{ return(adapter.dispatch("get_months")(start_year | int, future_years | int)) }}
{% endmacro %}

{%- macro default__get_months(start_year, future_years) %}
-- The get_months Macro does not support your backend!
{%- endmacro %}

{%- macro duckdb__get_months(start_year, future_years) %}
    with
        mon as (
            select
                date_trunc('month', date '{{ start_year }}-01-01')
                + interval (n) month as date_out
            from unnest(generate_series(0, 1000)) as t(n)
        )
    select
        strftime(date_out, '%Y') as jahr,
        strftime(date_out, '%Y%m') as jahrmonat,
        strftime(date_out, '%m') as monat,
        date_out as monaterstertag,
        date_trunc('month', date_out)
        + interval '1 month'
        - interval '1 day' as monatletztertag
    from mon
    where
        date_out <= date_trunc('year', current_date) + interval
        '{{ future_years * 12 }} months' - interval '1 day'
{%- endmacro %}

{%- macro oracle__get_months(start_year, future_years) %}
    with
        mon as (
            select
                add_months(
                    trunc(to_date('{{start_year}}-01-01', 'YYYY-MM-DD'), 'MON'),
                    rownum - 1
                ) date_out
            from
                dual
                connect by add_months(
                    trunc(to_date('{{start_year}}-01-01', 'YYYY-MM-DD'), 'MON'),
                    rownum - 1
                )
                <= trunc(add_months(trunc(current_timestamp, 'YEAR'), {{ future_years * 12 }}) - 1, 'MON')
        )
    select
        to_char(date_out, 'YYYY') as jahr,
        to_char(date_out, 'YYYYMM') as jahrmonat,
        to_char(date_out, 'MM') as monat,
        mon.date_out as monaterstertag,
        last_day(mon.date_out) as monatletztertag
    from mon
{%- endmacro %}

{%- macro sqlserver__get_months(start_year, future_years) %}

    {% set monate = (
        modules.datetime.datetime.now().year + future_years - (start_year)
    ) * 12 %}
    {% set n = dbt_utils.get_powers_of_two(monate) %}

    /* generate row for each month between start and end date */
    with
        p as (
            select 0 as generated_no
            union all
            select 1
        ),
        all_rows as (
            select
                {% for i in range(n) -%}
                    p{{ i }}.generated_no * power(2, {{ i }})
                    {% if not loop.last -%} + {% endif -%}
                {% endfor -%}
                + 1 as generated_no
            from
            {% for i in range(n) -%}
                    p as p{{ i }} {% if not loop.last %} cross join {% endif -%}
            {% endfor -%}
        ),
        generated_rows as (
            select generated_no from all_rows where generated_no <= {{ monate }}
        ),
        generated_months as (
            select
                generated_no,
                case
                    when generated_no % 12 = 0 then 12 else generated_no % 12
                end as monat
            from generated_rows
        ),
        generated_years as (
            select
                generated_no,
                {{ start_year }} + (
                    row_number() over (partition by monat order by generated_no) - 1
                ) as jahr
            from generated_months
        )
    select
        generated_years.jahr,
        convert(
            varchar(6),
            datefromparts(generated_years.jahr, generated_months.monat, 1),
            112
        ) as jahrmonat,
        generated_months.monat as monat,
        datefromparts(generated_years.jahr, generated_months.monat, 1) as monaterstertag
        ,
        eomonth(
            datefromparts(generated_years.jahr, generated_months.monat, 1)
        ) as monatletztertag
    from generated_months
    inner join
        generated_years on generated_months.generated_no = generated_years.generated_no

{%- endmacro %}
