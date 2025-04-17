{% macro len(fieldName) -%}
    {{ adapter.dispatch('len', 'lf_utils') (fieldName) }}
{%- endmacro %}

{% macro default__len(fieldName) -%}
    LENGTH({{ fieldName }})
{%- endmacro %}

{% macro oracle__len(fieldName) -%}
    LENGTH({{ fieldName }})
{%- endmacro %}

{% macro sqlserver__len(fieldName) -%}
    LEN({{ fieldName }})
{%- endmacro %}

{% macro postgres__len(fieldName) -%}
    LENGTH({{ fieldName }})
{%- endmacro %}
