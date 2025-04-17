{% macro datefromparts(y, m, d) -%}
    {{ return(adapter.dispatch('datefromparts', 'lf_utils')(y, m, d)) }}
{% endmacro %}

{%- macro duckdb__datefromparts(y, m, d) %}
    make_date(CAST({{y}} AS int), CAST({{m}} as int), CAST({{d}} as int))
{%- endmacro %}

{%- macro oracle__datefromparts(y, m, d) %}
    TO_DATE('{{y}}-{{m}}-{{d}}', 'YYYY-MM-DD')
{%- endmacro %}

{%- macro sqlserver__datefromparts(y, m, d) %}
    DATEFROMPARTS({{y}}, {{m}}, {{d}})
{%- endmacro %}
