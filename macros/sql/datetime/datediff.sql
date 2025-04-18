{% macro datediff(first_date, second_date, datepart) %}
  {{ return(adapter.dispatch('datediff', 'lf_utils')(first_date, second_date, datepart)) }}
{% endmacro %}

{% macro default__datediff(first_date, second_date, datepart) -%}
    dbt.datediff({{ first_date }}, {{ second_date }}, {{ datepart }})
{%- endmacro %}

{%- macro oracle__datediff(first_date, second_date, datepart) %}

    {% if datepart == "day" %}
        ROUND({{first_date}} - {{second_date}}, 0)
    {% elif datepart == "month" %}
        MONTHS_BETWEEN({{first_date}}, {{second_date}})     
    {% elif datepart == "year" %}
        EXTRACT(YEAR FROM {{first_date}}) - EXTRACT(YEAR FROM {{second_date}})
    {% endif %}
    
{%- endmacro %}

{%- macro sqlserver__datediff(first_date, second_date, datepart) %}
        DATEDIFF({{datepart}}, {{first_date}}, {{second_date}})
{%- endmacro %}