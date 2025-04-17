/* -------------------------------------------------------------------------- *
Author:        Florian Deutsch
Created:       2025-04-17
Last Modified: 2025-04-17
* --------------------------------------------------------------------------- */

{% macro calculate_age(date_of_birth, date_column) %}
    {{ return(adapter.dispatch('calculate_age', 'lf_utils')(date_of_birth, date_column)) }}
{% endmacro %}

{%- macro default__calculate_age(date_of_birth, date_column) %}
{%- endmacro %}

{%- macro oracle__calculate_age(date_of_birth, date_column) %}
    trunc(months_between({{ date_column }}, TO_DATE({{ date_of_birth }})) / 12)
{%- endmacro %}

{%- macro sqlserver__calculate_age(date_of_birth, date_column) %}
    (CONVERT(int, CONVERT(char(8), {{ date_column }}, 112)) - CONVERT(char(8), {{ date_of_birth }}, 112)) / 10000
{%- endmacro %}