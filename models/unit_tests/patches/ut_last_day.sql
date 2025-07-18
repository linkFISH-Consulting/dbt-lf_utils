select {{ dbt.last_day("date_col", "month") }} as output
from {{ ref("_dummy_source") }}

union all

select {{ dbt.last_day("date_col", "month") }} as output
from {{ ref("_dummy_source") }}
