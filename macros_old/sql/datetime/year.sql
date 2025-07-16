{% macro year(from_date_or_timestamp) -%}
    {{ adapter.dispatch('year', 'lf_utils') (from_date_or_timestamp) }}
{%- endmacro %}

{% macro default__year(from_date_or_timestamp) -%}
    EXTRACT(YEAR FROM {{ from_date_or_timestamp }})
{%- endmacro %}

{% macro oracle__year(from_date_or_timestamp) -%}
    extract(YEAR FROM {{ from_date_or_timestamp }})
{%- endmacro %}

{% macro sqlserver__year(from_date_or_timestamp) -%}
    YEAR({{ from_date_or_timestamp }})
{%- endmacro %}