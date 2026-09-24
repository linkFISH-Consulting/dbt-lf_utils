{% docs macros__datetime_from_strftime %}
Create a timestamp from a string using a strftime-like format string.
Supports DuckDB, Postgres, and MSSQL (limited patterns).

# Arguments
- datetime_string: string column or expression containing the timestamp
- format: strftime format string, for example '%Y-%m-%d %H:%M:%S'
    currently supported placeholders:
    - %Y: year (4 digits)
    - %y: year (2 digits)
    - %m: month (01-12)
    - %d: day (01-31)
    - %H: hour (00-23)
    - %I: hour (01-12)
    - %p: AM/PM
    - %M: minute (00-59)
    - %S: second (00-59)
    - %B: month name (full)
    - %b: month name (abbreviated)

# Example
{% raw %}
```sql
{{ lf_utils.datetime_from_strftime('col_with_timestamp_as_str', '%Y-%m-%d %H:%M:%S') }}
```
{% endraw %}

{% enddocs %}