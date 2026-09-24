{% docs macros__date_from_strftime %}
Create a date from a string using a strftime-like format string.
Supports DuckDB, Postgres, and MSSQL (limited patterns).

# Arguments
- date_string: string column or expression containing the date
- format: strftime format string, for example '%Y%m%d'
    currently supported date placeholders:
    - %Y: year (4 digits)
    - %y: year (2 digits)
    - %m: month (01-12)
    - %d: day (01-31)
    - %B: month name (full)
    - %b: month name (abbreviated)

# Example
{% raw %}
```sql
{{ lf_utils.date_from_strftime('col_w_date_as_str', '%Y%m%d') }}
```
{% endraw %}

{% enddocs %}