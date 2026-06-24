{#
Fixture model for the expect_consistent_description_per_code generic test.

The test macro uses dbt_utils.get_filtered_columns_in_relation to introspect
this model's columns at test-compile time, so the model must be materialized
before tests run. With `dbt build` (used in test_all_adapters.ps1 / .sh) dbt
builds the model first, then compiles and runs the test — the correct order.

Data intent: code_category -> desc_category is a CONSISTENT mapping.
The generic test must find 0 violations (test PASSES).
#}
select
    cast('A' as {{ dbt.type_string() }}) as code_category,
    cast('Alpha' as {{ dbt.type_string() }}) as desc_category
union all
select cast('B' as {{ dbt.type_string() }}), cast('Beta' as {{ dbt.type_string() }})
union all
-- Same code, same desc repeated — still consistent
select cast('A' as {{ dbt.type_string() }}), cast('Alpha' as {{ dbt.type_string() }})
