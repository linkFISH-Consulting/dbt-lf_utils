{# ------------------------------------------------------------------------------
@Author:        F. Paul Spitzner
@Created:       2025-07-17 10:17:44
@Last Modified: 2025-07-17 11:05:21
------------------------------------------------------------------------------ #}

{# macrodocs
Find the first position of a substring in a string.

Returns 0 if the substring is not found.
If found, index starts counting at 1.

# Arguments
- substring : string
    The substring to search for.
- text : string
    The string to be searched.

# Example

-- text column
lf_utils.charindex('foo', col1)

-- column with static text
lf_utils.charindex('bar', "'foobar'")

endmacrodocs #}


{% macro charindex(substring, text) -%}
    {{ return(adapter.dispatch('charindex')(substring, text)) }}
{% endmacro %}

{% macro duckdb__charindex(substring, text) -%}
    position({{ substring }} in {{ text }})
{% endmacro %}

{% macro postgres__charindex(substring, text) -%}
    position({{ substring }} in {{ text }})
{% endmacro %}

{% macro sqlserver__charindex(substring, text) -%}
    charindex({{ substring }}, {{ text }})
{% endmacro %}

