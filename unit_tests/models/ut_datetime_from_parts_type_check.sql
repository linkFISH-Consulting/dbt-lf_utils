-- Test to verify that date_from_parts returns a proper date type
-- We test this by using date functions on the result
select
    {{ lf_utils.datetime_from_parts(2023, 8, 11, 16, 4, 0) }} as created_date,
    -- Extract year, month, day to verify it's a proper date. Needs different logic
    -- for mssql
    {% if target.type == "sqlserver" %}
        datepart(year, {{ lf_utils.datetime_from_parts(2023, 8, 11, 16, 4, 0) }}) as year_part,
        datepart(month, {{ lf_utils.datetime_from_parts(2023, 8, 11, 16, 4, 0) }}) as month_part,
        datepart(day, {{ lf_utils.datetime_from_parts(2023, 8, 11, 16, 4, 0) }}) as day_part,
        datepart(hour, {{ lf_utils.datetime_from_parts(2023, 8, 11, 16, 4, 0) }}) as hour_part,
        datepart(minute, {{ lf_utils.datetime_from_parts(2023, 8, 11, 16, 4, 0) }}) as minute_part,
        datepart(second, {{ lf_utils.datetime_from_parts(2023, 8, 11, 16, 4, 0) }}) as second_part,
    {% else %}
        extract(year from {{ lf_utils.datetime_from_parts(2023, 8, 11, 16, 4, 0) }}) as year_part,
        extract(month from {{ lf_utils.datetime_from_parts(2023, 8, 11, 16, 4, 0) }}) as month_part,
        extract(day from {{ lf_utils.datetime_from_parts(2023, 8, 11, 16, 4, 0) }}) as day_part,
        extract(hour from {{ lf_utils.datetime_from_parts(2023, 8, 11, 16, 4, 0) }}) as hour_part,
        extract(minute from {{ lf_utils.datetime_from_parts(2023, 8, 11, 16, 4, 0) }}) as minute_part,
        cast(
            -- seconds might be higher precision than int
            extract(second from {{ lf_utils.datetime_from_parts(2023, 8, 11, 16, 4, 0) }}) as int
        ) as second_part,
    {% endif %}
    -- Check its a date type by using a  date-arithmetic operation
    {{
        dbt.dateadd(
            datepart="minute",
            interval=1,
            from_date_or_timestamp=lf_utils.datetime_from_parts(2023, 8, 11, 16, 4, 0),
        )
    }} as date_plus_one
from {{ ref("_dummy_source") }}
