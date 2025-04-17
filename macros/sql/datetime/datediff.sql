{% macro datediff(datepart, startdate, enddate) -%}
    {{ return(adapter.dispatch('datediff')(datepart, startdate, enddate)) }}
{% endmacro %}

{%- macro default__datediff(datepart, startdate, enddate) -%}
datediff('{{datepart}}', {{m}}, {{d}})
{%- endmacro %}

{%- macro oracle__datediff(datepart, startdate, enddate) %}
    TO_DATE('{{y}}-{{m}}-{{d}}', 'YYYY-MM-DD')
{%- endmacro %}

