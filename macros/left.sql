{# ------------------------------------------------------------------------------
@Author:        F. Paul Spitzner
@Created:       2025-07-16 09:42:05
@Last Modified: 2025-07-18 13:33:57
------------------------------------------------------------------------------ #}

{# macrodocs
Take the leftmost n characters of a string-column.

# Arguments
- text : string
    The column holding the string, or "'any_static_text'"
- len : integer
    Column holding a number, or a number. Cannot be negative.

# Example

-- text column
lf_utils.left('text', 3)

-- static text
lf_utils.left("'any_static_text'", 3)

endmacrodocs #}

{% macro left(text, len) %}
    {{ return(adapter.dispatch('left', 'dbt')(text, len)) }}
{% endmacro %}

{%- macro duckdb__left(text, len) %}
    left({{ text }}, {{len}})
{%- endmacro %}

{%- macro postgres__left(text, len) %}
    left({{ text }},  {{ len }})
{%- endmacro %}

{%- macro sqlserver__left(text, len) %}
    left({{ text }}, {{ len }})
{%- endmacro %}

{%- macro oracle__left(text, len) %}
    substr({{ text }}, 1, {{len}})
{%- endmacro %}
