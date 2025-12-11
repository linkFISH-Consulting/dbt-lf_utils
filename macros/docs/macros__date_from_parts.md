{% docs macros__date_from_parts %}

Create a date from year, month, day. In contrast to dbt.date,
this can take integers, but also columns as input.

# Arguments
- year : integer or column
    The year to use, e.g. 2023
- month : integer or column
    The month to use, e.g. 10 for October
- day : integer or column
    The day to use, e.g. 4 for the 4th of the month

# Example

{% raw %}
```sql
select
    {{ lf_utils.date_from_parts(2023, 12, 31) }} as via_integers,
    {{ lf_utils.date_from_parts("year_col", 1, 2) }} as via_mixed,
    {{ lf_utils.date_from_parts("year_col", "month_col", "day_col") }} as via_columns
```
{% endraw %}

{% enddocs %}