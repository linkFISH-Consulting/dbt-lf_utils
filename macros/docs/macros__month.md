{% docs macros__month %}

Extract the month as an integer from a date or timestamp column.
January is 1, December is 12.

# Arguments
- from_date_or_timestamp : date or timestamp
    The column or expression containing the date or timestamp.

# Example
{% raw %}
```sql
-- Extract month from a date column
{{ lf_utils.month('my_date_column') }}
```
{% endraw %}

# Notes
- See also `lf_utils.date_strftime` for more flexible date formatting.


{% enddocs %}