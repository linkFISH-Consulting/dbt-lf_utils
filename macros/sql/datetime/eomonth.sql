{% macro eomonth(from_date_or_timestamp) %}
  {{ return(adapter.dispatch('eomonth', 'lf_utils')(from_date_or_timestamp)) }}
{% endmacro %}

{% macro oracle__eomonth(from_date_or_timestamp) %}
    last_day({{ from_date_or_timestamp }})
{% endmacro %}

{% macro sqlserver__eomonth(from_date_or_timestamp) %}
    EOMONTH({{ from_date_or_timestamp }})
{% endmacro %}