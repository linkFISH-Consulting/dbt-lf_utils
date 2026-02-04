-- Test extracting day from date_col
select {{ lf_utils.day("date_col") }} as output, 1 as test_id
from {{ ref("_dummy_source") }}

union all

-- Test extracting day from datetime_col
select {{ lf_utils.day("datetime_col") }} as output, 2 as test_id
from {{ ref("_dummy_source") }}

union all

-- Test that output type is an integer for all backends.
{% if target.type == "duckdb" %}
    select
        case
            when typeof({{ lf_utils.day("date_col") }}) in ('INTEGER', 'BIGINT') then 1
        end as output,
        3 as test_id
    from {{ ref("_dummy_source") }}
{% elif target.type == "postgres" %}
    select
        case
            when
                pg_typeof({{ lf_utils.day("date_col") }})::text
                in ('integer', 'smallint', 'bigint')
            then 1
        end as output,
        3 as test_id
    from {{ ref("_dummy_source") }}
{% elif target.type == "sqlserver" %}
    select
        case
            when
                sql_variant_property({{ lf_utils.day("date_col") }}, 'BaseType')
                = 'int'
            then 1
        end as output,
        3 as test_id
    from {{ ref("_dummy_source") }}
{% endif %}
