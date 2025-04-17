{% macro isnumeric(str) %}
    {{ return(adapter.dispatch('isnumeric')(str)) }}
{% endmacro %}

{%- macro default__isnumeric(fieldName) %}
    ISNUMERIC({{fieldName }})
{%- endmacro %}

{%- macro oracle__isnumeric(fieldName) %}
    VALIDATE_CONVERSION({{ fieldName }} AS NUMBER)
{%- endmacro %}

{%- macro sqlserver__isnumeric(fieldName) %}
    ISNUMERIC({{fieldName }})
{%- endmacro %}

{%- macro postgres__isnumeric(fieldName) %}
    ISNUMERIC({{fieldName }})
{%- endmacro %}