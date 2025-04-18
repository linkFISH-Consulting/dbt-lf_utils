{% macro get_months(startYear) %}
    {{ return(adapter.dispatch('get_months', 'lf_utils')(startYear)) }}
{% endmacro %}

{%- macro duckdb__get_months(startYear) %}
    WITH mon AS (
        SELECT
            DATE_TRUNC('month', DATE '{{ startYear }}-01-01') + INTERVAL (n) MONTH AS date_out
        FROM UNNEST(GENERATE_SERIES(0, 1000)) AS t(n)
    )
    SELECT
        STRFTIME(date_out, '%Y') AS jahr,
        STRFTIME(date_out, '%Y%m') AS jahrmonat,
        STRFTIME(date_out, '%m') AS monat,
        date_out AS monatErsterTag,
        DATE_TRUNC('month', date_out) + INTERVAL '1 month' - INTERVAL '1 day' AS monatLetzterTag
    FROM mon
    WHERE date_out <= DATE_TRUNC('year', CURRENT_DATE) + INTERVAL '12 months' - INTERVAL '1 day'
{%- endmacro %}

{%- macro oracle__get_months(startYear) %}
WITH mon AS(
SELECT ADD_MONTHS(TRUNC(TO_DATE('{{startYear}}-01-01', 'YYYY-MM-DD'), 'MON'), ROWNUM - 1) date_out
FROM   DUAL
CONNECT BY ADD_MONTHS(TRUNC(TO_DATE('{{startYear}}-01-01', 'YYYY-MM-DD'), 'MON'), ROWNUM - 1)
    <= TRUNC(ADD_MONTHS (TRUNC (CURRENT_TIMESTAMP, 'YEAR'), 12) - 1, 'MON')
)
SELECT
  TO_CHAR(DATE_OUT, 'YYYY') AS jahr
, TO_CHAR(DATE_OUT, 'YYYYMM') AS jahrmonat
, TO_CHAR(DATE_OUT, 'MM') AS monat
, mon.DATE_OUT AS monatErsterTag
, LAST_DAY(mon.DATE_OUT) AS monatLetzterTag
FROM mon
{%- endmacro %}

{%- macro sqlserver__get_months(startYear) %}

  {% set monate = (modules.datetime.datetime.now().year + 1 - (startYear )) * 12 %}
  {% set n = dbt_utils.get_powers_of_two(monate) %}

    /* generate row for each month between start and end date */
    with p as (
        select 0 as generated_no union all select 1
    ),
    all_rows as (
        SELECT
        {% for i in range(n) -%}
        p{{i}}.generated_no * power(2, {{i}})
        {% if not loop.last -%} + {% endif -%}
        {% endfor -%}
        + 1
        AS generated_no
        FROM
        {% for i in range(n) -%}
        p as p{{i}}
        {% if not loop.last %} cross join {% endif -%}
        {% endfor -%}
    )
    , generated_rows AS(
        SELECT generated_no
        FROM all_rows
        WHERE generated_no <= {{monate}}
    )
    , generated_months AS(
        SELECT
        generated_no
        , CASE
            WHEN generated_no % 12 = 0 THEN 12
            ELSE generated_no % 12
        END AS Monat
        FROM generated_rows
    )
    , generated_years AS(
        SELECT
        generated_no
        , {{ startYear }} + (ROW_NUMBER() OVER(PARTITION BY Monat ORDER BY generated_no) - 1) AS Jahr
        FROM generated_months
    )
    SELECT
    generated_years.jahr
    , CONVERT(varchar(6), DATEFROMPARTS (generated_years.jahr, generated_months.Monat, 1), 112) AS jahrmonat
    , generated_months.Monat AS monat
    , DATEFROMPARTS (generated_years.jahr, generated_months.Monat, 1) AS monatErsterTag
    , EOMONTH(DATEFROMPARTS (generated_years.jahr, generated_months.Monat, 1)) AS monatLetzterTag
    FROM generated_months
    INNER JOIN generated_years ON generated_months.generated_no = generated_years.generated_no


{%- endmacro %}
