{# ------------------------------------------------------------------------------
@Author:        F. Paul Spitzner
@Created:       2025-10-01 10:57:09
@Last Modified: 2025-10-01 11:06:20
------------------------------------------------------------------------------ #}

{# macrodocs

Filter to use in where conditions, to check a column is in a provided array.

If the provided list is empty or not defined, the filter will always be true (1=1).

# Arguments
- col : string
    The column to filter, usually 'table.column'
- in_values : list
    List of values to filter for, usually a variable.

# Example
```sql

select
    col_1
from
    my_table
where
    {{ lf_utils.filter(col='my_table.col_1', in_values=[1,2,3]) }}

```
endmacrodocs #}

{% macro filter(col, in_values=[]) %}

    {%- if in_values | length > 0 -%}
        {{ col }} in (
            {%- for value in in_values -%}
                {%- if value is string -%}
                    '{{ value }}'
                {%- else -%}
                    {{ value }}
                {%- endif -%}
                {%- if not loop.last -%}, {%- endif -%}
            {%- endfor -%}
        )
    {%- else -%}
        1 = 1
    {%- endif -%}

{% endmacro %}
