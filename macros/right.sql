{# ------------------------------------------------------------------------------
@Author:        F. Paul Spitzner
@Created:       2025-07-18 13:31:58
@Last Modified: 2025-07-18 13:38:45
------------------------------------------------------------------------------ #}

{# macrodocs
Take the rightmost n characters of a string-column.

# Arguments
- text : string
    The column holding the string, or "'any_static_text'"
- len : integer
    Column holding a number, or a number. Cannot be negative.

# Example

-- text column
lf_utils.right('text', 3)

-- static text
lf_utils.right("'any_static_text'", 10)

# Notes
- This is just a thin wrapper around `dbt.right()`, because
they chose to not implement left, but its convenient to use left and right from the same namespace (our lf_utils)

endmacrodocs #}

{% macro right(text, len) %}
    {{ return(adapter.dispatch('right', 'dbt')(text, len)) }}
{% endmacro %}
