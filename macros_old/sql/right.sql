{% macro right(fieldName, len) %}
    {{ return(adapter.dispatch('right', 'lf_utils')(fieldName, len)) }}
{% endmacro %}

{%- macro default__right(fieldName, len) %}
    right({{ fieldName }}, {{ len }})
{%- endmacro %}

{%- macro duckdb__right(fieldName, len) %}
    right({{ fieldName }}, {{len}})
{%- endmacro %}

{%- macro oracle__right(fieldName, len) %}
    SUBSTR({{ fieldName }}, -{{len}})
{%- endmacro %}

{%- macro sqlserver__right(fieldName, len) %}
    RIGHT({{ fieldName }}, {{ len }})
{%- endmacro %}

{%- macro postgres__right(fieldName, len) %}
    right({{ fieldName }},  {{ len }})
{%- endmacro %}