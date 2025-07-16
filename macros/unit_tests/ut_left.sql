with input as (
    select * from {{ ref('_dummy_source') }}
)

select
    {{ lf_utils.left("text", "len") }} as output
from input
