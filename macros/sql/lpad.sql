{% macro lpad(fieldName, len, padding = '0') %}
    {{ return(adapter.dispatch('lpad', 'lf_utils')(fieldName, len, padding)) }}
{% endmacro %}

{%- macro default__lpad(fieldName, len, padding) %}
    LPAD(CAST({{ fieldName }} AS varchar(255)), {{ len }}, '{{ padding }}')
{%- endmacro %}

{%- macro duckdb__lpad(fieldName, len, padding) %}
    LPAD(CAST({{ fieldName }} AS varchar(255)), {{ len }}, '{{ padding }}')
{%- endmacro %}

{%- macro oracle__lpad(fieldName, len, padding) %}
    LPAD(CAST({{ fieldName }} AS varchar(255)), {{ len }}, '{{ padding }}')
{%- endmacro %}

{%- macro postgres__lpad(fieldName, len, padding) %}
    LPAD(CAST({{ fieldName }} AS varchar(255)), {{ len }}, '{{ padding }}')
{%- endmacro %}

{%- macro redshift__lpad(fieldName, len, padding) %}
    LPAD(CAST({{ fieldName }} AS varchar(255)), {{ len }}, '{{ padding }}')
{%- endmacro %}

{%- macro sqlserver__lpad(fieldName, len, padding) %}
    RIGHT(REPLICATE('{{ padding }}', {{ len }}) + CAST({{ fieldName }} AS varchar(255)), {{ len }})
{%- endmacro %}