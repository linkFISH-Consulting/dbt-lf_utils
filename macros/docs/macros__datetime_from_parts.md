{% docs macros__datetime_from_parts %}

Create a timestamp from year, month, day, hour, minute, second
This can take integers, but also columns as input.

# Arguments
- year : integer or column
    The year to use, e.g. 2023
- month : integer or column
    The month to use, e.g. 10 for October
- day : integer, column, or the string "last"
    The day to use, e.g. 4 for the 4th of the month, or "last" for the last day of the month
- hour: integer or column
    Hour, default 0
- minute: integer or column
    Minute, default 0
- second: integer or column
    Second, default 0

# Example

31 Dez 2023 at 16:04:00

{% raw %}
```sql
select
    {{ lf_utils.datetime_from_parts(2023, 12, 31, 16, 4) }} as via_integers,
    {{ lf_utils.datetime_from_parts("year_col", 12, 31, 16, 4) }} as via_mixed,
```
{% endraw %}

{% enddocs %}