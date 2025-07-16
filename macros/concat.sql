{% macro concat(fields) -%}
    {{ return(adapter.dispatch('concat')(fields)) }}
{% endmacro %}

{%- macro duckdb__concat(fields) %}
    {{ fields|join(' || ') }}
{%- endmacro %}

{%- macro postgres__concat(fields) %}
    {{ fields|join(' || ') }}
{%- endmacro %}

{%- macro sqlserver__concat(fields) %}
    concat({{ fields|join(', ') }})
{%- endmacro %}

{%- macro oracle__concat(fields) %}
    {{ fields|join(' || ') }}
{%- endmacro %}
