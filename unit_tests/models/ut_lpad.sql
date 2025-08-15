
-- dynamic column input
select {{ lf_utils.lpad("text", "len", "*") }} as output
from {{ ref("_dummy_source") }}

union all

-- static inputs
select {{ lf_utils.lpad("text", 8, "*") }} as output
from {{ ref("_dummy_source") }}

union all

select {{ lf_utils.lpad("text", 3, "*") }} as output
from {{ ref("_dummy_source") }}

union all

-- static text with dynamic length
select {{ lf_utils.lpad("'static'", "len", "*") }} as output
from {{ ref("_dummy_source") }}


