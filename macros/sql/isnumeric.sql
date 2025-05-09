{% macro isnumeric(str) %}
    {{ return(adapter.dispatch('isnumeric', 'lf_utils')(str)) }}
{% endmacro %}

{%- macro default__isnumeric(fieldName) %}
    ISNUMERIC({{ fieldName }})
{%- endmacro %}

{%- macro duckdb__isnumeric(fieldName) %}
    ( try_cast({{ fieldName }} as double) is not null )
{%- endmacro %}

{%- macro oracle__isnumeric(fieldName) %}
    VALIDATE_CONVERSION({{ fieldName }} AS NUMBER)
{%- endmacro %}

{%- macro sqlserver__isnumeric(fieldName) %}
    ISNUMERIC({{ fieldName }})
{%- endmacro %}

{%- macro postgres__isnumeric(fieldName) %}
    ISNUMERIC({{ fieldName }})
{%- endmacro %}