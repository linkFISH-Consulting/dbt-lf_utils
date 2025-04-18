{% macro month(from_date_or_timestamp) -%}
    {{ adapter.dispatch('month', 'lf_utils') (from_date_or_timestamp) }}
{%- endmacro %}

{% macro duckdb__month(from_date_or_timestamp) -%}
    month({{ from_date_or_timestamp }})
{%- endmacro %}

{% macro oracle__month(from_date_or_timestamp) -%}
    extract(month FROM {{ from_date_or_timestamp }})
{%- endmacro %}

{% macro sqlserver__month(from_date_or_timestamp) -%}
    month({{ from_date_or_timestamp }})
{%- endmacro %}