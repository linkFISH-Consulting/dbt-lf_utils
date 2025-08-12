{# ------------------------------------------------------------------------------
@Author:        F. Paul Spitzner
@Created:       2025-07-18 13:46:56
@Last Modified: 2025-08-11 13:34:35
------------------------------------------------------------------------------ #}

{# macrodocs

Check if a string can be safely cast to a number.

# Arguments
- text : string or string column

# Example
```sql
lf_utils.is_numeric("'123'") --> True
lf_utils.is_numeric("'123a'") --> False
```

# Notes
- To be consistent with mssql and some others, we return 0 or 1, not booleans.
- Does not work with exponential notation or delimiters other than .

endmacrodocs #}
{% macro is_numeric(text) %}
    {{ return(adapter.dispatch("is_numeric", "lf_utils")(text)) }}
{% endmacro %}

{%- macro duckdb__is_numeric(text) %}
    {# Not sure about exponential notation, but this is what the regex would be#}
    {# case when {{ text }} ~ '^[-+]?(\d+(\.\d*)?|\.\d+)([eE][-+]?\d+)?$' then 1 else 0 end #}
    case when {{ text }} ~ '^[-+]?(\d+(\.\d*)?|\.\d+)$' then 1 else 0 end
{%- endmacro %}

{%- macro postgres__is_numeric(text) %}
    {#
    pg does not have try casts, see here:
    https://dba.stackexchange.com/questions/203934/postgresql-alternative-to-sql-server-s-try-cast-function
    and also dbt.safe_cast is affected by this!
    thus, use regexp :/
    #}
    case when {{ text }} ~ '^[-+]?(\d+(\.\d*)?|\.\d+)$' then 1 else 0 end
{%- endmacro %}

{%- macro sqlserver__is_numeric(text) %}
    isnumeric({{ text }})
{%- endmacro %}

{%- macro oracle__is_numeric(text) %}
    validate_conversion({{ text }} as number)
{%- endmacro %}
