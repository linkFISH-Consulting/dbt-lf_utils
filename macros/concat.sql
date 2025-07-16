{% macro concat(fields) -%}
    {{ return(adapter.dispatch('concat')(fields)) }}
{% endmacro %}

{%- macro default__concat(fields) -%}
    {{ fields|join(' || ') }}
{%- endmacro %}

{%- macro oracle__concat(fields) %}
    {{ fields|join(' || ') }}
{%- endmacro %}

{%- macro sqlserver__concat(fields) %}
    CONCAT({{ fields|join(', ') }})
{%- endmacro %}
