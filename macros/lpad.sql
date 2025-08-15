{# ------------------------------------------------------------------------------
@Author:        F. Paul Spitzner
@Created:       2025-08-14 13:51:11
@Last Modified: 2025-08-14 14:54:06
------------------------------------------------------------------------------ #}

{# macrodocs
Pad a string-column on the left with a specified character to a given length.

# Arguments
- text : column specifier or text
    The column holding the text to be padded
- len : integer or integer column
    The target length of the padded string. Cannot be negative.
- padding : string
    The character to pad with.

# Note
For compatibility across adapters, the input text column is
converted to `varchar(255)` before padding.

# Example
```sql
-- Assume `col_name` holds "foo"
-- Pad to length 5 with zeros
{{ lf_utils.lpad('col_name', 5, "0") }} --> '00foo'

-- If length is smaller than text, we truncate from the right
{{ lf_utils.lpad("col_name", 2, '*') }} --> 'fo'

-- Pad static text but with possibly changing length column
-- e.g. if it holds an 8 for this row
{{ lf_utils.lpad("'static'", "col_with_lens", '*') }}--> '**static'
```

endmacrodocs #}


{% macro lpad(text, len, padding) %}
    {{ return(adapter.dispatch("lpad", "lf_utils")(text, len, padding)) }}
{% endmacro %}

{%- macro duckdb__lpad(text, len, padding) %}
    lpad(cast({{ text }} as varchar(255)), {{ len }}, '{{ padding }}')
{%- endmacro %}

{%- macro postgres__lpad(text, len, padding) %}
    lpad(cast({{ text }} as varchar(255)), {{ len }}, '{{ padding }}')
{%- endmacro %}

{%- macro oracle__lpad(text, len, padding) %}
    lpad(cast({{ text }} as varchar(255)), {{ len }}, '{{ padding }}')
{%- endmacro %}

{%- macro sqlserver__lpad(text, len, padding) %}
    case
        when
            len(cast({{ text }} as varchar(255))) > {{ len }}
        then
            left(cast({{ text }} as varchar(255)), {{ len }})
        else
            right(
                replicate('{{ padding }}', {{ len }}) + cast({{ text }} as varchar(255)),
                {{ len }}
            )
    end
{%- endmacro %}

{%- macro redshift__lpad(text, len, padding) %}
    lpad(cast({{ text }} as varchar(255)), {{ len }}, '{{ padding }}')
{%- endmacro %}

