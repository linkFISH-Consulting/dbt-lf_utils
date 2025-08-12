with input as (
    select
        {{ dbt.position("substring", "text") }} as pos
    from {{ ref('_dummy_source') }}
)

select
    pos as output
from input
