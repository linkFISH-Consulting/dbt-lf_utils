{% macro eomonth(from_date_or_timestamp) %}
  {{ return(adapter.dispatch('eomonth')(from_date_or_timestamp)) }}
{% endmacro %}

{% macro default__eomonth(from_date_or_timestamp) %}
{% endmacro %}

{% macro oracle__eomonth(from_date_or_timestamp) %}
    last_day({{ from_date_or_timestamp }})
{% endmacro %}

{% macro sqlserver__eomonth(from_date_or_timestamp) %}
    EOMONTH({{ from_date_or_timestamp }})
{% endmacro %}