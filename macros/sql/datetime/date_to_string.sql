/*
Convert a date column into a string representation, using mssql date format codes.
supported codes:
103 = dd/mm/yyyy
104 = dd.mm.yyyy
112 = yyyymmdd

len argument strips from the right, e.g. format 112 with len 4 gives you yyyy
*/

{% macro date_to_string(dateColumn, format = 112, len = 10) %}
    {{ return(adapter.dispatch('date_to_string', 'lf_utils')(dateColumn, format, len)) }}
{% endmacro %}

{%- macro duckdb__date_to_string(dateColumn, format, len) %}
    {%- if format == 103 %}
        SUBSTR(strftime({{dateColumn}}, '%d/%m/%Y'), 1, {{len}})
    {%- elif format == 104 %}
        SUBSTR(strftime({{dateColumn}}, '%d.%m.%Y'), 1, {{len}})
    {%- elif format == 112 %}
        SUBSTR(strftime({{dateColumn}}, '%Y%m%d'), 1, {{len}})
    {% endif %}
{%- endmacro %}

{%- macro oracle__date_to_string(dateColumn, format, len) %}
    {%- if format == 103 %}
        SUBSTR(TO_CHAR({{dateColumn}}, 'DD/MM/YYYY'), 1, {{len}})
    {%- elif format == 104 %}
        SUBSTR(TO_CHAR({{dateColumn}}, 'DD.MM.YYYY'), 1, {{len}})
    {%- elif format == 112 %}
        SUBSTR(TO_CHAR({{dateColumn}}, 'YYYYMMDD'), 1, {{len}})
    {% endif %}
{%- endmacro %}

{%- macro sqlserver__date_to_string(dateColumn, format, len) %}
    CONVERT(varchar({{ len }}), {{ dateColumn }}, {{ format }})
{%- endmacro %}

{%- macro postgres__date_to_string(dateColumn, format, len) %}
    {%- if format == 103 %}
        SUBSTRING(TO_CHAR({{dateColumn}}, 'dd/mm/yyyy') FROM 1 FOR {{len}})
    {%- elif format == 104 %}
        SUBSTRING(TO_CHAR({{dateColumn}}, 'dd.mm.yyyy') FROM 1 FOR {{len}})
    {%- elif format == 112 %}
        SUBSTRING(TO_CHAR({{dateColumn}}, 'yyyymmdd') FROM 1 FOR {{len}})
    {% endif %}
{%- endmacro %}
