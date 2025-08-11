{% docs macros__get_months %}


# Arguments
- start_year : integer
    The year to start from, inclusive
- end_year : integer
    The year to end with, inclusive

# Returns
- table with columns:
    - jahr : integer
    - monat : integer
    - jahrmonat : string
    - jahrmonat_vormonat : string
    - jahrmonat_folgemonat : string
    - jahrmonat_vorjahr : string
    - jahrmonat_folgejahr : string
    - letzter_tag : date (date of the last day of the month)

# Example
{% raw %}
```sql
with months as (
    {{ lf_utils.get_months(2023, 2025) }}
)
select * from months
-- gives a cross-join of all months from jan 2023 to dez 2025
```
{% endraw %}

# Notes
- on ms sql server, we have to use master..spt_values, which can only provide ~ 2k rows.
  to be 100% sure, add a dbt test that the last year is what you expect.


{% enddocs %}