-- Test with all column inputs
select {{ lf_utils.substring("text", "start_col", "len") }} as output
from {{ ref("_dummy_source") }}

union all

-- Test with static string and static positions
select {{ lf_utils.substring("'Static Input'", 1, 6) }} as output
from {{ ref("_dummy_source") }}

union all

-- Test with static string and column positions
select {{ lf_utils.substring("'Static Input'", "start_col", "len") }} as output
from {{ ref("_dummy_source") }}

union all

-- Test with column string and static positions
select {{ lf_utils.substring("text", 7, 4) }} as output
from {{ ref("_dummy_source") }}

union all

-- Test edge case: extract from middle of string
select {{ lf_utils.substring("'Static Input'", 8, 5) }} as output
from {{ ref("_dummy_source") }}

union all

-- Test edge case: extract entire string
select {{ lf_utils.substring("'Static Input'", 1, 99) }} as output
from {{ ref("_dummy_source") }}

union all

-- Test edge case: single character
select {{ lf_utils.substring("'Static Input'", 2, 1) }} as output
from {{ ref("_dummy_source") }}
