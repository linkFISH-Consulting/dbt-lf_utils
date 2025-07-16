{% macro calculate_age(date_of_birth, date_column) %}
    {{ return(adapter.dispatch("calculate_age")(date_of_birth, date_column)) }}
{% endmacro %}

{%- macro default__calculate_age(date_of_birth, date_column) %}
-- The calculate_age Macro does not support your backend!
{%- endmacro %}

{%- macro duckdb__calculate_age(date_of_birth, date_column) %}
    date_diff('year', {{ date_of_birth }}, {{ date_column }})
{%- endmacro %}

{%- macro oracle__calculate_age(date_of_birth, date_column) %}
    trunc(months_between({{ date_column }}, to_date({{ date_of_birth }})) / 12)
{%- endmacro %}

{%- macro sqlserver__calculate_age(date_of_birth, date_column) %}
    case
        when {{ date_of_birth }} > '1900-01-01'
        then
            (
                convert(int, convert(char(8), {{ date_column }}, 112))
                - convert(char(8), {{ date_of_birth }}, 112)
            )
            / 10000
        else null
    end
{%- endmacro %}
