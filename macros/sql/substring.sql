{% macro substring(fieldName, startPosition, len) %}
    {{ return(adapter.dispatch('substring')(fieldName, startPosition, len)) }}
{% endmacro %}

{%- macro default__substring(fieldName, startPosition, len) %}
{%- endmacro %}

{%- macro oracle__substring(fieldName, startPosition, len) %}
    SUBSTR({{ fieldName }}, {{ startPosition }}, {{ len }})
{%- endmacro %}

{%- macro sqlserver__substring(fieldName, startPosition, len) %}
    SUBSTRING({{ fieldName }}, {{ startPosition }}, {{ len }})
{%- endmacro %}