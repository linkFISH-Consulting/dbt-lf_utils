{# ------------------------------------------------------------------------------
@Author:        F. Paul Spitzner
@Created:       2025-07-14 11:22:02
@Last Modified: 2025-07-17 11:01:50

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



select
  1 as id,
  {# the cast to varchar is needed to avoid mssql casting to varchar(1). we cant use varchar(max) because of duckdb.
  varchar without arg seems to compile to `varying` in mssql, which works for the currently used but might have other quirks.
  since tests are small, for now we spec a big number.
  8k is max for mssql.
  #}
  cast('' as varchar(8000)) as text,
  cast('' as varchar(8000)) as substring,
  0 as len
