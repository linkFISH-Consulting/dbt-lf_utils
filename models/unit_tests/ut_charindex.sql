with input as (
    select
        {{ lf_utils.charindex("substring", "text") }} as pos
    from {{ ref('_dummy_source') }}
)

select
    pos as output
from input
