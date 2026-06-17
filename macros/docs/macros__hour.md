{% docs macros__hour %}
Extract the hour as an integer from a date or timestamp column.

Returns 0 when the passed object is a date (instead of a timestamp).

# Arguments
- from_date_or_timestamp : date or timestamp
    The column or expression containing the date or timestamp.

# Example
{% raw %}
```sql
-- Extract hour from a timestamp column
{{ lf_utils.hour('my_timestamp_column') }}
```
{% endraw %}

# Notes
- See also `lf_utils.date_strftime` for more flexible date formatting.

{% enddocs %}