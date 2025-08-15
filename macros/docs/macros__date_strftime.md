{% docs macros__date_strftime %}
A cross-backend macro to format dates using strftime-like format strings.
Supports DuckDB, Postgres, and MSSQL (limited patterns).

TODO: Think about localisation (Month names)

# Arguments
- date_col: date/timestamp column
- format: strftime format string (e.g. '%Y%m%d')
    currently supported placeholders:
    - %Y: year  (4 digits)
    - %m: month (01-12)
    - %d: day (01-31)
    - %H: hour (00-23)
    - %I: hour (01-12)
    - %p: AM/PM
    - %M: minute (00-59)
    - %S: second (00-59)
    - %B: month name (full)
    - %b: month name (abbreviated)
    - %W: week number (00-53)
        Cannot be combined with other patterns!
        Note, index starts at 0, not 1.

# Example
{% raw %}
```sql
{{ lf_utils.date_strftime('my_date', '%Y%m%d')}}
```
{% endraw %}

{% enddocs %}