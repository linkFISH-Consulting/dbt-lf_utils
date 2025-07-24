
-- 112
select {{ lf_utils.date_to_string("date_col", format=112) }} as output
from {{ ref("_dummy_source") }}

union all

select {{ lf_utils.date_to_string("datetime_col", format=112) }} as output
from {{ ref("_dummy_source") }}

union all

-- 112 with len 4
select {{ lf_utils.date_to_string("date_col", format=112, len=4) }} as output
from {{ ref("_dummy_source") }}

union all

select {{ lf_utils.date_to_string("datetime_col", format=112, len=4) }} as output
from {{ ref("_dummy_source") }}

union all

-- 112 with len 6
select {{ lf_utils.date_to_string("date_col", format=112, len=6) }} as output
from {{ ref("_dummy_source") }}

union all

select {{ lf_utils.date_to_string("datetime_col", format=112, len=6) }} as output
from {{ ref("_dummy_source") }}

union all

-- 104
select {{ lf_utils.date_to_string("date_col", format=104) }} as output
from {{ ref("_dummy_source") }}

union all

select {{ lf_utils.date_to_string("datetime_col", format=104) }} as output
from {{ ref("_dummy_source") }}

union all

-- 103
select {{ lf_utils.date_to_string("date_col", format=103) }} as output
from {{ ref("_dummy_source") }}

union all

select {{ lf_utils.date_to_string("datetime_col", format=103) }} as output
from {{ ref("_dummy_source") }}
