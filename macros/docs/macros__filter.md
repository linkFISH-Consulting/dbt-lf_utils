{% docs macros__filter %}

Filter to use in where conditions, to check a column is in a provided array.

If the provided list is empty or not defined, the filter will always be true (1=1).

# Arguments
- col : string
    The column to filter, usually 'table.column'
- in_values : list
    List of values to filter for, usually a variable.
- not_in_values : list
    List of values to filter against (NOT IN), usually a variable.

# Example
{% raw %}
```sql

select
    col_1
from
    my_table
where
    {{ lf_utils.filter(col='my_table.col_1', in_values=[1,2,3]) }}

```
{% endraw %}
{% enddocs %}