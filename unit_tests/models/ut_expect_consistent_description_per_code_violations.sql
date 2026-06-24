{# Fixture with intentionally inconsistent code/desc data.
   code_category 'A' maps to two different descriptions -> should produce 1 violation. #}
select
    cast('A' as {{ dbt.type_string() }}) as code_category,
    cast('Alpha' as {{ dbt.type_string() }}) as desc_category
union all
select cast('A' as {{ dbt.type_string() }}), cast('Different Alpha' as {{ dbt.type_string() }})
union all
select cast('B' as {{ dbt.type_string() }}), cast('Beta' as {{ dbt.type_string() }})
