{% docs macros__date_to_string %}

Convert a date column into a string representation, using MSSQL date format codes.

# Deprication Notice
Only kept for historic reasons, better use `date_strftime`.

# Arguments
- date_col : date/timestamp column
    The date column to convert to string
- format : int, default 112 (cannot be a column)
    Supported codes:
    - 103 = dd/mm/yyyy
    - 104 = dd.mm.yyyy
    - 112 = yyyymmdd
    - "MMMM yyyy" = Month Year (e.g. "January 2025")
- len : int, or int-column, default 10
    Length to truncate result to. For example, format 112 with len=4 returns just the year (yyyy)

# Example

{% raw %}
```sql
-- Convert date to yyyymmdd string
lf_utils.date_to_string('my_date', 112)

-- Get just the year from a date
lf_utils.date_to_string('my_date', 112, 4)

-- Get date in dd.mm.yyyy format
lf_utils.date_to_string('my_date', 104)

-- Get month and year in text format
lf_utils.date_to_string('my_date', 'MMMM yyyy')
```
{% endraw %}


{% enddocs %}