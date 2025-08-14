{% docs macros__year %}

Extract the year as an integer from a date or timestamp column.

# Arguments
- from_date_or_timestamp : date or timestamp
    The column or expression containing the date or timestamp.

# Example
{% raw %}
```sql
-- Extract year from a date column
{{ lf_utils.year('my_date_column') }}
```
{% endraw %}

# Notes
- See also `lf_utils.date_strftime` for more flexible date formatting.


{% enddocs %}