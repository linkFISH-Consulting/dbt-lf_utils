{# ------------------------------------------------------------------------------
@Author:        F. Paul Spitzner
@Created:       2025-07-14 11:22:02
@Last Modified: 2025-07-18 13:09:39

This is a dummy source, which has to be build before running any tests.
dbt build --select _dummy_source

We override its content in the .yml or specific .sql of each unit test.
It is not ephemeral, as suggested in
https://medium.com/glitni/how-to-unit-test-macros-in-dbt-89bdb5de8634
because we _do not_ want to be forced into using sql syntax to specify rows!
However, in any case, dbts tests still need _some_ input model to be
provided, and to exist, even when mocking it 100% via the yml.

Further, dbt checks the schema of this model, and if a column is not
defined, we cannot mock it. Thus, we add a bunch of columns that we might
need.
------------------------------------------------------------------------------ #}



{# casts are only used to fix the schema and datatype of the table.
values still need to be provided in the .yml of the test! #}
select
  1 as id,
  cast('' as {{ dbt.type_string() }}) as text,
  cast('' as {{ dbt.type_string() }}) as substring,
  cast('2021-01-01 01:01:01' as {{ dbt.type_timestamp() }}) as datetime_col,
  cast('2021-01-01' as date ) as date_col,
  0 as len
