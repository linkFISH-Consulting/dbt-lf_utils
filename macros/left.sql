{# ------------------------------------------------------------------------------
@Author:        F. Paul Spitzner
@Created:       2025-07-16 09:42:05
@Last Modified: 2025-07-16 14:32:53
------------------------------------------------------------------------------ #}

{# macrodocs
Take the leftmost n characters of a string-column.

# Arguments
- text : string
    The column holding the string, or "'any_static_text'"
- len : integer
    Column holding a number, or a number. Cannot be negative.

# Example
```sql
-- text column
select {{ lf_utils.left('text', 10) }} as output

-- static text
select {{ lf_utils.left("'any_static_text'", 10) }} as output
```
endmacrodocs #}

{% macro left(text, len) %}
    {{ return(adapter.dispatch('left', 'lf_utils')(text, len)) }}
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
