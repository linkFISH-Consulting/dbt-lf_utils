-- Test to verify that date_from_parts returns a proper date type
-- We test this by using date functions on the result
select
    {{ lf_utils.date_from_parts(2023, 8, 11) }} as created_date,
    -- Extract year, month, day to verify it's a proper date
    extract(year from {{ lf_utils.date_from_parts(2023, 8, 11) }}) as year_part,
    extract(month from {{ lf_utils.date_from_parts(2023, 8, 11) }}) as month_part,
    extract(day from {{ lf_utils.date_from_parts(2023, 8, 11) }}) as day_part,
    -- Test date arithmetic (add 1 day)
    {{ lf_utils.date_from_parts(2023, 8, 11) }} + interval '1 day' as date_plus_one
from {{ ref("_dummy_source") }}
