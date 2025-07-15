{# ------------------------------------------------------------------------------
@Author:        F. Paul Spitzner
@Created:       2025-07-14 11:22:02
@Last Modified: 2025-07-14 16:19:01

This is a dummy source, which has to be build before running any tests.
dbt build --select _dummy_source

We override its content in the .yml or specific .sql of each unit test.
It is not ephemeral, as suggested in
https://medium.com/glitni/how-to-unit-test-macros-in-dbt-89bdb5de8634
because we _do not_ want to be forced into using sql syntax to specify rows!
However, dbts tests still need _some_ input model to be provided, and to exist,
even when mocking it 100% via the yml.
------------------------------------------------------------------------------ #}



select 1 as id
