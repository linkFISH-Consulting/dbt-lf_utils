with
    input as (select * from {{ ref("_dummy_source") }}),
    day_diff as (
        select {{ dbt.datediff("date_col", "datetime_col", "day") }} as output
        from input
    ),
    month_diff as (
        select {{ dbt.datediff("date_col", "datetime_col", "month") }} as output
        from input
    ),
    year_diff as (
        select {{ dbt.datediff("date_col", "datetime_col", "year") }} as output
        from input
    )
select output
from day_diff
union all
select output
from month_diff
union all
select output
from year_diff
