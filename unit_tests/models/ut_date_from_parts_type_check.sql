-- Test to verify that date_from_parts returns a proper date type
-- We test this by using date functions on the result
select
    {{ lf_utils.date_from_parts(2023, 8, 11) }} as created_date,
    -- Extract year, month, day to verify it's a proper date. Needs different logic
    -- for mssql
    {% if target.type == "sqlserver" %}
        year({{ lf_utils.date_from_parts(2023, 8, 11) }}) as year_part,
        month({{ lf_utils.date_from_parts(2023, 8, 11) }}) as month_part,
        day({{ lf_utils.date_from_parts(2023, 8, 11) }}) as day_part,
    {% else %}
        extract(year from {{ lf_utils.date_from_parts(2023, 8, 11) }}) as year_part,
        extract(month from {{ lf_utils.date_from_parts(2023, 8, 11) }}) as month_part,
        extract(day from {{ lf_utils.date_from_parts(2023, 8, 11) }}) as day_part,
    {% endif %}
    -- Check its a date type by using a  date-arithmetic operation
    {{
        dbt.dateadd(
            datepart="day",
            interval=1,
            from_date_or_timestamp=lf_utils.date_from_parts(2023, 8, 11),
        )
    }} as date_plus_one
from {{ ref("_dummy_source") }}
