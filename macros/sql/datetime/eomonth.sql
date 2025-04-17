{% macro eomonth(from_date_or_timestamp) %}
  {{ return(adapter.dispatch('eomonth', 'lf_utils')(from_date_or_timestamp)) }}
{% endmacro %}

{%- macro duckdb__eomonth(from_date_or_timestamp) -%}
  date_trunc(
    'day',
    date_trunc('month', {{ from_date_or_timestamp }})
    + interval 1 month - interval 1 day
  )
{%- endmacro -%}

{% macro oracle__eomonth(from_date_or_timestamp) %}
    TRUNC(last_day({{ from_date_or_timestamp }}))
{% endmacro %}

{% macro sqlserver__eomonth(from_date_or_timestamp) %}
    EOMONTH({{ from_date_or_timestamp }})
{% endmacro %}