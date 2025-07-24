select {{ dbt.length("text") }} as output
from {{ ref("_dummy_source") }}
