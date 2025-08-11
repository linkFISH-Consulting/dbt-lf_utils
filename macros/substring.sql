{# ------------------------------------------------------------------------------
@Author:        F. Paul Spitzner
@Created:       2025-08-11 14:31:06
@Last Modified: 2025-08-11 15:00:54
------------------------------------------------------------------------------ #}
{# macrodocs
Extract characters from a string by position.

# Arguments
- text : string
    The column holding the string, or "'any_static_text'"
- start : integer
    The position to start from, 1-based index. Cannot be negative.
- len : integer
    Column holding a number, or a number. Cannot be negative.

# Example
```sql

select
    -- common use case: text from column, with hardcoded postion and length
    {{ lf_utils.substring("text_col", 7, 4) }} as from_col,

    -- positions defined in columns, too
    {{ lf_utils.substring("text_col", "pos_col", "len_col") }} as from_col_dynamic,

    -- from static text -> 'atic'
    {{ lf_utils.substring("'static'", 3, 4) }} as from_static
```

# Notes
- Also consider using `dbt.split_part`

endmacrodocs #}

{% macro substring(text, start, len) %}
    {{ return(adapter.dispatch("substring")(text, start, len)) }}
{% endmacro %}

{%- macro duckdb__substring(text, start, len) %}
    substring({{ text }}, {{ start }}, {{ len }})
{%- endmacro %}

{%- macro postgres__substring(text, start, len) %}
    substring({{ text }}, {{ start }}, {{ len }})
{%- endmacro %}

{%- macro sqlserver__substring(text, start, len) %}
    substring({{ text }}, {{ start }}, {{ len }})
{%- endmacro %}

{%- macro oracle__substring(text, start, len) %}
    substr({{ text }}, {{ start }}, {{ len }})
{%- endmacro %}
