{% macro left(fieldName, len) %}
    {{ return(adapter.dispatch('left', 'lf_utils')(fieldName, len)) }}
{% endmacro %}

{%- macro duckdb__left(fieldName, len) %}
    left({{ fieldName }}, {{len}})
{%- endmacro %}

{%- macro oracle__left(fieldName, len) %}
    SUBSTR({{ fieldName }}, 1, {{len}})
{%- endmacro %}

{%- macro sqlserver__left(fieldName, len) %}
    LEFT({{ fieldName }}, {{ len }})
{%- endmacro %}
