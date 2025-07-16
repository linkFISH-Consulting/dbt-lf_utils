{% macro left(text, len) %}
    {{ return(adapter.dispatch('left', 'lf_utils')(text, len)) }}
{% endmacro %}

{%- macro default__left(text, len) %}
    left({{ text }}, {{ len }})
{%- endmacro %}

{%- macro duckdb__left(text, len) %}
    left({{ text }}, {{len}})
{%- endmacro %}

{%- macro oracle__left(text, len) %}
    SUBSTR({{ text }}, 1, {{len}})
{%- endmacro %}

{%- macro sqlserver__left(text, len) %}
    LEFT({{ text }}, {{ len }})
{%- endmacro %}

{%- macro postgres__left(text, len) %}
    left({{ text }},  {{ len }})
{%- endmacro %}
