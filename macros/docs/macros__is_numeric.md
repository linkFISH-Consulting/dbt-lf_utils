{% docs macros__is_numeric %}


Check if a string can be safely cast to a number.

# Arguments
- text : string or string column

# Example
{% raw %}
```sql
lf_utils.is_numeric("'123'") --> True
lf_utils.is_numeric("'123a'") --> False
```
{% endraw %}

# Notes
- To be consistent with mssql and some others, we return 0 or 1, not booleans.
- Does not work with exponential notation or delimiters other than .


{% enddocs %}