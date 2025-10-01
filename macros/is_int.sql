{# ------------------------------------------------------------------------------
@Author:        F. Paul Spitzner
@Created:       2025-08-14 15:08:07
@Last Modified: 2025-09-11 12:13:07
------------------------------------------------------------------------------ #}

{# macrodocs

Check if a column can be safely cast to an integer.

# Arguments
- text : string or string column

# Example
```sql
lf_utils.is_int("'123'") --> True
lf_utils.is_int("'123a'") --> False
lf_utils.is_int("'123.0'") --> False
```

# Notes
- Returns 0 or 1, not booleans (to be consistent with our `is_numeric` inspired mssql)
- Uses regex for adapters that support it.

endmacrodocs #}

{% macro is_int(text) %}
    {{ return(adapter.dispatch("is_int", "lf_utils")(text)) }}
{% endmacro %}

{%- macro duckdb__is_int(text) %}
    case when {{ text }} ~ '^[-+]?\d+$' then 1 else 0 end
{%- endmacro %}

{%- macro postgres__is_int(text) %}
    case when {{ text }} ~ '^[-+]?\d+$' then 1 else 0 end
{%- endmacro %}

{%- macro sqlserver__is_int(text) %}
    case when isnumeric({{ text }}) = 1 and charindex('.', {{ text }}) = 0 then 1 else 0 end
{%- endmacro %}
