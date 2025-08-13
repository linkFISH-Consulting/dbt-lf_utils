-- Test extracting year from date_col
select {{ lf_utils.year("date_col") }} as output
from {{ ref("_dummy_source") }}

union all

-- Test extracting year from datetime_col
select {{ lf_utils.year("datetime_col") }} as output
from {{ ref("_dummy_source") }}

union all

-- Test that output type is an integer for all backends.
-- However, we cannot return a string - it varies by backend,
-- and our output column is an int, so it cannot take strings.
{% if target.type == "duckdb" %}
    select
        -- duckdb returns 'INTEGER' or BIGINT
        case
            when typeof({{ lf_utils.year("date_col") }}) in ('INTEGER', 'BIGINT') then 1
        end as output
    from {{ ref("_dummy_source") }}
{% elif target.type == "postgres" %}
    select
        -- Postgres returns 'integer'
        case
            when
                pg_typeof({{ lf_utils.year("date_col") }})::text
                in ('integer', 'smallint', 'bigint')
            then 1
        end as output
    from {{ ref("_dummy_source") }}
{% elif target.type == "sqlserver" %}
    select
        case
            when
                sql_variant_property({{ lf_utils.year("date_col") }}, 'BaseType')
                = 'int'
            then 1
        end as output
    from {{ ref("_dummy_source") }}
{% else %}
    -- unknown backend, but we need to close union all
    select 0 as output
{% endif %}
