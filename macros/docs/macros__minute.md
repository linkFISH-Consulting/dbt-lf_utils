{% docs macros__minute %}
Extract the minute as an integer from a date or timestamp column.

Returns 0 when the passed object is a date (instead of a timestamp).

# Arguments
- from_date_or_timestamp : date or timestamp
    The column or expression containing the date or timestamp.

# Example
{% raw %}
```sql
-- Extract minute from a timestamp column
{{ lf_utils.minute('my_timestamp_column') }}
```
{% endraw %}

# Notes
- See also `lf_utils.date_strftime` for more flexible date formatting.

{% enddocs %}