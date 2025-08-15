{% docs macros__is_int %}

Check if a column can be safely cast to an integer.

# Arguments
- text : string or string column

# Example
{% raw %}
```sql
lf_utils.is_int("'123'") --> True
lf_utils.is_int("'123a'") --> False
lf_utils.is_int("'123.0'") --> False
```
{% endraw %}

# Notes
- Returns 0 or 1, not booleans (to be consistent with our `is_numeric` inspired mssql)
- Uses regex for adapters that support it.

{% enddocs %}