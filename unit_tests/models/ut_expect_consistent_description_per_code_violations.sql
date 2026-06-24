{#
Tests that expect_consistent_description_per_code correctly DETECTS violations.

Because the generic test uses dbt_utils.get_filtered_columns_in_relation, which
requires an already-materialised relation, we cannot apply it to an inline CTE.
Instead, we hardcode the equivalent SQL logic against known-bad data so the dbt
unit test framework can assert the exact violation rows the test would return.

Data: code_category 'A' maps to two different descriptions -> 1 violation row.
#}
with
    inconsistent_data as (
        select
            cast('A' as {{ dbt.type_string() }}) as code_category,
            cast('Alpha' as {{ dbt.type_string() }}) as desc_category
        union all
        -- Same code, DIFFERENT desc -> violation
        select cast('A' as {{ dbt.type_string() }}), cast('Different Alpha' as {{ dbt.type_string() }})
        union all
        select cast('B' as {{ dbt.type_string() }}), cast('Beta' as {{ dbt.type_string() }})
    )

select
    cast('code_category' as {{ dbt.type_string() }}) as code_column,
    cast('desc_category' as {{ dbt.type_string() }}) as desc_column,
    cast(code_category as {{ dbt.type_string() }}) as code_value,
    count(distinct desc_category) as unique_desc_count
from inconsistent_data
where code_category is not null
group by code_category
having count(distinct desc_category) > 1
