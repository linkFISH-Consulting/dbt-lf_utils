{% macro calculate_age(date_of_birth, date_column) %}
    {{ return(adapter.dispatch('calculate_age', 'lf_utils')(date_of_birth, date_column)) }}
{% endmacro %}

{%- macro duckdb__calculate_age(date_of_birth, date_column) %}
    date_diff('year', {{ date_of_birth }}, {{ date_column }})
{%- endmacro %}

{%- macro oracle__calculate_age(date_of_birth, date_column) %}
    trunc(months_between({{ date_column }}, TO_DATE({{ date_of_birth }})) / 12)
{%- endmacro %}

{%- macro sqlserver__calculate_age(date_of_birth, date_column) %}
    CASE
        WHEN {{ date_of_birth }} > '1900-01-01' THEN
        (CONVERT(int, CONVERT(char(8), {{ date_column }}, 112)) - CONVERT(char(8), {{ date_of_birth }}, 112)) / 10000
        ELSE NULL
    END
{%- endmacro %}