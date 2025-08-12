-- Test with column inputs from reference
select {{ lf_utils.date_from_parts("year_col", "month_col", "day_col") }} as output
from {{ ref("_dummy_source") }}

union all

-- Test with direct integer (jinja) inputs
select {{ lf_utils.date_from_parts(2023, 12, 25) }} as output
from {{ ref("_dummy_source") }}

union all

-- Test with mixed inputs (column and integer)
select {{ lf_utils.date_from_parts("year_col", 6, 15) }} as output
from {{ ref("_dummy_source") }}

union all

-- Test edge case: leap year (Feb 29)
select {{ lf_utils.date_from_parts(2024, 2, 29) }} as output
from {{ ref("_dummy_source") }}

union all

-- Test edge case: last day of year
select {{ lf_utils.date_from_parts(2023, 12, 31) }} as output
from {{ ref("_dummy_source") }}
